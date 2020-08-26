/* Copyright (c) 2020, Janiele Eduarda Silva Costa Custodio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */


/*The directories assumes that the repository "2020-02-OA-046" is saved under "C:\". Please edit the paths if using an alternate directory*/

/* Creates library to store auxiliary data sets */
libname mydata 'C:\2020-02-OA-046\auxiliary';

/* Reads raw data files */
filename Fire_raw 'C:\2020-02-OA-046\data\input\Fire_Calls_For_Service.xlsx';
filename Poli_raw 'C:\2020-02-OA-046\data\input\Police_Calls_For_Service.xlsx';
filename EMS_raw 'C:\2020-02-OA-046\data\input\EMS_Calls_For_Service.xlsx';

/* Import Raw Data Sets */
PROC IMPORT DATAFILE=Fire_raw OUT=mydata.Fire DBMS=XLSX REPLACE; RUN;
PROC IMPORT DATAFILE=Poli_raw OUT=mydata.Police DBMS=XLSX REPLACE; RUN;
PROC IMPORT DATAFILE=EMS_raw OUT=  mydata.EMS DBMS=XLSX REPLACE; RUN;

/* Create SAS Data Sets */
PROC SQL;
CREATE TABLE mydata.Fire_RT AS
SELECT Incident_ID,  year(datepart(Call_Date_and_Time)) AS FIRE_YEAR, Call_Date_and_Time, Dispatch_Date_and_Time, En_Route_Date_and_Time,  
Close_Date_and_Time, Incident_Location, Location_1, (On_Scene_Date_and_Time-Call_Date_and_Time)/60 AS FIRE_RESPONSE_TIME, 
SUBSTR(CATS(SUBSTR(Incident_Location, 1, 10),Call_Date_and_Time),1,20) AS KEY_Fire, SUBSTR(Incident_Location, 1, 10) AS KEY_Fire1, SUBSTR(Incident_Location, 1, 10) AS Key_Address
FROM mydata.Fire
GROUP BY Call_Date_and_Time
HAVING FIRE_RESPONSE_TIME=min(FIRE_RESPONSE_TIME) AND FIRE_RESPONSE_TIME>=0
ORDER BY Call_Date_and_Time
;
QUIT;

PROC SQL;
CREATE TABLE MYDATA.Fire_Addresses AS
SELECT Key_Address, Location_1, Incident_Location,
substr(substr(Location_1,findc(Location_1, '(')+1,findc(Location_1, ')')-1-findc(Location_1, '(')),1,findc(substr(Location_1,findc(Location_1, '(')+1,findc(Location_1, ')')-1-findc(Location_1, '(')), ',')-1) AS Lat format=$25.,
substr(substr(Location_1,findc(Location_1, '(')+1,findc(Location_1, ')')-1-findc(Location_1, '(')),findc(substr(Location_1,findc(Location_1, '(')+1,findc(Location_1, ')')-1-findc(Location_1, '(')), ',')+1) AS Long format=$25.
FROM MYDATA.Fire_RT
GROUP BY Key_Address
HAVING FIRE_RESPONSE_TIME=min(FIRE_RESPONSE_TIME)
ORDER BY Key_Address
;
QUIT;

PROC SQL;
CREATE TABLE MYDATA.Fire_Addresses AS
SELECT Key_Address format $85.,
CASE
	WHEN input(Long,25.)<0 THEN input(Long,25.)
    ELSE 0         
END AS Longitude,
CASE
	WHEN input(Lat,25.)>=0 THEN input(Lat,25.)
    ELSE 0         
END AS Latitude, Incident_Location
FROM MYDATA.Fire_Addresses
GROUP BY Key_Address, Longitude, Latitude
HAVING Longitude < 0 AND Latitude > 0
ORDER BY Key_Address
;
QUIT;

PROC SORT DATA = MYDATA.Fire_Addresses NODUP;
BY _all_;
RUN;


PROC SQL;
CREATE TABLE mydata.Police_RT AS
SELECT Incident_Number, Call_Type, Call_Date_Time, On_Scene_Date_Time, Entry_Date_Time, Dispatch_Date_Time, Location, (intck('second', Call_Date_Time, On_Scene_Date_Time))/60 AS Police_RESPONSE_TIME, 
SUBSTR(CATS(SUBSTR(Location, 1, 10),Call_Date_Time),1,20) AS KEY_Police, SUBSTR(Location, 1, 10) AS Key_Address, year(datepart(Call_Date_Time)) AS Police_YEAR
FROM mydata.Police
GROUP BY Call_Date_Time
HAVING Police_RESPONSE_TIME=min(Police_RESPONSE_TIME)
ORDER BY Call_Date_Time
;
QUIT;

