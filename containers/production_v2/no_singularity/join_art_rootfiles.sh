#!/bin/bash

echo "Starting Job"
date

# This script will merge the art root files which have been split up for processing

# join_run1_beamoff.fcl  join_run1_beamon.fcl  join_run3b_beamoff.fcl  join_run3b_beamon.fcl

# Check if files exist, if it does then we skip this process to run
export SINGULARITYENV_check_all=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_all.root)
export SINGULARITYENV_check_good=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_good.root)
export SINGULARITYENV_check_antibdt=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root)
export SINGULARITYENV_check_bad=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_bad.root)
export SINGULARITYENV_check_ncpi0=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root)
export SINGULARITYENV_check_nucc=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root) 
export SINGULARITYENV_check_pi0=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root)

# Other files
export SINGULARITYENV_check_reco2d=$(ls | grep larlite_reco2d_tmnt.root)
export SINGULARITYENV_check_opreco=$(ls | grep larlite_opreco_tmnt.root)
export SINGULARITYENV_check_larcv=$(ls | grep larcv_wholeview_tmnt.root)
export SINGULARITYENV_check_celltree=$(ls | grep celltreeDATA_tmnt.root)
export SINGULARITYENV_check_bnm=$(ls | grep bnm_hist_tmnt.root)

# Make unique hex strings for filenames
unique_str_reco2d=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)
unique_str_opreco=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)
unique_str_larcv=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)
unique_str_celltree=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)
unique_str_bnm=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)

# Some checks to see if we want to finish before starting singularity container
if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then
  
  # Check if the final files exist, to see if we want to exit early
  if [ -n "$SINGULARITYENV_check_all" ] && [ -n "$SINGULARITYENV_check_antibdt" ] && [ -n "$SINGULARITYENV_check_ncpi0" ] && [ -n "$SINGULARITYENV_check_nucc" ] && [ -n "$SINGULARITYENV_check_pi0" ] && [ -n "$SINGULARITYENV_check_reco2d" ] && [ -n "$SINGULARITYENV_check_opreco" ] && [ -n "$SINGULARITYENV_check_larcv" ] && [ -n "$SINGULARITYENV_check_celltree" ] && [ -n "$SINGULARITYENV_check_bnm" ]; then
    echo "All the beam off joined files exist, so this job must have finished fine..."
    echo "exit 0"
    exit 0
  fi

else
  # Check if the final files exist, to see if we want to exit early
  if [ -n "$SINGULARITYENV_check_good" ] && [ -n "$SINGULARITYENV_check_bad" ] && [ -n "$SINGULARITYENV_check_antibdt" ] && [ -n "$SINGULARITYENV_check_ncpi0" ] && [ -n "$SINGULARITYENV_check_nucc" ] && [ -n "$SINGULARITYENV_check_pi0" ] && [ -n "$SINGULARITYENV_check_reco2d" ] && [ -n "$SINGULARITYENV_check_opreco" ] && [ -n "$SINGULARITYENV_check_larcv" ] && [ -n "$SINGULARITYENV_check_celltree" ] && [ -n "$SINGULARITYENV_check_bnm" ]; then
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
if [ -z $SINGULARITYENV_check_reco2d ]; then  SINGULARITYENV_check_reco2d="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_opreco ]; then  SINGULARITYENV_check_opreco="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_larcv ]; then   SINGULARITYENV_check_larcv="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_celltree ]; then     SINGULARITYENV_check_celltree="FileNotFound"; fi
if [ -z $SINGULARITYENV_check_bnm ]; then     SINGULARITYENV_check_bnm="FileNotFound"; fi

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
echo "larlite reco2d file: $SINGULARITYENV_check_reco2d"
echo "larlite opreco file: $SINGULARITYENV_check_opreco"
echo "larcv wholeview file: $SINGULARITYENV_check_larcv"
echo "celltree file: $SINGULARITYENV_check_celltree"
echo "celltree file: $SINGULARITYENV_check_bnm"
echo "If this is beam off, then good and bad are expected to be empty"
echo "If this is beam on, then all is expected to be empty"
echo

