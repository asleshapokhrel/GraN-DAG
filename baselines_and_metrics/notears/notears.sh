#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G

module load python/3.6
module load gcc/5.4.0
BASEDIR="$PWD"

virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
pip install --no-index numpy scipy tqdm networkx

cd $BASEDIR/cppext
python setup.py install

cd $BASEDIR
mkdir $SLURM_TMPDIR/data $SLURM_TMPDIR/results

DATASET="$(basename "$1" .zip)"
cp $1 $SLURM_TMPDIR/data
unzip $SLURM_TMPDIR/data/$DATASET.zip -d $SLURM_TMPDIR/data
mkdir $SLURM_TMPDIR/results/$DATASET

python main.py $SLURM_TMPDIR/data/$DATASET --output-folder $SLURM_TMPDIR/results/$DATASET --hyperparams-search --num-experiments $2

cp -r $SLURM_TMPDIR/results/$DATASET $SCRATCH/causal-learning/results
