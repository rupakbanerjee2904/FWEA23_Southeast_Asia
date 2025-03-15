#!/bin/bash 
#This script plots the vertically avergaed Vs on a 2D lon-lat space
#input-vertically_avg_Vs_${fdp}_to_${edp}_km.txt

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

rm tmp_avgVs_${fdp}_to_${edp}
cat vertically_avg_Vs_${fdp}_to_${edp}_km.txt | awk -v lonmin=$lonmin -v lonmax=$lonmax -v latmin=$latmin -v latmax=$latmax '{if ($1>=lonmin && $1<=lonmax && $2>=latmin && $2<=latmax ) print $0}' >> tmp_avgVs_${fdp}_to_${edp}

proj="-JM8i"
bounds="-R$lonmin/$lonmax/$latmin/$latmax"
miscB="-BWeSna10f10/a5f5"
misc="-V"
#out="vertically_meanVs_${fdp}_to_${edp}"
out="vertically_meanVs_${fdp}_to_${edp}_common_cpt"

rm tmp_avgVs_${fdp}_to_${edp}_filt
awk '$3 != 9998.999949994999' tmp_avgVs_${fdp}_to_${edp} > tmp_avgVs_${fdp}_to_${edp}_filt #removing the fill value from the nc file

#echo "Enter minVs: (from /media/rupak/Rupak_4TB/BACKUPS/FWI/average_plot/abs_Vs/v5/files/smallest_avgVs_${fdp}_to_${edp}_km.txt)"
#read minVs
echo ""

#minVs=`cat tmp_avgVs_${fdp}_to_${edp}_filt| awk '{print $3}'| sort -n| head -1`
#maxVs=`cat tmp_avgVs_${fdp}_to_${edp}_filt| awk '{print $3}'| sort -n| tail -1`

#diff=`echo "$maxVs $minVs"| awk '{print $1-$2}'`
#vag=`echo "11"`
#incre=`echo $diff $vag| awk '{print $1/$2}'`

#echo "incre=$incre"

echo "file- vertically_avg_Vs_${fdp}_to_${edp}_km.txt"
echo "map extent-${lonmin}E/${lonmax}E/${latmin}N/${latmax}E"
#echo "It has the minimum avg Vs= $minVs and ma avg Vs=$maxVs"
echo ""
echo ""

echo "making grd..."
#GRD
cat tmp_avgVs_${fdp}_to_${edp}_filt| awk '{print $1,$2,$3}'| gmt surface ${bounds} -I1m -T0.1 -Gmean_Vs_${fdp}_to_${edp}.grd

#echo "making cpt..."
echo ""
#CPT
#rm cdf_${fdp}_to_${edp}.cpt
#gmt grd2cpt mean_Vs_${fdp}_to_${edp}.grd $bounds -T${minVs}/${maxVs}/${incre} -I -Z > cdf_${fdp}_to_${edp}.cpt
#gmt grd2cpt mean_Vs_${fdp}_to_${edp}.grd $bounds -L4.27/4.855 -I -Z > cdf_${fdp}_to_${edp}.cpt

echo "making common cpt..."
rm common_pallete.cpt
gmt makecpt -Cjet -T4.25/4.55/0.1 -I -Z > common_pallete.cpt
echo "B 128/0/128" >> common_pallete.cpt # Purple for values below minVs
echo "F 0/0/0" >> common_pallete.cpt # Black for values above maxVs


#Plotting
echo "Plotting..."

gmt psbasemap $bounds $proj -Bxa5f5 -Bya5f5 -BWSEN -K > $out.ps

#gmt grdimage mean_Vs_${fdp}_to_${edp}.grd -Ccdf_${fdp}_to_${edp}.cpt $bounds $proj -K -O >> $out.ps

gmt grdimage mean_Vs_${fdp}_to_${edp}.grd -Ccommon_pallete.cpt $bounds $proj -K -O >> $out.ps

#gmt psscale ${bounds} ${proj} -DjCT+w4.8i+o13/0.1c+v -Ccdf_${fdp}_to_${edp}.cpt -Bxa0.02f0.01 -By+l"meanVs (km/s)" -O -K >> $out.ps #perfect psscale command to plot it in a linear scale with 1 digit after decimal
gmt psscale ${bounds} ${proj} -DjCT+w4.8i+o13/0.1c+v+e -Ccommon_pallete.cpt -Bxa0.02f0.01 -By+l"meanVs (km/s)" -O -K >> $out.ps #perfect psscale command to plot it in a linear scale with 1 digit after decimal

#gmt psscale ${bounds} ${proj} -DjCT+w5i+o2/1.8c+v -Ccdf_${fdp}_to_${edp}.cpt -By+l"meanVs (km/s)":  -L -S -O -K >> $out.ps

gmt pscoast ${bounds} ${proj} -Bxa5f5 -Bya5f5 -Df -W0.1p,black -K -O >> $out.ps
#gmt pscoast ${bounds} ${proj} -Df -W0.1p,black -K -O >> $out.ps

gmt psxy ${dig}/sutures_v3.txt -K -O -JM -R -W0.5p,white >> $out.ps

gmt psxy ${dig}/trench.txt -K -O -JM -R -W0.8p,red >> $out.ps

cat ${dig}/volcanoes_RB.txt| awk '{print $2,$1}'|gmt psxy -JM -R -K -O -St7p -Gred -Wwhite >> $out.ps

gmt psbasemap ${bounds} ${proj} -Bxa5f5 -Bya5f5 -O < /dev/null  >> $out.ps

rm gmt.history

gv ${out}.ps

rm cdf_${fdp}_to_${edp}.cpt
rm mean_Vs_${fdp}_to_${edp}.grd
rm tmp_*

gmt psconvert ${out}.ps -Tg