date
echo

# If beam off then merge these files
if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then
  if [ $SINGULARITYENV_check_all == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *all*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_all.root"
    lar -c $1 *all*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_all.root
    echo "Run time of all: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_antibdt == "FileNotFound" ]; then
     start_time=`date +%s`
     echo "lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root"
     lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root
     echo "Run time of antibdt: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_ncpi0 == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root"
    lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root
    echo "Run time of ncpi0: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_nucc == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root"
    lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root
    echo "Run time of NuCC: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_pi0 == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root"
    lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root
    echo "Run time of pi0: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 

else 
  if [ $SINGULARITYENV_check_good == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *beam_good* -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_good.root"
    lar -c $1 *beam_good* -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_good.root
    echo "Run time of good: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_bad == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *beam_bad*  -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_bad.root"
    lar -c $1 *beam_bad*  -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_bad.root
    echo "Run time of bad: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_antibdt == "FileNotFound" ]; then
     start_time=`date +%s`
     echo "lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root"
     lar -c $1 *antibdt*   -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root
     echo "Run time of antibdt: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_ncpi0 == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root"
    lar -c $1 *ncpi0*     -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root
    echo "Run time of ncpi0: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_nucc == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root"
    lar -c $1 *NuCC*      -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root
    echo "Run time of NuCC: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 
  if [ $SINGULARITYENV_check_pi0 == "FileNotFound" ]; then
    start_time=`date +%s`
    echo "lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root"
    lar -c $1 *_pi0*       -o $2_tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root
    echo "Run time of pi0: $(expr `date +%s` - $start_time) s"
  fi
  echo "------------------------------------------------------------------------" 

fi

# Hadd the root files
if [ $SINGULARITYENV_check_reco2d == "FileNotFound" ]; then
   echo "------------------------------------------------------------------------"
   echo "hadd ${unique_str_reco2d}_larlite_reco2d_tmnt.root larlite_reco2d*.root*"
   hadd ${unique_str_reco2d}_larlite_reco2d_tmnt.root larlite_reco2d*.root*
   echo "------------------------------------------------------------------------"
fi
if [ $SINGULARITYENV_check_opreco == "FileNotFound" ]; then
   echo "------------------------------------------------------------------------"
   echo "hadd ${unique_str_opreco}_larlite_opreco_tmnt.root larlite_opreco*.root*"
   hadd ${unique_str_opreco}_larlite_opreco_tmnt.root larlite_opreco*.root*
   echo "------------------------------------------------------------------------"
fi
if [ $SINGULARITYENV_check_larcv == "FileNotFound" ]; then
   echo "------------------------------------------------------------------------"
   echo "hadd ${unique_str_larcv}_larcv_wholeview_tmnt.root larcv_wholeview*.root*"
   hadd ${unique_str_larcv}_larcv_wholeview_tmnt.root larcv_wholeview*.root*
   echo "------------------------------------------------------------------------"
fi
if [ $SINGULARITYENV_check_celltree == "FileNotFound" ]; then
   echo "------------------------------------------------------------------------"
   echo "hadd ${unique_str_celltree}_celltreeDATA_tmnt.root celltreeDATA*.root*"
   hadd ${unique_str_celltree}_celltreeDATA_tmnt.root celltreeDATA*.root*
   echo "------------------------------------------------------------------------"
fi
if [ $SINGULARITYENV_check_bnm == "FileNotFound" ]; then
   echo "------------------------------------------------------------------------"
   echo "hadd ${unique_str_bnm}_bnm_hist_tmnt.root bnm_hist*.root*"
   hadd ${unique_str_bnm}_bnm_hist_tmnt.root bnm_hist*.root*
   echo "------------------------------------------------------------------------"
fi

# Now we check if the files exist and exit appropriately
export check_all=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_all.root)
export check_good=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_good.root)
export check_antibdt=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_antibdt.root)
export check_bad=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_beam_bad.root)
export check_ncpi0=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_ncpi0.root)
export check_nucc=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_NuCC.root)
export check_pi0=$(ls | grep tmnt_reco1_postwcct_bnm_reco1a_reco2_postdl_pi0.root)

