#!/bin/bash
#This script produces the file that contains information of avg Vs from Lon-lat extent of KP
#I looked at the vertically_meanVs_80_to_220.ps plot and realised that KP (higher velocity within slow SE Asia) is within the extent of 15N-19N and 102E-106E
#thus, this script creates an output file that contains the lon, lat and vertically averaged Vs 

#Input-vertically_avg_Vs_${fdp}_to_${edp}_km.txt

#output -vertically_avg_Vs_${fdp}_to_${edp}_km_FOR_KP.txt #contains vertically avg Vs for KP
#output- vertically_avg_Vs_80_to_220_km_SE_Asia_WITHOUT_KP #this file contains the slow region of SE Asia EXCLUDING KP

echo "Min depth (e.g -80)"
read fdp
echo ""
echo "Max dp (e.g.-220)"
read edp
echo ""

echo "Extracting coordiante wise vertically averaged Vs from $fdp km to $edp km"
echo ""

#Making a file that contains info for KP only
KP_minlon=`echo "102"`
KP_maxlon=`echo "106"`
KP_minlat=`echo "15"`
KP_maxlat=`echo "19"`

rm vertically_avg_Vs_${fdp}_to_${edp}_km_FOR_KP.txt
cat vertically_avg_Vs_${fdp}_to_${edp}_km.txt| awk -v KP_minlon="$KP_minlon" -v KP_maxlon="$KP_maxlon" -v KP_minlat="$KP_minlat" -v KP_maxlat="$KP_maxlat" '{if ($1>=KP_minlon && $1<=KP_maxlon && $2>=KP_minlat && $2<=KP_maxlat)print $0}' >> vertically_avg_Vs_${fdp}_to_${edp}_km_FOR_KP.txt

echo "KP coordantes - ${KP_minlon}E/${KP_maxlon}E/${KP_minlat}N/${KP_maxlat}N"
echo "File with information on KP -- vertically_avg_Vs_${fdp}_to_${edp}_km_FOR_KP.txt"

echo ""
#Making a file that contains info for KP only -DONE

####

#Making file with info for the slow region of SE Asia
slo_SE_minlon=`echo "98"`
slo_SE_maxlon=`echo "118"`
slo_SE_minlat=`echo "10"`
slo_SE_maxlat=`echo "24"`
echo "Slow anomy in SE Asia is spread at- ${slo_SE_minlon}E/${slo_SE_maxlon}E/${slo_SE_minlat}N/${slo_SE_maxlat}E"

rm tmp_*
cat vertically_avg_Vs_${fdp}_to_${edp}_km.txt| awk -v slo_SE_minlon="$slo_SE_minlon" -v slo_SE_maxlon="$slo_SE_maxlon" -v slo_SE_minlat="$slo_SE_minlat" -v slo_SE_maxlat="$slo_SE_maxlat" '{if ($1>=slo_SE_minlon && $1<=slo_SE_maxlon && $2>=slo_SE_minlat && $2<=slo_SE_maxlat)print $0}' >> tmp_1

#Creating a file that contains info on the slow region of SE Asia WITHOUT KP
echo "Now removing KP from slow SE Asia"

echo "Defining files"
A_FILE="tmp_1" ##contains infor for the slow region in SE Asia
B_FILE="vertically_avg_Vs_${fdp}_to_${edp}_km_FOR_KP.txt"  ##file from which lines are to be compared i.e. the KP file

C_FILE="vertically_avg_Vs_${fdp}_to_${edp}_km_SE_Asia_WITHOUT_KP" ##output that contains no info on the coordinates for KP

if [ -f "$C_FILE" ]; then
    rm "$C_FILE"
fi

# Read B.txt into a temporary file for comparison
awk '{print $1,$2}' "$B_FILE" > B_temp.txt

echo ""
echo ""
echo "Omitting KP mean Vs from SE Asia and creating $C_FILE"

# Compare A.txt with B_temp.txt and create C.txt
while read -r line; do
    col1=$(echo "$line" | awk '{print $1}')
    col2=$(echo "$line" | awk '{print $2}')
    grep -q "$col1 $col2" B_temp.txt || echo "$line" >> "$C_FILE"
done < "$A_FILE"

rm B_temp.txt
rm tmp_*
