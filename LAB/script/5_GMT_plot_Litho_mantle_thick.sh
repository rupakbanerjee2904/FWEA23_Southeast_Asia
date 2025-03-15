#!/bin/bash
#Rupak, Okt 15 24
#This script plots the LAB depth using the input file Lat_lon_LABDEPTH.txt
#Thsi uses the smotedned VSH by moving avg 
#Inputs=Lat_lon_LABDEPTH_moving_average_window_5.txt

lon_min=`echo "90"`
lon_max=`echo "120"`
lat_min=`echo "5"`
lat_max=`echo "30"`

echo "Map to be plotted within ${lon_min}E/${lon_max}E/${lat_min}N/${lat_max}N"

input=LM_thickness.txt
#input=Lat_lon_LABDEPTH_unsmoothed.txt
##pip=`ls $input| awk -F"_" '{print$4"_"$5"_"$6"_"$7}'| awk -F"." '{print $1}'`
#input=Lat_lon_LABDEPTH_v1.txt
proj="-JM6.5i"
bounds="-R${lon_min}/${lon_max}/${lat_min}/${lat_max}"
out="SE_Asia_Lithospheric_thickness"

#GRD
echo "GRD..."
cat $input| awk '{print $2,$1,$3}' |gmt surface $bounds -I1m -T0.25 -G$out.grd #this way the nan values are not taken into account
#cat $input| awk '{print $2,$1,$3}'| gmt xyz2grd $bounds -I1m -G$out.grd



#CPT
echo "CPT..."
dp_min=10
dp_max=201
#dp_min=40
#dp_max=300
#dp_max=`cat $input| sort -n -k3 | awk '{print $3}'| tail -1`
diff=`echo "${dp_max} ${dp_min}"| awk '{print $1-$2}'`
vag=11
incre=`echo $diff $vag| awk '{print $1/$2}'`

gmt makecpt -I -Cjet -Z -T$dp_min/$dp_max/$incre > $out.cpt
echo "B 128/0/128">>$out.cpt
echo "F 0/0/0" >> $out.cpt
echo "N 255/255/255" >> $out.cpt  # Assign white color to NaN values

#Plotting
echo "plotting..."
gmt psbasemap $proj $bounds -Bxa -Bya -BWSen+t"Lithospheric mantle thickness" -K > $out.ps

gmt grdimage $out.grd $proj $bounds -C$out.cpt -K -O >> $out.ps
#gmt grdimage $out.grd $proj $bounds -C$out.cpt -K -O >> $out.ps  # Use -Q to handle NaNs


gmt psscale $bounds $proj -DjCT+w5.8i+o12.0/0.1c+v+e -C$out.cpt -Bxa -By+l"Lithospheric mantle(km)" -O -K >> $out.ps

#gmt pscoast $bounds $proj -Bxa -Bya -Df -W0.1p,black -K -O >> $out.ps
gmt pscoast $bounds $proj -Bxa -Bya -Df -W0.1p,black -K -O >> $out.ps

dig="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/boundaries"

gmt psxy ${dig}/sutures_v3.txt -JM -R -W0.5p,white -K -O >> $out.ps

gmt psxy ${dig}/trench.txt -JM -R -W0.8p,red -K -O >> $out.ps

gmt psxy ${dig}/tmp_Sag.txt -JM -R -W0.8p,white -K -O >> $out.ps

cat ${dig}/volcanoes_RB.txt | awk '{print $2,$1}'| gmt psxy -JM -R -K -O -St7p -Gred -Wwhite >> $out.ps

gmt psbasemap $proj $bounds -Bxa -Bya -BWSen -O </dev/null >> $out.ps

gv $out.ps

gmt psconvert $out.ps -Tg
gmt psconvert $out.ps -Tf
rm gmt.history
#rm $out.grd
#rm $out.cpt


