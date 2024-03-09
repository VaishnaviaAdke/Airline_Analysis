create database highcloud;
use highcloud;

-- Kpi 1 : calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
-- A.Year
-- B.Monthno
-- C.Monthfullname
-- D. Quarter(Q1,Q2,Q3,Q4)
-- E. YearMonth ( YYYY-MMM)
-- F. Weekdayno
-- G.Weekdayname

ALTER TABLE airlines
ADD COLUMN DateField DATE;

UPDATE airlines
SET DateField = STR_TO_DATE(CONCAT(Year, '-', Monthone, '-', Day), '%Y-%m-%d');

ALTER TABLE airlines
ADD COLUMN Year1 INT,
ADD COLUMN Monthno1 INT,
ADD COLUMN Monthfullname1 VARCHAR(20),
ADD COLUMN Quarter1 VARCHAR(5),
ADD COLUMN YearMonth1 VARCHAR(7),
ADD COLUMN Weekdayno1 INT,
ADD COLUMN Weekdayname1 VARCHAR(20),
ADD COLUMN FinancialMonth1 INT,
ADD COLUMN FinancialQuarter1 VARCHAR(2);
  
  -- Alter the length of YearMonth1 column to a larger value
ALTER TABLE airlines
MODIFY COLUMN YearMonth1 VARCHAR(40); 
  
  UPDATE airlines
SET
  Year1 = YEAR(DateField),
  Monthno1 = Monthone,
  Monthfullname1 = MONTHNAME(DateField),
  Quarter1 = QUARTER(DateField),
  YearMonth1 = DATE_FORMAT(DateField,'%Y-%b'),
  Weekdayno1 = DAYOFWEEK(DateField),
  Weekdayname1 = DAYNAME(DateField);

-- Financial Month
SET SQL_SAFE_UPDATES = 0;

UPDATE airlines
SET FinancialMonth1 = CASE
                       WHEN MONTH(DateField) >= 4 THEN MONTH(DateField) - 3
                       ELSE MONTH(DateField) + 9
                    END; 

SET SQL_SAFE_UPDATES = 1;

SELECT FinancialMonth1
FROM airlines; 

-- Kpi 2 : Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)
SELECT
    Year,
    Quarter,
    MonthFullName,
    CONCAT(ROUND(AVG(TransportedPassengers * 100.0 / AvailableSeats), 2), '%') AS LoadFactor
FROM
    airlines
GROUP BY
    Year, Quarter, MonthFullName
ORDER BY
    Year, Quarter, MonthFullName;

-- kpi 3 : Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)
SELECT
    CarrierName,
     CONCAT(ROUND(AVG(TransportedPassengers * 100.0 / AvailableSeats), 2), '%') AS LoadFactor
FROM
    airlines
WHERE
    TransportedPassengers IS NOT NULL
    AND AvailableSeats IS NOT NULL
GROUP BY
    CarrierName
HAVING
    LoadFactor IS NOT NULL
ORDER BY
    CarrierName;
    
-- Kpi 4 :Identify Top 10 Carrier Names based passengers preference 
SELECT
    CarrierName,
	 count(TransportedPassengers)AS TotalTransportedPassengers
FROM
    airlines
WHERE
    TransportedPassengers IS NOT NULL
GROUP BY
    CarrierName
ORDER BY
    TotalTransportedPassengers DESC
LIMIT 10;

-- Kpi 5 : Display top Routes ( from-to City) based on Number of Flights 
SELECT
    `From-ToCity` AS Route,
    COUNT(*) AS Number_Of_Flights
FROM
    airlines
GROUP BY
    `From-ToCity`
ORDER BY
    Number_Of_Flights DESC
LIMIT 20;

-- Kpi 6 : Identify the how much load factor is occupied on Weekend vs Weekdays.
SELECT
    CASE
        WHEN DAYOFWEEK(Date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    AVG(TransportedPassengers * 100.0 / AvailableSeats) AS LoadFactor
FROM
    airlines
WHERE
    TransportedPassengers IS NOT NULL
    AND AvailableSeats IS NOT NULL
GROUP BY
    DayType;
  
-- Kpi 7 : Use the filter to provide a search capability to find the flights between Source Country,State, City to Destination Country ,State,City 
SELECT
    OriginCountry,
    OriginState,
    OriginCity,
    DestinationCountry,
    DestinationState,
    DestinationCity,
    COUNT(*) AS FlightCount
FROM
    airlines
GROUP BY
    OriginCountry,
    OriginState,
    OriginCity,
    DestinationCountry,
    DestinationState,
    DestinationCity;

-- Kpi 8 : Identify number of flights based on Distance groups
SELECT
    DistanceGroups,
    COUNT(*) AS Number_Of_Flights
FROM
    airlines
GROUP BY
    DistanceGroups;

-- Kpi 9 : Flights Per Financial Quarter
SELECT
    FinancialQuarter,
    COUNT(*) AS Number_Of_Flights
FROM
    airlines
GROUP BY
    FinancialQuarter;

-- Kpi 10 : Flight Types using Load Factor
SELECT
    `Flight Types`,
	 CONCAT(ROUND(SUM(TransportedPassengers) / SUM(AvailableSeats) * 100, 2), '%') AS LoadFactor
FROM
   airlines
GROUP BY
    `Flight Types`;





