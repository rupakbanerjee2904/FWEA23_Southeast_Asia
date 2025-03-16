#!/bin/bash

#Extracting the oceans from the GLAD_vertically_avg_Vs_${dp}_to_220_km.txt files
#At first go I didnt exclude hotspots; this time I am excluding 4 hotspots that come within my boxes
#Hawaai and Easter -- Pacific box
#Reunion -- Indian ocean
#Tristan -- S.Atlantic

in_dir="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/GLAD-M25/files"
out_dir="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/GLAD-M25/files"

#Hotspot boxes to be excluded
#Hawaii
Ha_lonmin=201
Ha_lonmax=207
Ha_latmin=17
Ha_latmax=23

#Reunion
Re_lonmin=53
Re_lonmax=59
Re_latmin=-24
Re_latmax=-18

#Tristan
Tr_lonmin=345
Tr_lonmax=351
Tr_latmin=-40
Tr_latmax=-34

#Easter
Ea_lonmin=247
Ea_lonmax=253
Ea_latmin=-30
Ea_latmax=-24

#Pacific
pac_lonmin=-165
#pac_lonmax=-103
pac_lonmax=-90
pac_latmin=-70
#pac_latmax=40
pac_latmax=10


#for dp in 80
#for dp in 90 100 110 120 130 140
for dp in 100 110 120 130 140 150 160 170 180 190 200 220
do

ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
echo "input file= $ifile"

rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_PAC_OCEAN.txt

#cat $ifile| awk -v pac_lonmin=$pac_lonmin -v pac_lonmax=$pac_lonmax -v pac_latmin=$pac_latmin -v pac_latmax=$pac_latmax '{if($1>=pac_lonmin && $1<=pac_lonmax && $2>=pac_latmin && $2<=pac_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_PAC_OCEAN.txt  #including  hotspots

cat $ifile| awk -v pac_lonmin=$pac_lonmin -v pac_lonmax=$pac_lonmax -v pac_latmin=$pac_latmin -v pac_latmax=$pac_latmax '{if($1>=pac_lonmin && $1<=pac_lonmax && $2>=pac_latmin && $2<=pac_latmax && !($1>=Ha_lonmin && $1<=Ha_lonmax && $2>=Ha_latmin && $2<=Ha_latmax) && !($1 >=Ea_lonmin && $1<=Ea_lonmax && $2>=Ea_latmin && $2<=Ea_latmax))print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_PAC_OCEAN.txt   #excludinh hotpots Hawaii and Easter from Pacific box


done

echo "Information on Pacific ocean (${pac_lonmin}W/${pac_lonmax}W/${pac_latmin}S/${pac_latmax}N) extracted!"
echo ""

#Indian ocean
IO_lonmin=55
#IO_lonmax=100
IO_lonmax=90
IO_latmin=-60
IO_latmax=5

#for dp in 80
for dp in 90 100 110 120 130 140
do

	ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
echo "input file= $ifile"

rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_IND_OCEAN.txt
#cat $ifile| awk -v IO_lonmin=$IO_lonmin -v IO_lonmax=$IO_lonmax -v IO_latmin=$IO_latmin -v IO_latmax=$IO_latmax '{if($1>=IO_lonmin && $1<=IO_lonmax && $2>=IO_latmin && $2<=IO_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_IND_OCEAN.txt #including hotpsot

cat $ifile| awk -v IO_lonmin=$IO_lonmin -v IO_lonmax=$IO_lonmax -v IO_latmin=$IO_latmin -v IO_latmax=$IO_latmax '{if($1>=IO_lonmin && $1<=IO_lonmax && $2>=IO_latmin && $2<=IO_latmax && !($1>=Re_lonmin && $1<=Re_lonmax && $2>=Re_latmin && $2<=Re_latmax))print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_IND_OCEAN.txt #excluding Reuninon from Indian ocean

done