export check_reco2d=$(ls | grep larlite_reco2d_tmnt.root)
export check_opreco=$(ls | grep larlite_opreco_tmnt.root)
export check_larcv=$(ls | grep larcv_wholeview_tmnt.root)
export check_celltree=$(ls | grep celltreeDATA_tmnt.root)
export check_bnm=$(ls | grep bnm_hist_tmnt.root)

if [ $(basename $1) == "join_run1_beamoff.fcl" ] || [ $(basename $1) == "join_run3b_beamoff.fcl" ]; then

  # Check if any of the vaiables are empty
  if [ -z "$check_all" ] || [ -z "$check_antibdt" ] || [ -z "$check_ncpi0" ] || [ -z "$check_nucc" ] || [ -z "$check_pi0" ] || [ -z "$check_reco2d" ] || [ -z "$check_opreco" ] || [ -z "$check_larcv" ] || [ -z "$check_celltree" ] || [ -z "$check_bnm" ]; then
    echo "looks like one of the files were not found, so mark the job as FAILED..."
    echo "exit 1"
    exit 1
  else
    echo "All the files were found, so SUCCESS..."
    echo "rm $(realpath *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* bnm_hist.root*)"
    rm $(realpath *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* bnm_hist.root*)
    echo "rm *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* *.fcl* bnm_hist.root*"
    rm *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* *.fcl* TFile* RootOutput* bnm_hist.root*
    echo "mkdir log"
    mkdir log
    echo "cp $(realpath *beam*.out* *time*.out* *debug*.log*) log"
    cp $(realpath *beam*.out* *time*.out* *debug*.log*) log
    echo "rm *beam*.out* *time*.out* *debug*.log*"
    rm *beam*.out* *time*.out* *debug*.log*
    base=$(basename $PWD)
    echo "tar -zcvf ${base}.tar.gz -C $PWD ."
    tar -zcvf ${base}.tar.gz -C $PWD .
    echo "exit 0"
    exit 0
  fi    

else
  
  # Check if any of the vaiables are empty
  if [ -z "$check_good" ] || [ -z "$check_bad" ] || [ -z "$check_antibdt" ] || [ -z "$check_ncpi0" ] || [ -z "$check_nucc" ] || [ -z "$check_pi0" ] || [ -z "$check_reco2d" ] || [ -z "$check_opreco" ] || [ -z "$check_larcv" ] || [ -z "$check_celltree" ] || [ -z "$check_bnm" ]; then
    echo "looks like one of the files were not found, so mark the job as FAILED..."
    echo "exit 1"
    exit 1
  else
    echo "All the files were found, so SUCCESS..."
    echo "rm $(realpath *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* bnm_hist.root*)"
    rm $(realpath *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* bnm_hist.root*)
    echo "rm *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* *.fcl* bnm_hist.root*"
    rm *event* time.db* mem.db* larlite_reco2d.root* larlite_opreco.root* larcv_wholeview.root* celltreeDATA.root* larcv_hist.root* mylist* *.fcl* TFile* RootOutput* bnm_hist.root*
    echo "mkdir log"
    mkdir log
    echo "cp $(realpath *beam*.out* *time*.out* *.log*) log"
    cp $(realpath *beam*.out* *time*.out* *debug*.log*) log
    echo "rm *beam*.out* *time*.out* *debug*.log*"
    rm *beam*.out* *time*.out* *.log*
    base=$(basename $PWD)
    echo "tar -zcvf ${base}.tar.gz -C $PWD ."
    tar -zcvf ${base}.tar.gz -C $PWD .
    echo "exit 0"
    exit 0
  fi    
fi
