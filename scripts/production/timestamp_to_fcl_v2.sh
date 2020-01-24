#!/bin/bash

# This script will take the input string and convert it to a fcl parameter

# This is left here for demonstration purposes of what the input string should be
#string="event_0,channelstatus_data_v3r2,1532822160.0,crt_channelstatus_data_v2r0,1522085400.0,detpedestals_data_v1r0,1508184720.0,dqdx_xnorm_data_v1r1,1549013520.0,dqdx_xshape_plane0_data_v1r2,1545771720.0,dqdx_xshape_plane1_data_v1r2,1545771720.0,dqdx_xshape_plane2_data_v1r2,1545771720.0,dqdx_yz_plane0_data_v2r2,1515984420.0,dqdx_yz_plane1_data_v2r2,1515984420.0,dqdx_yz_plane2_data_v2r2,1515984420.0,electronicscalib_data_v1r3,1504353900.0,elifetime_data_v1r1,1530100800.0,detpmtgains_data_v1r0,1552431720.0,lightyieldscale_data_v2r0,1553439210.0,dedx_correction_provider_data,860747520.0"

# This takes an input string rather than using the defaults as formatted above
string=$(cat mylist_timestamps.txt | grep "event $1,")
echo $string

string="${string:6}"

#echo $string | tr ',' '\n'

# First split up the comma seprated string to new line (nl) separated string
string_nl=$(echo $string | tr ',' '\n')

counter=0
name="test"

html_path="/lus/theta-fs0/projects/uboone/html_pages/"

