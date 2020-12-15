[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# VBOHCA

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

The software and data in this repository are a snapshot of the software and data that were used in the research reported on in the paper [Spatiotemporal Data Set for Out-of-Hospital Cardiac Arrests](https://doi.org/10.1287/ijoc.2020.1022) by J. Custodio and M. Lejeune.

**Important: This code is being developed on an on-going basis at https://github.com/janielecustodio/VBOHCA. Please go there if you would like to get a more recent version or would like support.**

## Cite

To cite this software, please cite the [paper](https://doi.org/10.1287/ijoc.2020.1022) and the software, using the following DOI.

[![DOI](https://zenodo.org/badge/288628515.svg)](https://zenodo.org/badge/latestdoi/288628515)

Below is the BibTex for citing this version of the code.

```
@article{VBOHCA,
  author =        {J. Custodio and M. Lejeune},
  publisher =     {INFORMS Journal on Computing},
  title =         {{VBOHCA} Version v2020.1022},
  year =          {2020},
  doi =           {10.5281/zenodo.4079985},
  url =           {https://github.com/INFORMSJoC/2020.1022},
}  
```

## How to use these files

The files provided in this repository are the online supplement to the paper *Spatiotemporal Data Set for Out-of-Hospital Cardiac Arrests (Custodio and Lejeune, 2020)*. The files have been generated to cover OHCA incidents recorded by the city of Virginia Beach from January 1, 2017 to June 30, 2019. However, the SAS program provided in this repository can be used to process data for different time periods, depending on the files uploaded to the folder [input](data/input).

## Input Data

### data/auxiliary
Stores auxiliary SAS data files.

### data/input
Stores input data files, obtained from the [Open VB data portal](https://data.vbgov.com/). Users must upload three data files, which should be saved as .xslx: *EMS_Calls_For_Service*, *Fire_Calls_For_Service*, and *Police_Calls_For_Service*. This repository includes a sample version of [EMS_Calls_For_Service]( 2020-02-OA-046/data/input/EMS_Calls_For_Service.xlsx) obtained through a FOIA request. It also contains a version of the [Fire_Calls_For_Service](2020-02-OA-046/data/input/Fire_Calls_For_Service.xlsx) and the [Police_Calls_For_Service](2020-02-OA-046/data/input/Police_Calls_For_Service.xlsx) data sets, which were downloaded from the [Open VB data portal](https://data.vbgov.com/). All files cover the period from January 1, 2017 until June 30, 2019. These files are processed using the SAS program, which generates the OHCA occurrences for a given time period. Details of the analysis can be found in the associated paper (Custodio and Lejeune, 2020).

## Virginia Beach OHCA Dispatch Data Set (VBOHCAR)

The Excel file [VBOHCAR](results/VBOHCAR.xlsx) contains the final data set of all OHCAs registered in the city of Virginia Beach from January 1, 2017, until June 30, 2019. The file contains three sheets, which are described in more detail below.

### OHCAs
Contains the spatiotemporal information about all dispatches made by either the EMS, Fire or Police department for the city of Virginia Beach that were initially classified as an OHCA. It includes an ID number that was created by the authors to identify each OHCA occurrence, the time of the call for service, the response time in minutes of the first unit on scene, the latitude and longitude of the OHCA incident and the corresponding ECEF coordinates. The data in the sheet was generated using SAS ([data_consolidation.sas](scripts/data_consolidation.sas))

### Base_Stations
Contains the spatial information for all the first-responder stations in the city of Virginia Beach. The data set includes an ID created by the research team to track each base station, the address of the base station, as well as the latitude, longitude, and ECEF coordinates for each base.

### Distances
Contains both the Haversine and the road distances for each OHCA-Base station pair.

### Variables
The table below describes the variables in the [VBOHCAR](results/VBOHCAR.xlsx) data set. For more details on how the databases were constructed, please refer to the main text.

|     Variable Name     	|    Unit    	|                                             Description                                            	|
|:---------------------:	|:----------:	|:--------------------------------------------------------------------------------------------------:	|
|        ID OHCA        	|     N/A    	|                                      ID of the OHCA occurrence                                     	|
|     Received Time     	|     N/A    	|                                          Time of the call                                          	|
| Minimum Response Time 	|   Minutes  	|                             Response time of the first unit on scene                               	|
|      OHCA Street      	|     N/A    	|                 Address of the cardiac arrest incident rounded to the nearest block                	|
|     OHCA Latitude     	|   Degrees  	|                                    Latitude of the OHCA incident                                   	|
|     OHCA Longitude    	|   Degrees  	|                              Longitude of the OHCA incident in degrees                             	|
|         X OHCA        	| Kilometers 	|                   X coordinate of the OHCA incident in the ECEF coordinate system                  	|
|         Y OHCA        	| Kilometers 	|                   Y coordinate of the OHCA incident in the ECEF coordinate system                  	|
|         Z OHCA        	| Kilometers 	|                   Z coordinate of the OHCA incident in the ECEF coordinate system                  	|
|        ID Bases       	|     N/A    	|                                  ID of the first responder station                                 	|
|       Base Type       	|     N/A    	|                                Type of station (EMS, Fire or Police)                               	|
|      Base Street      	|     N/A    	|                                     Address of the base station                                    	|
|     Base Latitude     	|   Degrees  	|                               Latitude of the first responder station                              	|
|     Base Longitude    	|   Degrees  	|                              Longitude of the first responder station                              	|
|         X Base        	| Kilometers 	|                   X coordinate of the base station in the ECEF coordinate system                   	|
|         Y Base        	| Kilometers 	|                                         Y coordinate of the                                        	|
|         Z Base        	| Kilometers 	|                                         Z coordinate of the                                        	|
|     Road Distance     	|   Meters   	|                      Road distance between each base station and OHCA incident                     	|
|  Harversine Distance  	|   Meters   	|                  Straightline distance between each base station and OHCA incident                 	|

## Data Processing

The SAS file [data_consolidation.sas](scripts/data_consolidation.sas) was used to clean and analyze the raw input data sets and to generate the list of OHCAs and response times, as well as spatial information for each OHCA incident. This file can be used to analyze any time period, depending on the input files uploaded to the folder [input](data/input). Users can use the directory *C://2020-02-OA-046* to save the folders [input](data/input) and [auxiliary](data/auxiliary). If using a customized directory, users must modify the paths in the SAS source code so that the correct files are referenced.

## Random Sample Generation

The MATLAB file [test_cases.m](scripts/test_cases.m) can be used to generate random instances from the VBOHCAR data set as it is. If users choose to consider a different time period, the file [VBOHCAR](results/VBOHCAR.xlsx) must be adjusted so that the sheet *Distances* includes all OHCA occurrences and links to the road distances. Additionally, users must also adjust the MATLAB source code so that no errors occur when reading the data sets.

The code takes as input the VBOHCAR data set and users can specify the following parameters:

1. Number of OHCA incidents in the generated sample.
2. Method to determine the base stations:
  (a) Catchment area
  (b) Random sample
3. Method to determine the distances between bases and OHCAs:
  (a) Road distances
  (b) Haversine method
4. Number of samples to generate
5. How to generate different samples:
  (a) Randomly shuffling a baseline instance
  (b) Randomly selecting different instances from the full dataset

The OHCA incidents are selected randomly based on the sample size defined by the user. If the base stations are selected using the catchment area, users can define whether
they want to use the road distances (e.g. for land-based transportation modes) or the haversine distances (e.g. for airborne transportation). The user must select a catchment area that is large enough so that each OHCA has at least one base within the specified distance. The code calculates the minimum size of the catchment area based on the OHCAs that were randomly selected. When the bases are selected randomly, the approach is similar to the one used to generate the OHCA sample.

The output of the randomly selected OHCAs and base stations are written, respectively, on the csv files *OHCAs_out_sample1.csv* and *Bases_out_sample1.csv*. Each file contains, respectively, the ID of the OHCA or base station, the latitude, and the longitude. Additionally, the code also generates the file *dist_out_sample1.csv* with the distances between each OHCA and base station. The first column and row of the distance file represent, respectively, the original ID of the OHCA location and the original ID of the base station. The body of the table contains the distance in meters. A sample output is available in the online supplement and saved in the folder [random_sample](results/random_sample).

## Results

### results/random_sample
Contains a random sample generated using the MATLAB code available with this package.

### results/shortest_paths
The folder [shapefiles](results/shortest_paths/shapefiles) contains the shapefiles used to calculate shortest paths using the road distances for the sample in the folder [random_sample](results/random_sample). The road distances were determined using QGIS, an open source geographic information system application. Input files were obtained from the [VB Open GIS portal](https://gis.data.vbgov.com/) and [US Census Bureau](https://data.gov/organization/census-gov/). The main text contains more details about the approach we used to calculate the road distances. The QGIS Project file [VBOHCA_Sample1](results/shortest_paths/VBOHCA_sample1.qgz) contains the map used in the analysis. The map can be recreated using the files in the folder [shapefiles](results/shortest_paths/shapefiles).

## Ongoing Development

This code is being developed on an on-going basis at the author's [Github site](https://github.com/janielecustodio/VBOHCA).

## Support

For support in using this software, submit an [issue](https://github.com/janielecustodio/2020-02-OA-046/issues).
