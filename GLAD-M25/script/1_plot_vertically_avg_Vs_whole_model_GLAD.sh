#!/bin/bash
#plots the vertically avg Vs

#Input- GLAD_vertically_avg_Vs_80_to_220_km.txt
#run at - 
echo "Enter shallowest depth (e.g-80)"
read fdp
echo ""
echo "enter deepest depth (e.g-300)"
read edp
echo ""

dig="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/boundaries"

#setting map extent
lonmin=`echo "70"`
lonmax=`echo "135"`
latmin=`echo "5"`
latmax=`echo "40"`


bounds="-R-170/170/-80/80"
proj="-JM8i"
out="GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km"
##out="GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km_w_hotspot"


#minVs=`cat GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.txt| sort -n -k3| awk '{print $3}'| head -1`
#maxVs=`cat GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.txt| sort -n -k3| awk '{print $3}'|tail -1`

minavgVs=4.25
maxavgVs=4.88 #I selected these values as the our model vertical avg shows this range

diff=`echo "$maxavgVs $minavgVs"| awk '{print $1-$2}'`
vag=`echo "11"`
incre=`echo $diff $vag| awk '{print $1/$2}'`

#model=`cat GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.txt| awk -F"_" '{print $1}'`

#GRD
echo "Making GRD..."
cat GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.txt| awk '{print $0}'| gmt surface ${bounds} -I1m -T0.1 -GGLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.grd
echo ""

#CPT
echo "Making CPT..."

gmt makecpt -T${minavgVs}/${maxavgVs}/${incre} -I -Z -Cjet > cdf_${fdp}_to_${edp}.cpt
echo "B 128/0/128" >> cdf_${fdp}_to_${edp}.cpt
echo "F 0/0/0" >> cdf_${fdp}_to_${edp}.cpt


echo "Plotting..."
gmt psbasemap $bounds $proj -Bxa20f20 -Bya20f20 -BWSEN+t"GLAD-M25(${fdp}-${edp})" -K > $out.ps

gmt grdimage GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.grd -Ccdf_${fdp}_to_${edp}.cpt $bounds $proj -K -O >> $out.ps


#gmt psscale ${bounds} ${proj} -DjCT+w6.8i+o13/0.1c+v -Ccdf_${fdp}_to_${edp}.cpt -Bxa0.02f0.01 -By+l"meanVs (km/s)" -O -K >> $out.ps #perfect psscale command to plot it in a linear scale with 1 digit after decimal

gmt psscale ${bounds} ${proj} -DjCT+w6i+o0/17.8c+h+e -Ccdf_${fdp}_to_${edp}.cpt -By+l"meanVs(km/s)" -Bxa0.05f0.01  -O -K >> $out.ps

gmt pscoast ${bounds} ${proj} -Bxa20f20 -Bya20f20 -Df -W0.1p,black -K -O >> $out.ps

gmt psxy ${dig}/sutures_v3.txt -K -O -JM -R -W0.5p,white >> $out.ps

gmt psxy ${dig}/trench.txt -K -O -JM -R -W0.8p,red >> $out.ps

cat ${dig}/volcanoes_RB.txt| awk '{print $2,$1}'|gmt psxy -JM -R -K -O -St7p -Gred -Wwhite >> $out.ps

gmt convert ${dig}/boundaries.gmt -S"type=spreading center" | gmt psxy -W0.5p,red -JM -R -K -O >> ${out}.ps #for mercator

gmt convert ${dig}/boundaries.gmt -S"type=subduction zone" | gmt psxy -W0.5p,blue -JM -R -K -O >> ${out}.ps  #for Mercator


###Pacific
pac_lonmin=-165
#pac_lonmax=-103
pac_lonmax=-90
pac_latmin=-70
#pac_latmax=40
pac_latmax=10
rm tmp_Pac_box.txt
echo "$pac_lonmin $pac_latmin" >> tmp_Pac_box.txt
echo "$pac_lonmax $pac_latmin" >> tmp_Pac_box.txt
echo "$pac_lonmax $pac_latmax" >> tmp_Pac_box.txt
echo "$pac_lonmin $pac_latmax" >> tmp_Pac_box.txt
echo "$pac_lonmin $pac_latmin" >> tmp_Pac_box.txt

cat tmp_Pac_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_Pac_box.txt

###Indian ocean
IO_lonmin=55
IO_lonmax=90
IO_latmin=-60
IO_latmax=5
rm tmp_IO_box.txt
echo "$IO_lonmin $IO_latmin" >> tmp_IO_box.txt
echo "$IO_lonmax $IO_latmin" >> tmp_IO_box.txt
echo "$IO_lonmax $IO_latmax" >> tmp_IO_box.txt
echo "$IO_lonmin $IO_latmax" >> tmp_IO_box.txt
echo "$IO_lonmin $IO_latmin" >> tmp_IO_box.txt

cat tmp_IO_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_IO_box.txt