# Timestamp for PMT, we use this to override the celtree fcl 
# This is becuase it has a typo in the configureation
pmt_ts=""
for line in $string_nl
do

    # First want to check if the first line in the loop which is the filename
    if [ $counter -eq 0 ]
    then
        counter=$((counter+1))
        continue
    fi
    #___________________________________________________________________________________________________
    if [ $line == "channelstatus_data_v3r2" ] || [ $name == "channelstatus_data_v3r2" ]; then
        str="services.ChannelStatusService.ChannelStatusProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="channelstatus_data_v3r2"

        if [ $line != "channelstatus_data_v3r2" ]; then str_chan="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    
    #___________________________________________________________________________________________________
    elif [ $line == "crt_channelstatus_data_v2r0" ] || [ $name == "crt_channelstatus_data_v2r0" ]; then
        str="services.CRTChannelStatusService.ChannelStatusProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="crt_channelstatus_data_v2r0"

        if [ $line != "crt_channelstatus_data_v2r0" ]; then str_crt="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    
    #___________________________________________________________________________________________________
    elif [ $line == "detpedestals_data_v1r0" ] || [ $name == "detpedestals_data_v1r0" ]; then
        str="services.DetPedestalService.DetPedestalRetrievalAlg.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="detpedestals_data_v1r0"

        if [ $line != "detpedestals_data_v1r0" ]; then str_detped="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
   
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_xnorm_data_v1r1" ] || [ $name == "dqdx_xnorm_data_v1r1" ]; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.XNormCorrectionProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_xnorm_data_v1r1"

        if [ $line != "dqdx_xnorm_data_v1r1" ]; then str_xnorm="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_xshape_plane0_data_v1r2" ] || [ $name == "dqdx_xshape_plane0_data_v1r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.XShapeCorrectionProvider_Plane0.DatabaseRetrievalAlg.OverrideURL: "
        str2="services.TPCEnergyCalibService.TPCEnergyCalibProvider.XShapeCorrectionProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_xshape_plane0_data_v1r2"

        if [ $line != "dqdx_xshape_plane0_data_v1r2" ]; then str_dqdx_plane0="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; str_dqdx="${str2}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_xshape_plane1_data_v1r2" ] || [ $name == "dqdx_xshape_plane1_data_v1r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.XShapeCorrectionProvider_Plane1.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_xshape_plane1_data_v1r2"

        if [ $line != "dqdx_xshape_plane1_data_v1r2" ]; then str_dqdx_plane1="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_xshape_plane2_data_v1r2" ] || [ $name == "dqdx_xshape_plane2_data_v1r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.XShapeCorrectionProvider_Plane2.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_xshape_plane2_data_v1r2"

        if [ $line != "dqdx_xshape_plane2_data_v1r2" ]; then str_dqdx_plane2="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_yz_plane0_data_v2r2" ] || [ $name == "dqdx_yz_plane0_data_v2r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.YZCorrectionProvider_Plane0.DatabaseRetrievalAlg.OverrideURL: "
        str2="services.TPCEnergyCalibService.TPCEnergyCalibProvider.YZCorrectionProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_yz_plane0_data_v2r2"

        if [ $line != "dqdx_yz_plane0_data_v2r2" ]; then str_yz_plane0="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; str_yz="${str2}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_yz_plane1_data_v2r2" ] || [ $name == "dqdx_yz_plane1_data_v2r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.YZCorrectionProvider_Plane1.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dqdx_yz_plane1_data_v2r2"

        if [ $line != "dqdx_yz_plane1_data_v2r2" ]; then str_yz_plane1="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dqdx_yz_plane2_data_v2r2" ] || [ $name == "dqdx_yz_plane2_data_v2r2"  ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.YZCorrectionProvider_Plane2.DatabaseRetrievalAlg.OverrideURL: " 
        name=$line
        var="dqdx_yz_plane2_data_v2r2"

        if [ $line != "dqdx_yz_plane2_data_v2r2" ]; then str_yz_plane2="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "electronicscalib_data_v1r3" ] || [ $name == "electronicscalib_data_v1r3"  ] ; then
        str="services.ElectronicsCalibService.ElectronicsCalibProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="electronicscalib_data_v1r3"

        if [ $line != "electronicscalib_data_v1r3" ]; then str_ecalib="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "elifetime_data_v1r1" ] || [ $name == "elifetime_data_v1r1"  ] ; then
        str="services.UBElectronLifetimeService.ElectronLifetimeProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="elifetime_data_v1r1"

        if [ $line != "elifetime_data_v1r1" ]; then str_elife="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "detpmtgains_data_v1r0" ] || [ $name == "detpmtgains_data_v1r0"  ] ; then
        str="services.PmtGainService.PmtGainProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="detpmtgains_data_v1r0"

        if [ $line != "detpmtgains_data_v1r0" ]; then str_detpmt="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; pmt_ts=$line; fi
    #___________________________________________________________________________________________________
    elif [ $line == "lightyieldscale_data_v2r0" ] || [ $name == "lightyieldscale_data_v2r0"  ] ; then
        str="services.LightYieldService.LightYieldProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="lightyieldscale_data_v2r0"

        if [ $line != "lightyieldscale_data_v2r0" ]; then str_ly="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    elif [ $line == "dedx_correction_provider_data" ] || [ $name == "dedx_correction_provider_data" ] ; then
        str="services.TPCEnergyCalibService.TPCEnergyCalibProvider.dEdxCorrectionProvider.DatabaseRetrievalAlg.OverrideURL: "
        name=$line
        var="dedx_correction_provider_data"

        if [ $line != "dedx_correction_provider_data" ]; then str_dedx="${str}"\""${html_path}${var}/${var}_${line}.html"\"""; fi
    #___________________________________________________________________________________________________
    fi

    #echo $line

done

# Now we look at the fcl file input and create a custom fcl file with the timestamp
# some fcl files dont need all the paramters overriden
input_fcl=$2
input_fcl=$(basename $input_fcl)

# The outfile name will be <input_fcl_name>_url_override.fcl
output_fcl=$(basename $input_fcl)
output_fcl=${output_fcl%.fcl}
output_fcl=$output_fcl"_url_override.fcl"

echo "Making $output_fcl"

# The reco1 fcls dont override all the params so we need special cases for these
if [ $input_fcl == "reco_uboone_data_mcc9_8_driver_stage1.fcl" ] || [ $input_fcl == "standard_larcv_uboone_data2d_prod.fcl" ] ; then
    cat $2 > $output_fcl
    echo >> $output_fcl
    echo $str_chan >> $output_fcl
    echo $str_detped >> $output_fcl
    echo $str_xnorm >> $output_fcl
    echo $str_dqdx >> $output_fcl
    echo $str_dqdx_plane0 >> $output_fcl
    echo $str_dqdx_plane1 >> $output_fcl
    echo $str_dqdx_plane2 >> $output_fcl
    echo $str_yz >> $output_fcl
    echo $str_yz_plane0 >> $output_fcl
    echo $str_yz_plane1 >> $output_fcl
    echo $str_yz_plane2 >> $output_fcl
    echo $str_ecalib >> $output_fcl
    echo $str_detpmt >> $output_fcl
    echo $str_dedx >> $output_fcl

elif [ $input_fcl == "run_celltreeub_prod.fcl" ] ; then
    cat $2 > $output_fcl
    echo >> $output_fcl
    var="detpmtgains_data_v1r0"
    echo "services.PMTGainService.PmtGainProvider.DatabaseRetrievalAlg.OverrideURL: "\""${html_path}${var}/${var}_${pmt_ts}.html"\""" >> $output_fcl

else
    cat $2 > $output_fcl
    echo >> $output_fcl
    echo $str_chan >> $output_fcl
    echo $str_crt >> $output_fcl
    echo $str_detped >> $output_fcl
    echo $str_xnorm >> $output_fcl
    echo $str_dqdx >> $output_fcl
    echo $str_dqdx_plane0 >> $output_fcl
    echo $str_dqdx_plane1 >> $output_fcl
    echo $str_dqdx_plane2 >> $output_fcl
    echo $str_yz >> $output_fcl
    echo $str_yz_plane0 >> $output_fcl
    echo $str_yz_plane1 >> $output_fcl
    echo $str_yz_plane2 >> $output_fcl
    echo $str_ecalib >> $output_fcl
    echo $str_elife >> $output_fcl
    echo $str_detpmt >> $output_fcl
    echo $str_ly >> $output_fcl
    echo $str_dedx >> $output_fcl
fi
