-- creating database

CREATE DATABASE house_price_regression;
USE house_price_regression;

-- creating new table with columns same as original csv
CREATE TABLE house_price_data (
  id INT PRIMARY KEY,
  date Date,
  bedrooms INT,
  bathrooms INT,
  sqft_living INT,
  sqft_lot INT,
  Floors INT, 
  waterfront INT,
  view int,
  Conditions int,
  grade int, 
  sqft_above int,            
  sqft_basement int,           
  yr_built int,            
  yr_renovated  int,        
  zipcode int,                
  lat int, 
  longitude int,
  sqft_living15 int,
  sqft_lot15  int,         
  price  int  
);

-- setting local_infile equal to 1 to load data
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- loading csv into table
LOAD DATA LOCAL INFILE 'regression_data.csv'
INTO TABLE house_price_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- checking it was uploaded correctly
SELECT * from house_price_data;


-- Create new filtered table
CREATE TABLE filtered_house_price_data LIKE house_price_data;
INSERT INTO filtered_house_price_data SELECT * FROM house_price_data WHERE price > 650000;


-- dropping the column date
ALTER TABLE filtered_house_price_data  DROP COLUMN date;
SELECT * FROM filtered_house_price_data  LIMIT 10;

-- finding number of columns
SELECT COUNT(*) FROM filtered_house_price_data ;

-- finding the unique values 
SELECT DISTINCT bedrooms FROM filtered_house_price_data ;
SELECT DISTINCT bathrooms FROM filtered_house_price_data ;
SELECT DISTINCT grade FROM filtered_house_price_data ;

-- arrange the data in a decreasing order by houseprice
SELECT id
FROM filtered_house_price_data 
ORDER BY price DESC
LIMIT 10;

-- average price of all the properties in the data
SELECT AVG(price) AS average_price FROM filtered_house_price_data;

-- average price of the houses grouped by bedrooms
SELECT bedrooms, AVG(price) AS avg_price
FROM filtered_house_price_data
GROUP BY bedrooms;

-- average sqft_living of the houses grouped by bedrooms
SELECT bedrooms, AVG(sqft_living) AS avg_sqft_living
FROM filtered_house_price_data
GROUP BY bedrooms;

-- average price of the houses with a waterfront and without a waterfront?
SELECT waterfront, AVG(price) AS avg_price
FROM filtered_house_price_data
GROUP BY waterfront;

-- correlation between grade and condition
SELECT Conditions, AVG(grade) AS avg_grade
FROM filtered_house_price_data
GROUP BY Conditions
ORDER BY Conditions;

-- Customer query
SELECT id, bedrooms, bathrooms, floors, waterfront, Conditions, grade, price
FROM filtered_house_price_data
WHERE bedrooms IN (3, 4)
  AND bathrooms > 3
  AND floors = 1
  AND waterfront = 0
  AND Conditions >= 3
  AND grade >= 5
  AND price < 300000;

-- list of properties whose prices are twice more than the average of all the properties
SELECT id, price
FROM filtered_house_price_data
WHERE price > (SELECT AVG(price)*2 FROM filtered_house_price_data);

-- Create View of same query
CREATE VIEW double_avg_price_properties AS
SELECT *
FROM filtered_house_price_data
WHERE price > (SELECT AVG(price) * 2 FROM filtered_house_price_data);

-- the difference in average prices of the properties with three and four bedrooms
SELECT
  bedrooms,
  AVG(price) AS avg_price
FROM
  filtered_house_price_data
WHERE
  bedrooms IN (3, 4)
GROUP BY
  bedrooms;
  
-- different locations
SELECT DISTINCT zipcode
FROM filtered_house_price_data;

-- list of all the properties that were renovated.
SELECT * FROM filtered_house_price_data
WHERE yr_renovated > 0;

-- property that is the 11th most expensive property in your database
SELECT * FROM filtered_house_price_data
ORDER BY price DESC
LIMIT 11 