#NorthAtlantic
#N_at_lonmin=-60
#N_at_lonmin=-53
N_at_lonmin=-45
#N_at_lonmax=-14
N_at_lonmax=-20
N_at_latmin=5
#N_at_latmax=60
N_at_latmax=54
rm tmp_N_Atlantic_box.txt
echo "$N_at_lonmin $N_at_latmin" >> tmp_N_Atlantic_box.txt
echo "$N_at_lonmax $N_at_latmin" >> tmp_N_Atlantic_box.txt
echo "$N_at_lonmax $N_at_latmax" >> tmp_N_Atlantic_box.txt
echo "$N_at_lonmin $N_at_latmax" >> tmp_N_Atlantic_box.txt
echo "$N_at_lonmin $N_at_latmin" >> tmp_N_Atlantic_box.txt

cat tmp_N_Atlantic_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_N_Atlantic_box.txt


##S.Atlantic
#S_at_lonmin=-30
S_at_lonmin=-25
#S_at_lonmax=15 #inludes Africa 4.7 km/s
#S_at_lonmax=10
S_at_lonmax=0
S_at_latmin=-65
S_at_latmax=2
rm tmp_S_Atlantic_box.txt
echo "$S_at_lonmin $S_at_latmin" >> tmp_S_Atlantic_box.txt
echo "$S_at_lonmax $S_at_latmin" >> tmp_S_Atlantic_box.txt
echo "$S_at_lonmax $S_at_latmax" >> tmp_S_Atlantic_box.txt
echo "$S_at_lonmin $S_at_latmax" >> tmp_S_Atlantic_box.txt
echo "$S_at_lonmin $S_at_latmin" >> tmp_S_Atlantic_box.txt

cat tmp_S_Atlantic_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_S_Atlantic_box.txt

#S.Australia
SA_lonmin=102
SA_lonmax=148
SA_latmin=-60
SA_latmax=-40
rm tmp_SAus_box.txt
echo "$SA_lonmin $SA_latmin" >> tmp_SAus_box.txt
echo "$SA_lonmax $SA_latmin" >> tmp_SAus_box.txt
echo "$SA_lonmax $SA_latmax" >> tmp_SAus_box.txt
echo "$SA_lonmin $SA_latmax" >> tmp_SAus_box.txt
echo "$SA_lonmin $SA_latmin" >> tmp_SAus_box.txt

cat tmp_SAus_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_SAus_box.txt

<<C
#Latin America sea
LA_lonmin=-100
LA_lonmax=-30
LA_latmin=-70
LA_latmax=-50
rm tmp_LA_sea_box.txt
echo "$LA_lonmin $LA_latmin" >> tmp_LA_sea_box.txt
echo "$LA_lonmax $LA_latmin" >> tmp_LA_sea_box.txt
echo "$LA_lonmax $LA_latmax" >> tmp_LA_sea_box.txt
echo "$LA_lonmin $LA_latmax" >> tmp_LA_sea_box.txt
echo "$LA_lonmin $LA_latmin" >> tmp_LA_sea_box.txt

cat tmp_LA_sea_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps

rm tmp_LA_sea_box.txt
C

#South Africa ocean
SoA_lonmin=0
SoA_lonmax=55
#SoA_latmin=-65
SoA_latmin=-50
#SoA_latmax=-30
SoA_latmax=-40
rm tmp_SoA_sea_box.txt
echo "$SoA_lonmin $SoA_latmin" >> tmp_SoA_sea_box.txt
echo "$SoA_lonmax $SoA_latmin" >> tmp_SoA_sea_box.txt
echo "$SoA_lonmax $SoA_latmax" >> tmp_SoA_sea_box.txt
echo "$SoA_lonmin $SoA_latmax" >> tmp_SoA_sea_box.txt
echo "$SoA_lonmin $SoA_latmin" >> tmp_SoA_sea_box.txt

cat tmp_SoA_sea_box.txt| gmt psxy $proj $bounds -W1.2p,blue,-- -K -O >> $out.ps
rm tmp_SoA_sea_box.txt

#Plotting the hotspots from Courtillot et al. 2003
#cat Courtillot_hotspot.txt| awk '{print $2,$3}'| gmt psxy $proj $bounds -Sc10p -Gred -K -O >> $out.ps
#echo "Plotting hotspot"
##cat /media/rupak/Rupak_4TB/BACKUPS/FWI/GLOBAL_MODELS/GLAD-M25/v3/files/vertically_avg_images/Courtillot_hotspot_selected.txt| awk '{print $2,$3}'| gmt psxy $proj $bounds -Sc10p -Gred -K -O >> $out.ps
#echo "Plotting hotspot"

gmt psbasemap ${bounds} ${proj} -Bxa20f20 -Bya20f20 -O < /dev/null  >> $out.ps
#echo "Plotting hotspot -- done"
rm gmt.history

gv ${out}.ps

rm cdf_${fdp}_to_${edp}.cpt
rm GLAD_vertically_avg_Vs_${fdp}_to_${edp}_km.grd

gmt psconvert $out.ps -Tg
