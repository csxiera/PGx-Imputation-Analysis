#!/bin/bash
#SBATCH --output=download_%j.out
#SBATCH --error=download_%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=02:00:00

# Set the directory to save the files
FOLDER="$1"
download_folder=~PGx-Data/"$FOLDER"

# Move to the download folder
cd "$download_folder"

# Download files
wget https://imputationserver.sph.umich.edu/share/results/623cfcdd0aa5582e6bfabda01414e1ce1b832ef8d855f46a49cacc0b6ee077a2/chr_1.zip
wget https://imputationserver.sph.umich.edu/share/results/93043c7786d0c73da4d804bbe04fed1f6cdb78a9a7538f5def81b6df5846bca1/chr_10.zip
wget https://imputationserver.sph.umich.edu/share/results/d1f8c60c93cece4b5f2fc7843e112499d66cdd9aee4dafa643b82f2d908adfb6/chr_12.zip
wget https://imputationserver.sph.umich.edu/share/results/98bf89cc59d562e3dc7c320b1fb925c9fc2a4284823c5224884e5c51174e95b9/chr_13.zip
wget https://imputationserver.sph.umich.edu/share/results/511b19eb1d5c655582fc7a524f98a0773025882cc5a18853f406bc1bd3b3a0c0/chr_18.zip
wget https://imputationserver.sph.umich.edu/share/results/a9647252bd6589bf50c1d61ed751b5782b8bbc872c6d27251206fb69d03a2a47/chr_19.zip
wget https://imputationserver.sph.umich.edu/share/results/93d17745d32365a4db49412238704ec6012e6a4fbe0d8061b9588287a458cfc9/chr_2.zip
wget https://imputationserver.sph.umich.edu/share/results/b6daaabcae2ff13d4d8d0afe370e7edf8da5ad03d95d60668c34b77be7a10e5d/chr_22.zip
wget https://imputationserver.sph.umich.edu/share/results/3c365a8c0785352373a441d7af2476e7e4408fb92d492fcb5d92b3adfe8072c1/chr_7.zip
wget https://imputationserver.sph.umich.edu/share/results/3879dc3c7357641d205b95bfb881675c050c288542a69a650e0e9f8d94d1d5d6/results.md5

echo "Download complete."

