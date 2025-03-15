#!/bin/bash
#This script used for plotting the region for which the histogram is made
#Note that although the histogram is made without KP, but while plotting this region
#KP is included
#Input- vertically_avg_Vs_80_to_220_km.txt

echo "Enter min dp:(e.g. -80)"
read fdp
echo ""
echo "Enter max dp (e.g - 220)"
read edp
echo ""


slo_SE_minlon=`echo "98"`
slo_SE_maxlon=`echo "118"`
slo_SE_minlat=`echo "10"`
slo_SE_maxlat=`echo "24"`
echo "Slow anomy in SE Asia is spread at- ${slo_SE_minlon}E/${slo_SE_maxlon}E/${slo_SE_minlat}N/${slo_SE_maxlat}E"

bounds="-R${slo_SE_minlon}/${slo_SE_maxlon}/${slo_SE_minlat}/${slo_SE_maxlat}"
proj="-JM5i"
#out="SE_Asia_hist_region_${fdp}_to_${edp}"
out="SE_Asia_hist_region_${fdp}_to_${edp}_common_palette"


rm tmp_*
cat vertically_avg_Vs_${fdp}_to_${edp}_km.txt| awk -v slo_SE_minlon="$slo_SE_minlon" -v slo_SE_maxlon="$slo_SE_maxlon" -v slo_SE_minlat="$slo_SE_minlat" -v slo_SE_maxlat="$slo_SE_maxlat" '{if ($1>=slo_SE_minlon && $1<=slo_SE_maxlon && $2>=slo_SE_minlat && $2<=slo_SE_maxlat)print $0}' >> tmp_1

awk '$3 != 9998.999949994999' tmp_1 > tmp_2


#minVs=`cat tmp_2| sort -n -k3| awk '{print $3}'| head -1`
#maxVs=`cat tmp_2| sort -n -k3| awk '{print $3}'| tail -1`

#diff=`echo "$maxVs $minVs"| awk '{print $1-$2}'`
#vag=`echo "11"`
#incre=`echo $diff $vag| awk '{print $1/$2}'`

dig="/media/rupak/Rupak_4TB/BACKUPS/MANUSCRIPTS_Rupak/SE_ASIA_MANU_DRAFTS/MERGED/Manu_figs_organised/text_fig/GitHub_upload/boundaries"

#echo "It has the minimum avg Vs= $minVs and ma avg Vs=$maxVs"


#GRD
echo "Making grd file..."

cat tmp_2 |awk '{print $0}'| gmt surface $bounds -I1m -T0.1 -Gtmp_SE_Asia_${fdp}_${edp}.grd 
echo ""

#CPT
#echo "Making CPT..."
#gmt grd2cpt tmp_SE_Asia_${fdp}_${edp}.grd ${bounds} -T${minVs}/${maxVs}/${incre} -I -Z > cdf_${fdp}_to_${edp}.cpt

echo "Making common paltte CPT..."
rm common_pallete.cpt
gmt makecpt -Cjet -T4.25/4.55/0.1 -I -Z > common_pallete.cpt
echo "B 128/0/128" >> common_pallete.cpt # Purple for values below minVs
echo "F 0/0/0" >> common_pallete.cpt # Black for values above maxVs

echo ""
echo "Starting to plot..."
gmt psbasemap $proj $bounds -Bxa2f2 -Bya2f2 -BWSen -K > $out.ps

#gmt grdimage tmp_SE_Asia_${fdp}_${edp}.grd -Ccdf_${fdp}_to_${edp}.cpt $bounds $proj -K -O >> $out.ps
gmt grdimage tmp_SE_Asia_${fdp}_${edp}.grd -Ccommon_pallete.cpt $bounds $proj -K -O >> $out.ps

gmt psscale ${bounds} ${proj} -DjCT+w3.7i+o9/0.1c+v+e -Ccommon_pallete.cpt -Bxa0.02f0.01 -By+l"meanVs (km/s)" -O -K >> $out.ps

gmt pscoast ${bounds} ${proj} -Bxa2f2 -Bya2f2 -Df -W0.1p,black -K -O >> $out.ps

gmt psxy ${dig}/sutures_v3.txt -K -O -JM -R -W0.5p,white >> $out.ps

gmt psxy ${dig}/trench.txt -K -O -JM -R -W0.8p,red >> $out.ps

cat ${dig}/volcanoes_RB.txt| awk '{print $2,$1}'|gmt psxy -JM -R -K -O -St7p -Gred -Wwhite >> $out.ps

gmt psbasemap $proj $bounds -Bxa2f2 -Bya2f2 -O </dev/null>> $out.ps

gv ${out}.ps

gmt psconvert ${out}.ps -Tg
rm tmp_SE_Asia_${fdp}_${edp}.grd
rm cdf_${fdp}_to_${edp}.cpt
rm tmp_*
rm gmt.history