PROC SQL;
CREATE TABLE MYDATA.Police_Addresses AS
SELECT Key_Address, Location,
substr(substr(Location,findc(Location, '(')+1,findc(Location, ')')-1-findc(Location, '(')),1,findc(substr(Location,findc(Location, '(')+1,findc(Location, ')')-1-findc(Location, '(')), ',')-1) AS Lat format=$25.,
substr(substr(Location,findc(Location, '(')+1,findc(Location, ')')-1-findc(Location, '(')),findc(substr(Location,findc(Location, '(')+1,findc(Location, ')')-1-findc(Location, '(')), ',')+1) AS Long format=$25.,
substr(Location,1,findc(Location, '(')-21) AS Incident_Location
FROM MYDATA.Police_RT
ORDER BY Key_Address
;
QUIT;

PROC SQL;
CREATE TABLE MYDATA.Police_Addresses AS
SELECT Key_Address format $85.,
CASE
	WHEN input(Long,25.)<0 THEN input(Long,25.)
    ELSE 0         
END AS Longitude,
CASE
	WHEN input(Lat,25.)>=0 THEN input(Lat,25.)
    ELSE 0         
END AS Latitude, Incident_Location
FROM MYDATA.Police_Addresses
GROUP BY Key_Address
HAVING Longitude < 0 AND Latitude > 0 AND Longitude=min(Longitude)
ORDER BY Key_Address
;
QUIT;

PROC SORT DATA = MYDATA.Police_Addresses NODUP;
BY _all_;
RUN;

proc append base=MYDATA.Fire_Addresses data=MYDATA.Police_Addresses force nowarn;
RUN;

PROC SORT DATA = MYDATA.Fire_Addresses NODUP;
BY _all_;
RUN;

data MYDATA.Fire_Addresses;
set MYDATA.Fire_Addresses;
IDNew=_n_;
RUN;

PROC SQL;
CREATE TABLE MYDATA.Fire_Addresses AS
SELECT *
FROM MYDATA.Fire_Addresses
GROUP BY Key_Address
HAVING IDNew=min(IDNew)
ORDER BY Key_Address
;
QUIT;

PROC SQL;
CREATE TABLE mydata.EMS_RT AS
SELECT IncidentNumber, IncidentTypeDescription, ONSCENE_TIME, RECEIVED_TIME, 
(intck('second', RECEIVED_TIME, ONSCENE_TIME))/60 AS EMS_RESPONSE_TIME, year(datepart(RECEIVED_TIME)) AS YEAR,
CATX(" ",Block,Street_Name) AS ADDRESS, SUBSTR(CATS(SUBSTR(SUBSTR(CATX(" ",Block,Street_Name), 1, 10),RECEIVED_TIME),1,20) AS KEY
FROM mydata.EMS
GROUP BY RECEIVED_TIME
HAVING EMS_RESPONSE_TIME=min(EMS_RESPONSE_TIME) AND RECEIVED_TIME>=0
ORDER BY RECEIVED_TIME 
;
QUIT;

/* Merge all data sets using the key value */
PROC SQL;
CREATE TABLE mydata.Police_EMS_Fire_full AS
SELECT A.*, B.*, C.*
FROM mydata.EMS_RT A FULL JOIN mydata.Police_RT B 
ON A.KEY = B.KEY_Police
FULL JOIN mydata.Fire_RT C
ON B.KEY_Police = C.KEY_Fire
WHERE Call_Type="CARDIAC ARREST" OR IncidentTypeDescription="CARDIAC ARREST"
ORDER BY RECEIVED_TIME, Call_Date_Time, Call_Date_and_Time
;
QUIT;

/* Creates VBOHCAR Data Set */
PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT 
	CASE
        WHEN MISSING(EMS_RESPONSE_TIME) AND Police_RESPONSE_TIME>=0 THEN Call_Date_Time 
        WHEN MISSING(Police_RESPONSE_TIME) AND EMS_RESPONSE_TIME>=0 THEN RECEIVED_TIME
        WHEN min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME)>=0 AND EMS_RESPONSE_TIME=min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME) THEN RECEIVED_TIME
		WHEN min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME)>=0 AND Police_RESPONSE_TIME=min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME) THEN Call_Date_Time
		WHEN min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME)>=0 AND FIRE_RESPONSE_TIME=min(EMS_RESPONSE_TIME, Police_RESPONSE_TIME,FIRE_RESPONSE_TIME) THEN Call_Date_and_Time
		WHEN MISSING(Police_RESPONSE_TIME) AND MISSING(EMS_RESPONSE_TIME) AND FIRE_RESPONSE_TIME>=0 THEN Call_Date_and_Time
        ELSE 0         
    END AS ReceivedTime format=DATETIME16.,
    CASE
		WHEN MISSING(Police_RESPONSE_TIME) AND MISSING(EMS_RESPONSE_TIME) AND FIRE_RESPONSE_TIME>=0 THEN FIRE_RESPONSE_TIME
		WHEN MISSING(EMS_RESPONSE_TIME) AND MISSING(FIRE_RESPONSE_TIME) THEN Police_RESPONSE_TIME 
        WHEN MISSING(Police_RESPONSE_TIME) AND MISSING(FIRE_RESPONSE_TIME) THEN EMS_RESPONSE_TIME
        WHEN EMS_RESPONSE_TIME>=0 AND Police_RESPONSE_TIME>=0 AND FIRE_RESPONSE_TIME>=0 THEN min(Police_RESPONSE_TIME, EMS_RESPONSE_TIME,FIRE_RESPONSE_TIME)
		ELSE 0        
    END AS MinimumResponseTime,
	CASE
        WHEN FIRE_RESPONSE_TIME>=0 THEN PUT(Location_1, $81.)
        WHEN MISSING(FIRE_RESPONSE_TIME) AND Police_RESPONSE_TIME>=0 THEN PUT(Location, $81.)
        WHEN MISSING(Police_RESPONSE_TIME) AND MISSING(FIRE_RESPONSE_TIME)AND EMS_RESPONSE_TIME>=0 THEN PUT(ADDRESS,$81.)
		ELSE ' '         
    END AS IncidentAddress,
	CASE
        WHEN FIRE_RESPONSE_TIME>=0 THEN KEY_Fire
        WHEN MISSING(FIRE_RESPONSE_TIME) AND Police_RESPONSE_TIME>=0 THEN KEY_Police
        WHEN MISSING(Police_RESPONSE_TIME) AND MISSING(FIRE_RESPONSE_TIME)AND EMS_RESPONSE_TIME>=0 THEN KEY
		ELSE ' '         
    END AS KEY
