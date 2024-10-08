#!/bin/bash
# vcf_merger 0.0.1
# Andrew R Wood
# University of Exeter
# No warrenty provided!
# App will run on a single machine from beginning to end.

main() {

    echo "File containing PLINK2 file list: plink_file_list: '$plink_file_list'"
    echo "Name of output file: '$merged_plink_filename'"

    # Download file with PLINK2 list to worker
    dx download "$plink_file_list" -o plink_file_list

    # Download all VCFs to worker
    readarray -t arr < plink_file_list
    for f in "${arr[@]}"
    do
        dx download -f -a $DX_PROJECT_CONTEXT_ID:"${f}.pgen"
        dx download -f -a $DX_PROJECT_CONTEXT_ID:"${f}.pvar"
        dx download -f -a $DX_PROJECT_CONTEXT_ID:"${f}.psam"
    done

    # Path to PLINK2 binary
    #dx download file-Gpb62bjJ5F2X4442kzp3Gyfy
    #unzip plink2_linux_avx2_20240625.zip
    dx download project-G8PjJkjJ5F2xY1f648Pj4JQx:/genome_500k_DRAGEN/04_plink/plink2_linux_avx2_20240818.zip
    unzip plink2_linux_avx2_20240818.zip

    # Create new file containing the vcfs stripped of the original directory path
    awk 'BEGIN{FS="/"}{print $NF}' plink_file_list > plink_filenames_inter.txt
    awk '{ print $1".pgen", $1".pvar", $1".psam" }' plink_filenames_inter.txt > plink_filenames.txt

    # Perform the concatenation
    echo "using ${threads} threads!"
    ./plink2 \
    --pmerge-list plink_filenames.txt \
    --threads ${threads} \
    --keep-allele-order \
    --multiallelics-already-joined \
    --make-pgen \
    --out merged_plink

    mv merged_plink.pgen pgen
    mv merged_plink.pvar pvar
    mv merged_plink.psam psam

    pgen_filename="${merged_plink_filename}.pgen"
    pvar_filename="${merged_plink_filename}.pvar"
    psam_filename="${merged_plink_filename}.psam"

    echo "PGEN outfile is: "$pgen_filename
    echo "PVAR outfile is: "$pvar_filename
    echo "PSAM outfile is: "$psam_filename
    
    # Upload the GDS file to the project directory
    pgen=$(dx upload pgen --brief --path ./$pgen_filename)
    dx-jobutil-add-output pgen "$pgen" --class=file

    pvar=$(dx upload pvar --brief --path ./$pvar_filename)
    dx-jobutil-add-output pvar "$pvar" --class=file

    psam=$(dx upload psam --brief --path ./$psam_filename)
    dx-jobutil-add-output psam "$psam" --class=file

}

