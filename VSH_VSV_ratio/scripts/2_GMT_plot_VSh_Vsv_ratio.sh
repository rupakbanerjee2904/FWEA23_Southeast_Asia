#!/bin/bash
#This script plots the Xi values using VSH_VSV_ratio_*_km files
#VSH_VSV_ratio_*_km files is output from the 1_Calc_*.pynb file

echo "Enter dp:"
read dp

echo ""

lonmin=`echo "85"`
lonmax=`echo "130"`
latmin=`echo "0"`
latmax=`echo "40"`

dig="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/boundaries"

proj="-JM6i"
bounds="-R$lonmin/$lonmax/$latmin/$latmax"
out="VSH_VSV_ratio_${dp}_km"

#cat VSH_VSV_ratio_${dp}_km| awk '{print $1,$2,$5}'| gmt surface $proj $bounds > VSH_VSV_ratio_${dp}_km.grd


#GRD
echo "Making grd..."
cat VSH_VSV_ratio_${dp}_km | awk -v lonmin=$lonmin -v lonmax=$lonmax -v latmin=$latmin -v latmax=$latmax '{if($1>=lonmin && $1<=lonmax && $2>=latmin && $2<=latmax) print $1, $2, $5}'| gmt surface $bounds -I1m -T0.1 -GVSH_VSV_ratio_${dp}_km.grd


#CPT
echo "making cpt..."
gmt makecpt -T0.94/1.06/0.01 -I -Z > VSH_VSV_ratio_${dp}_km.cpt

echo ""

echo "plotting..."
gmt psbasemap -Bxa10f10 -Bya10f10 -BWSEN+t"${dp} km" $proj $bounds -K > $out.ps

gmt grdimage VSH_VSV_ratio_${dp}_km.grd -CVSH_VSV_ratio_${dp}_km.cpt $proj $bounds -K -O >> $out.ps

gmt psscale ${bounds} ${proj} -DjCT+w5i+o10.6/1.2c+v -CVSH_VSV_ratio_${dp}_km.cpt -Bxa0.01f0.01 -By+l"VSH/VSV":  -O -K >> $out.ps #perfect psscale command to plot it in a linear scale with 1 digit after decimal

gmt pscoast ${bounds} ${proj} -Bxa10f10 -Bya10f10 -Df -W0.1p,black -K -O >> $out.ps

gmt psxy ${dig}/sutures_v3.txt -K -O -JM -R -W0.5p,white >> $out.ps

gmt psxy ${dig}/trench.txt -K -O -JM -R -W0.8p,red >> $out.ps

cat ${dig}/volcanoes_RB.txt| awk '{print $2,$1}'|gmt psxy -JM -R -K -O -St7p -Gred -Wwhite >> $out.ps


gmt psbasemap $proj $bounds -Bxa10f10 -Bya10f10 -O</dev/null >>$out.ps

gv $out.ps

rm gmt.history

rm VSH_VSV_ratio_${dp}_km.cpt VSH_VSV_ratio_${dp}_km.grd
gmt psconvert $out.ps -Tg
