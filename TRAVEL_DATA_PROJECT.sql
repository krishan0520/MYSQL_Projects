SELECT*FROM
travel_new;
#cleaning Data
# Standardizing date formats 

UPDATE travel_new
SET `Start date`=STR_TO_DATE(`Start date`,'%m/%d/%Y'),
    `End date`=STR_TO_DATE(`End date`,'%m/%d/%Y');
    
# breaking 'Destination' column into city and country

SELECT Destination , SUBSTRING_INDEX(Destination,",",1)
FROM travel_new;

UPDATE travel_new
SET Destination=SUBSTRING_INDEX(Destination,",",1);

# Rename 1st Column 

ALTER TABLE travel_new
CHANGE `ï»¿Trip ID` Trip_ID INT;

# Removing NO data Rows
DELETE FROM travel_new
WHERE Destination='';


#Updating data `Traveler nationality`/ Destination columns

UPDATE travel_new
SET `Traveler nationality`=
   CASE
       WHEN  `Traveler nationality`='USA' THEN 'American'
	   WHEN  `Traveler nationality`='United Kingdom' THEN 'British'
       WHEN  `Traveler nationality`='UK' THEN 'British'
       WHEN  `Traveler nationality`='South Korea' THEN 'Korean' 
	   WHEN  `Traveler nationality`='South Korean' THEN 'Korean'
       WHEN  `Traveler nationality`='United Arab Emirates' THEN 'Emirati'
       WHEN  `Traveler nationality`='Germany' THEN 'Germany'
       WHEN  `Traveler nationality`='Canada' THEN 'Canadian'
       WHEN  `Traveler nationality`='China' THEN 'Chinese'
       WHEN  `Traveler nationality`='Brazil' THEN 'Brazilan'
       WHEN   `Traveler nationality`='Itakian' OR `Traveler nationality`='Italy' THEN 'Italian'
       ELSE `Traveler nationality`
       END,
       Destination= 
       CASE 
           WHEN Destination= 'New York City' THEN 'New York'
           ELSE Destination
           END;
       
       
       

#DATA ANALYIS 

#The Destination most people tend to visit
SELECT Destination,COUNT(Destination) AS Total_visits
FROM travel_new
WHERE Destination IS NOT NULL
GROUP BY Destination
ORDER BY Total_visits DESC;

#AVG Accomadation cost And Transpoatation cost  by Each Destination

SELECT Destination,AVG(`Accommodation cost`)  AS Average_acc_cost,
AVG(`Transportation cost`) AS Average_trans_cost
FROM travel_new
WHERE Destination IS NOT NULL
GROUP BY Destination
ORDER BY Average_acc_cost DESC;

# Age group wise analysis 

SELECT Destination,
CASE 
    WHEN `Traveler age` < 25 THEN 'Young'
    WHEN `Traveler age` >25 AND `Traveler age`<=35 THEN 'Young Adult'
    ELSE 'Adult'
END AS Age_group,
AVG(`Accommodation cost`)  AS Average_acc_cost,
AVG(`Transportation cost`) AS Average_trans_cost,
(AVG(`Accommodation cost`) +AVG(`Transportation cost`)) AS Total_cost,
AVG(`Duration (days)`) AS Average_duration_days
FROM travel_new
WHERE Destination IS NOT NULL 
GROUP BY Age_group,Destination
ORDER BY Average_acc_cost DESC;

#Nationality Vs Accommodation type analysis

SELECT   Destination ,`Traveler nationality`,`Accommodation type`,
AVG(`Accommodation cost`)  AS Average_acc_cost_nationality,
AVG(`Transportation cost`) AS Average_trans_cost_nationality
FROM travel_new
WHERE Destination IS NOT NULL
GROUP BY Destination ,`Traveler nationality`,`Accommodation type`
ORDER BY Destination,`Accommodation type`;