#NorthAtlantic
#N_at_lonmin=-60
#N_at_lonmin=-53
N_at_lonmin=-45
N_at_lonmax=-20
N_at_latmin=5
#N_at_latmax=60
N_at_latmax=54

#for dp in 80
for dp in 90 100 110 120 130 140
do

ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
echo "input file= $ifile"

rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_NAtlantic.txt
cat $ifile|awk -v N_at_lonmin=$N_at_lonmin -v N_at_lonmax=$N_at_lonmax -v N_at_latmin=$N_at_latmin -v N_at_latmax=$N_at_latmax '{if($1>=N_at_lonmin && $1<=N_at_lonmax && $2>=N_at_latmin && $2<=N_at_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_NAtlantic.txt

done

##S.Atlantic
#S_at_lonmin=-30
S_at_lonmin=-25
#S_at_lonmax=15
S_at_lonmax=0
S_at_latmin=-65
S_at_latmax=2

#for dp in 80
for dp in 90 100 110 120 130 140
do


ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
echo "input file= $ifile"

rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_SAtlantic.txt
#cat $ifile|awk -v S_at_lonmin=$S_at_lonmin -v S_at_lonmax=$S_at_lonmax -v S_at_latmin=$S_at_latmin -v S_at_latmax=$S_at_latmax '{if($1>=S_at_lonmin && $1<=S_at_lonmax && $2>=S_at_latmin && $2<=S_at_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_SAtlantic.txt #including hotspot

cat $ifile|awk -v S_at_lonmin=$S_at_lonmin -v S_at_lonmax=$S_at_lonmax -v S_at_latmin=$S_at_latmin -v S_at_latmax=$S_at_latmax '{if($1>=S_at_lonmin && $1<=S_at_lonmax && $2>=S_at_latmin && $2<=S_at_latmax && !($1>=Tr_lonmin && $1<=Tr_lonmax && $2>=Tr_latmin && $2<=Tr_latmax))print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_SAtlantic.txt #excluding hotspot

done

#S.Australia
SA_lonmin=102
SA_lonmax=148
SA_latmin=-60
SA_latmax=-40

#for dp in 80
for dp in 90 100 110 120 130 140
do
ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
echo "input file= $ifile"

rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_S_Australia.txt
cat $ifile| awk -v SA_lonmin=$SA_lonmin -v SA_lonmax=$SA_lonmax -v SA_latmin=$SA_latmin -v SA_latmax=$SA_latmax '{if($1>=SA_lonmin && $1<=SA_lonmax && $2>=SA_latmin && $2<=SA_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_S_Australia.txt
done

<<C
#Latin America sea
LA_lonmin=-100
LA_lonmax=-30
LA_latmin=-70
LA_latmax=-50

#for dp in 80
for dp in 90 100 110 120 130 140
do
	ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
	echo "input file= $ifile"
rm ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_Latin_Am_sea.txt
	cat $ifile| awk -v LA_lonmin=$LA_lonmin -v LA_lonmax=$LA_lonmax -v LA_latmin=$LA_latmin -v LA_latmax=$LA_latmax '{if($1>=LA_lonmin && $1<=LA_lonmax && $2>=LA_latmin && $2<=LA_latmax)print $0}' >> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_Latin_Am_sea.txt
done
C


#South Africa ocean
SoA_lonmin=0
SoA_lonmax=55
SoA_latmin=-50
SoA_latmax=-40

#for dp in 80
for dp in 90 100 110 120 130 140
do
	ifile=`ls ${in_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km.txt`
        echo "input file= $ifile"

	cat $ifile| awk -v SoA_lonmin=$SoA_lonmin -v SoA_lonmax=$SoA_lonmax -v SoA_latmin=$SoA_latmin -v SoA_latmax=$SoA_latmax '{if($1>=SoA_lonmin && $1<=SoA_lonmax && $2>=SoA_latmin && $2<=SoA_latmax)print $0}'>> ${out_dir}/GLAD_vertically_avg_Vs_${dp}_to_220_km_South_Afr_sea.txt
done
