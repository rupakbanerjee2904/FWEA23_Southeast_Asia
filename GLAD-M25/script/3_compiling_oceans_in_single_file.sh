#!/bin/bash
#RUpak, Oct 12 24
#This script merges all the ocean files into one file which can be used for histograms

#note this compilation holds the 

#for dp in 80
for dp in 90 100 110 120 130 140
do

	rm GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_IND_OCEAN.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_Latin_Am_sea.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt

	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_NAtlantic.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_PAC_OCEAN.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_SAtlantic.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_S_Australia.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt
	cat GLAD_vertically_avg_Vs_${dp}_to_220_km_South_Afr_sea.txt >> GLAD_all_ocean_${dp}_to_220_compilation.txt

done #$dp
GLAD_vertically_avg_Vs_${dp}_to_220_km_South_Afr_sea.txt
