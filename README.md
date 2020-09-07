[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# VBOHCA

Online Supplement -- Spatiotemporal Data Set for Out-of-Hospital Cardiac Arrests (Custodio and Lejeune, 2020)

This project is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

The software and data in this repository are a snapshot from the [development repository](https://github.com/janielecustodio/VBOHCA)
of the version used to obtain the results in the paper Spatiotemporal Data Set for Out-of-Hospital Cardiac Arrests (to appear) by J. Custodio and M. Lejeune.

**Important: This code is being developed on an on-going basis at https://github.com/janielecustodio/VBOHCA. Please go there if you would like to get a more recent version or would like support.**

## Cite

To cite this software, please cite the paper using its DOI and the software itself, using its DOI.

## How to use these files
The files provided in this repository are the online supplement to the paper *Spatiotemporal Data Set for Out-of-Hospital Cardiac Arrests (Custodio and Lejeune, 2020)*. The files have been generated to cover OHCA incidents recorded by the city of Virginia Beach from January 1, 2017 to June 30, 2019. However, the SAS program provided in this repository can be used to process data for different time periods, depending on the files uploaded to the folder [input](data/input).

## Input Data
### data/auxiliary
Stores auxiliary SAS data files.
### data/input
Stores input data files, obtained from the [Open VB data portal](https://data.vbgov.com/). Users must upload three data files, which should be saved as .xslx: *EMS_Calls_For_Service*, *Fire_Calls_For_Service*, and *Police_Calls_For_Service*. This repository includes a sample version of [EMS_Calls_For_Service]( 2020-02-OA-046/data/input/EMS_Calls_For_Service.xlsx) obtained through a FOIA request. It also contains a version of the [Fire_Calls_For_Service](2020-02-OA-046/data/input/Fire_Calls_For_Service.xlsx) and the [Police_Calls_For_Service](2020-02-OA-046/data/input/Police_Calls_For_Service.xlsx) data sets, which were downloaded from the [Open VB data portal](https://data.vbgov.com/). All files cover the period from January 1, 2017 until June 30, 2019. These files are processed using the SAS program, which generates the OHCA occurrences for a given time period. Details of the analysis can be found in the associated paper (Custodio and Lejeune, 2020).

## Virginia Beach OHCA Dispatch Data Set (VBOHCAR)
The Excel file [VBOHCAR](results/VBOHCAR.xlsx) contains the final data set of all OHCAs registered in the city of Virginia Beach from January 1, 2017, until June 30, 2019. The file contains three sheets:
- OHCAs: contains the spatiotemporal information about all dispatches made by either the EMS, Fire or Police department for the city of Virginia Beach that were initially classified as an OHCA.
- Base_Stations: contains the spatial information for all the first-responder stations in the city of Virginia Beach.
- Distances: contains both the Haversine and the road distances for each OHCA-Base station pair.

## Data Processing
The SAS file [data_consolidation.sas](scripts/data_consolidation.sas) was used to clean and analyze the raw input data sets and to generate the list of OHCAs and response times, as well as spatial information for each OHCA incident. This file can be used to analyze any time period, depending on the input files uploaded to the folder [input](data/input). Users can use the directory *C://2020-02-OA-046* to save the folders [input](data/input) and [auxiliary](data/auxiliary). If using a customized directory, users must modify the paths in the SAS source code so that the correct files are referenced.

## Results
### results/random_sample
Contains a random sample generated using the MATLAB code available with this package.

### results/shortest_paths
The folder [shapefiles](results/shortest_paths/shapefiles) contains the shapefiles used to calculate shortest paths using the road distances for the sample in the folder [random_sample](results/random_sample). Input files were obtained from the [VB Open GIS portal](https://gis.data.vbgov.com/) and [US Census Bureau](https://data.gov/organization/census-gov/). The QGIS Project file [VBOHCA_Sample1](results/shortest_paths/VBOHCA_sample1.qgz) contains the map used in the analysis. Likewise, the map can be recreated using the files in the folder [shapefiles](results/shortest_paths/shapefiles).

## Random Sample Generation
The MATLAB file [test_cases.m](scripts/test_cases.m) can be used to generate random instances from the VBOHCAR data set as it is. If users choose to consider a different time period, the file [VBOHCAR](results/VBOHCAR.xlsx) must be adjusted so that the sheet *Distances* includes all OHCA occurrences and links to the road distances. Additionally, if a different time period is used, users must also adjust the MATLAB source code so that no errors occur when reading the data sets.

## Ongoing Development

This code is being developed on an on-going basis at the author's
[Github site](https://github.com/janielecustodio/VBOHCA).

## Support

For support in using this software, submit an
[issue](https://github.com/janielecustodio/2020-02-OA-046/issues).
