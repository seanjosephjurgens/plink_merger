# PLINK2 Merger for UK Biobank RAP
##### Developed by Sean J Jurgens. Amsterdam UMC / Broad Institute of MIT and Harvard.
---
#### Obtaining and installing the applet

Clone this github repo to a local directory:
```
git clone https://github.com/seanjosephjurgens/plink_merger
```

Navigate to a relevant directory within the project directory on the DNAnexus platform to install the applet
```
dx cd /path/to/install/apps 
```

Now you are ready to build and upload the applet to the DNAnexus plaform directory:
```
dx build -f plink_merger
```
---
#### Command line usage
Navigate to the RAP directory where you want the output to be directed:
```
dx cd /path/to/where/the/output/should/go
```
Note priority is set to high below which is recommended for long processes to avoid jobs potentially being reset when running as normal priority jobs (see [`dx run`](https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities#run) on changing job priority):

```
dx run /path/to/install/apps/plink_merger \
  -iplink_file_list=/path/to/vcf/file/list.txt \
  -imerged_plink_filename=my_data_merged \
  --priority high \
  -y
```
