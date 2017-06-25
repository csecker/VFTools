#!/bin/bash

usage="Usage: vf_v6tov8_restructure_results <source_foldername> <output foldername>\nHas to be run in the folder in which the source folder is located."

# Checking the input arguments
if [ "${1}" == "-h" ]; then
    echo -e "\n${usage}\n\n"
    exit 0
fi

if [ "$#" -ne "2" ]; then
    echo -e "Wrong number of input arguments. Exiting...\n"
    echo -e "${usage}\n\n"
    exit 1
fi


# Standard error response 
error_response_std() {
    echo
    echo "Error was trapped" 1>&2
    echo "Error in bash script $(basename ${BASH_SOURCE[0]})" 1>&2
    echo "Error on line $1" 1>&2
    echo -e "Exiting.\n\n"
    exit 0
}
trap 'error_response_std $LINENO' ERR


# Printing some information
echo
echo
echo "************************************************************"
echo "               Restructuring the results folder             "
echo "************************************************************"
echo

# Variables
source_folder=${1%/}
output_folder=${2%/}

# Folders
mkdir -p ${output_folder}
for collection in $(ls ${source_folder}); do 
    tranch=${collection/_*}
    echo " * Creating temporary folder for tranch ${tranch} in ${output_folder}.tmp"
    cd ${source_folder}/${tranch}
    if [ ! "$(ls -A ./)" ]; then
        echo "No file in folder ${source_folder}/${tranch}, skipping"
        cd ../.. 
        continue
    fi
    mkdir -p ${source_folder}.tmp/${tranch}
    echo " Copying the file "
    cp  ${source_folder}/${tranch}/* ../../${output_folder}.tmp/
    cd ../..
for collection in $(ls ${source_folder}); do
    

# Copying the files
for tranch in $(ls ${source_folder}); do
    if [ -f  ${output_folder}/${tranch}.tar ]; then
        echo "Archive for ${tranch} already exists, skipping."
        continue
    fi
    echo " * Creating tar archive ${tranch}.tar"
    cd ${source_folder}/${tranch}
    if [ ! "$(ls -A ./)" ]; then
        echo "No file in folder ${source_folder}/${tranch}, skipping"
        cd ../.. 
        continue
    fi
    tar -cvf ${tranch}.tar --wildcards *
    mv ${tranch}.tar ../../${output_folder}/
    cd ../..
done

echo -e "\n * The restructuring of the folder ${source_folder} has been completed."


