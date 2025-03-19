# FWEA23_Southeast_Asia
This repository contains the analysis and plotting codes used in the interpretation study of Full waveform model FWEA23 in Southeast Asia


#This readme file contains directory information.
#Specific directories holds particular analysis/plots used in the manuscript

#Input directories --
1. boundaries -- contains specific digitised value files used in the plotting
2. model -- holds the FWEA23 model in netCDF format (needs to be downloaded from https://ds.iris.edu/ds/products/emc-fwea23/ and put in in directory 'model')
3. crust1.0 -- holds the CRUST1.0 file in netCDF format
4. GLAD_model -- holds the global GLAD-M25 model (needs to be downloaded from https://ds.iris.edu/ds/products/emc-glad-m25/ and put in in directory 'GLAD_model')

#Analysis/Plots--
1. point spread -- the point spreads for the perturbation introduced toour final model (dlnV); point spreads after one iteration for beta in Southeast Asia (beta)

2. map -- plots the depth maps for beta (Vs perturbation from the 1-D reference velocity) for certain depths

3. vertical avg -- calculates the vertical average for FWEA23 at 100-220 km depth and associated histogram

4. GLAD-M25 -- calculates and plots the vertically averaged GLAD global model in 100-220 km depths and associated histogram

5. LAB -- calculates and plots the seismic Lithosphere-Asthenosphere boundary depth and calculates the thickness of sub-lithospheric mantle by doing (LAB depth - Moho depth)

6. VSH/VSV_ratio -- calculates and plots the VSH/VSV ratio for different depths in Southeast Asia

P.S. -- Each directory contains 'files' and 'script' subdirectories used for their corresponding analysis. Additional details could be found on the README files and the scripts within the 'script' directories.

For more information, please feel free to contact -- rb18rs021@iiserkol.ac.in