FROM mydata.Police_EMS_Fire_full
WHERE min(EMS_RESPONSE_TIME,Police_RESPONSE_TIME, FIRE_RESPONSE_TIME)>=0
HAVING MinimumResponseTime>=0
ORDER BY ReceivedTime
;
QUIT; 

PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT *, SUBSTR(IncidentAddress, 1, 10) AS KEY0
FROM mydata.VBOHCAR
ORDER BY ReceivedTime
;
QUIT;

PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT A.*, B.*
FROM mydata.VBOHCAR A left join  mydata.Fire_Addresses B 
ON A.KEY0 = B.KEY_Address
GROUP BY ReceivedTime, KEY0
HAVING MinimumResponseTime=min(MinimumResponseTime)
ORDER BY ReceivedTime;
QUIT;

PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT ReceivedTime, MinimumResponseTime, Latitude, Longitude, Incident_Location, SUBSTR(CATS(SUBSTR(Incident_Location, 1, 10),ReceivedTime),1,19) AS KEY_final, 
(6378.137/SQRT(1-(0.00669437999**2*sin(Latitude*constant("pi")/180)**2)))*cos(Latitude*constant("pi")/180)*cos(Longitude*constant("pi")/180) AS X_OHCA,
(6378.137/SQRT(1-((0.00669437999)**2)*(sin(Latitude*constant("pi")/180)**2)))*cos(Latitude*constant("pi")/180)*sin(Longitude*constant("pi")/180) AS Y_OHCA,
(6378.137/SQRT(1-((0.00669437999)**2)*(sin(Latitude*constant("pi")/180)**2)))*(1-(0.00669437999)**2)*sin(Latitude*constant("pi")/180) AS Z_OHCA
FROM mydata.VBOHCAR
GROUP BY KEY_final, Incident_Location
HAVING MinimumResponseTime=min(MinimumResponseTime) AND Latitude>0
ORDER BY ReceivedTime
;
QUIT;

data mydata.VBOHCAR; set mydata.VBOHCAR; IDNew=_n_; RUN;

PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT *
FROM mydata.VBOHCAR
GROUP BY KEY_final
HAVING IDNew=max(IDNew)
ORDER BY ReceivedTime
;
QUIT;

PROC SORT DATA = MYDATA.VBOHCAR NODUP; BY KEY_final; RUN;

PROC SQL;
CREATE TABLE mydata.VBOHCAR AS
SELECT monotonic() as ID_OHCA, ReceivedTime, MinimumResponseTime, Latitude, Longitude, Incident_Location,  X_OHCA, Y_OHCA,Z_OHCA
FROM mydata.VBOHCAR
ORDER BY ID_OHCA
;
QUIT;

/* Export VBOHCAR as Excel */
PROC EXPORT DATA=mydata.VBOHCAR
            OUTFILE='C:\Online_Supplement\OHCAs.xlsx'
			DBMS=EXCEL REPLACE;
			SHEET='OHCAs';
RUN; 
