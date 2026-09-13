#!/bin/bash -e

#SBATCH --time          0:10:00
#SBATCH --mem           20GB
#SBATCH --cpus-per-task 8
#SBATCH --account       uoa04517
##SBATCH --gres		gpu:H100:1
#SBATCH --job-name      dragonfly
#SBATCH --output        dragonfly.log

module load JupyterLab/2026.7.0-foss-2026-4.6.0

# below is where kernel pmdm is located
export JUPYTER_PATH=/nesi/project/uoa04517/.jupyter/share/jupyter

papermill dragonfly.ipynb output_dragonfly.ipynb --kernel dragonfly
