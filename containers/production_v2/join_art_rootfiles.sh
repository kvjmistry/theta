#!/bin/bash

echo "Starting Job"
date

# This script will merge the art root files which have been split up for processing

# join_run1_beamoff.fcl  join_run1_beamon.fcl  join_run3b_beamoff.fcl  join_run3b_beamon.fcl

# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_all=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_all.root)
export SINGULARITYENV_check_good=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_good.root)
export SINGULARITYENV_check_antibdt=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root)
export SINGULARITYENV_check_bad=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_bad.root)
export SINGULARITYENV_check_ncpi0=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root)
export SINGULARITYENV_check_nucc=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root) 
export SINGULARITYENV_check_pi0=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root)

# Some checks to see if we want to finish before starting singularity container
if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then
  
  # Check if the final files exist, to see if we want to exit early
  if [ -n "$SINGULARITYENV_check_all" ] && [ -n "$SINGULARITYENV_check_antibdt" ] && [ -n "$SINGULARITYENV_check_ncpi0" ] && [ -n "$SINGULARITYENV_check_nucc" ] && [ -n "$SINGULARITYENV_check_pi0" ]; then
    echo "All the beam off joined files exist, so this job must have finished fine..."
    echo "exit 0"
    exit 0
  fi

else
  # Check if the final files exist, to see if we want to exit early
  if [ -n "$SINGULARITYENV_check_good" ] && [ -n "$SINGULARITYENV_check_bad" ] && [ -n "$SINGULARITYENV_check_antibdt" ] && [ -n "$SINGULARITYENV_check_ncpi0" ] && [ -n "$SINGULARITYENV_check_nucc" ] && [ -n "$SINGULARITYENV_check_pi0" ]; then
    echo "All the beamon joined files exist, so this job must have finished fine..."
    echo "exit 0"
    exit 0
  fi
fi

# For some reason sinularity container doesnt work well with empty vars, so set to FileNotFound instead of checking empty (ugly, I know)
if [ -z $SINGULARITYENV_check_all ]; then     SINGULARITYENV_check_all="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_good ]; then    SINGULARITYENV_check_good="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_antibdt ]; then SINGULARITYENV_check_antibdt="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_bad ]; then     SINGULARITYENV_check_bad="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_ncpi0 ]; then   SINGULARITYENV_check_ncpi0="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_nucc ]; then    SINGULARITYENV_check_nucc="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_pi0 ]; then     SINGULARITYENV_check_pi0="FileNotFound"; fi


# Print the status of the files
echo
echo "Seeing which files exist in the directory, any files not found are listed as FileNotFound"
echo "All file: $SINGULARITYENV_check_all"
echo "Good file: $SINGULARITYENV_check_good"
echo "AntiBDT file: $SINGULARITYENV_check_antibdt"
echo "Bad file: $SINGULARITYENV_check_bad"
echo "NCPi0 file: $SINGULARITYENV_check_ncpi0"
echo "NuCC file: $SINGULARITYENV_check_nucc"
echo "Pi0 file: $SINGULARITYENV_check_pi0"
echo "If this is beam off, then good and bad are expected to be empty"
echo "If this is beam on, then all is expected to be empty"
echo

export SINGULARITYENV_HOME=/lus/theta-fs0/projects/uboone
sleep $[ ( $RANDOM % 10 )  + 1 ]s
singularity run --no-home -B /lus:/lus -B /soft:/soft /lus/theta-fs0/projects/uboone/containers/fnal-wn-sl7_latest.sif <<EOF
  source /lus/theta-fs0/projects/uboone/uboonecode_v2/setup
  setup uboonecode v08_00_00_27 -q e17:prof

  echo "Entered Container"
  date
  echo

  # If beam off then merge these files
  if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then
    if [ $SINGULARITYENV_check_all == "FileNotFound" ]; then
      echo "lar -c $1 *all*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_all.root"
      lar -c $1 *all*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_all.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_antibdt == "FileNotFound" ]; then
       echo "lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root"
       lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_ncpi0 == "FileNotFound" ]; then
      echo "lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root"
      lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_nucc == "FileNotFound" ]; then
      echo "lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root"
      lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_pi0 == "FileNotFound" ]; then
      echo "lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root"
      lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root
    fi
    echo "------------------------------------------------------------------------" 

  else 
    if [ $SINGULARITYENV_check_good == "FileNotFound" ]; then
      echo "lar -c $1 *beam_good* -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_good.root"
      lar -c $1 *beam_good* -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_good.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_bad == "FileNotFound" ]; then
      echo "lar -c $1 *beam_bad*  -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_bad.root"
      lar -c $1 *beam_bad*  -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_bad.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_antibdt == "FileNotFound" ]; then
       echo "lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root"
       lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_ncpi0 == "FileNotFound" ]; then
      echo "lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root"
      lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_nucc == "FileNotFound" ]; then
      echo "lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root"
      lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root
    fi
    echo "------------------------------------------------------------------------" 
    if [ $SINGULARITYENV_check_pi0 == "FileNotFound" ]; then
      echo "lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root"
      lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root
    fi
    echo "------------------------------------------------------------------------" 

  fi

EOF

echo "Exited Container"

# Now we check if the files exist and exit appropriately
export check_all=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_all.root)
export check_good=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_good.root)
export check_antibdt=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_antibdt.root)
export check_bad=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_beam_bad.root)
export check_ncpi0=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_ncpi0.root)
export check_nucc=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_NuCC.root)
export check_pi0=$(ls | grep tmnt_reco1_postwcct_postdl_bnm_reco1a_reco2_pi0.root)

if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then

  # Check if any of the vaiables are empty
  if [ -z "$check_all" ] || [ -z "$check_antibdt" ] || [ -z "$check_ncpi0" ] || [ -z "$check_nucc" ] || [ -z "$check_pi0" ]; then
    echo "looks like one of the files were not found, so mark the job as FAILED..."
    echo "exit 1"
    exit 1
  else
    echo "All the files were found, so SUCCESS..."
    echo "exit 0"
    exit 0
  fi    

else
  
  # Check if any of the vaiables are empty
  if [ -z "$check_good" ] || [ -z "$check_bad" ] || [ -z "$check_antibdt" ] || [ -z "$check_ncpi0" ] || [ -z "$check_nucc" ] || [ -z "$check_pi0" ]; then
    echo "looks like one of the files were not found, so mark the job as FAILED..."
    echo "exit 1"
    exit 1
  else
    echo "All the files were found, so SUCCESS..."
    echo "exit 0"
    exit 0
  fi    
fi

