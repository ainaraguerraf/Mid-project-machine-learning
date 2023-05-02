# This is the alternative way that we found to upload the data. 
# We decided to study in SQL the info about the houses that costs more than 650K, as the project asked to study this special cases. 


CREATE SCHEMA `house_price_regression`; # we tried the first time to uploaded and it didn't work, that's why is named as "2".
USE house_price_regression;

SELECT * 
FROM house_price_data #table that we previously exported in Python
limit 100;


-- dropping the column date
ALTER TABLE house_price_data  DROP COLUMN "date";
SELECT * FROM house_price_data  LIMIT 10;

-- finding number of columns
SELECT COUNT(*) FROM house_price_data ;
# 5205

-- finding the unique values 
SELECT DISTINCT bedrooms FROM house_price_data ; # From 1 to 10
SELECT DISTINCT bathrooms FROM house_price_data ;
#4.5, 2.5, 2.75, 1.75, 1, 2.25, 3.25, 4, 1.5, 3.5, 3, 4.75, 5, 2, 4.25, 3.75, 5.25, 6, 5.5, 6.75, 5.75, 8, 0.75, 1.25, 7.75, 6.25, 6.5
SELECT DISTINCT grade FROM house_price_data ; # 11, 8, 9, 7, 10, 12, 5, 6, 13

-- arrange the data in a decreasing order by houseprice
SELECT *
FROM house_price_data 
ORDER BY price DESC
LIMIT 10; 
# The highest selling price is 7700000, followed by: 7060000, 6890000, 5570000, 5350000, 5300000, 5110000 & 4670000

-- average price of all the properties in the data
SELECT AVG(price) AS average_price FROM house_price_data;
# In this case the average price of the most expensive houses is: 998629.3735

-- average price of the houses grouped by bedrooms
SELECT bedrooms, AVG(price) AS avg_price
FROM house_price_data
GROUP BY bedrooms;
#1: 790620.0000
#2: 847894.1798
#3: 864430.5046
#4: 864430.5046
#5: 974324.4439
#6: 817758.7398
#7: 1378243.0000
#8: 1519750.0000
#9: 1078500.0000
#10: 905000.0000

-- average sqft_living of the houses grouped by bedrooms
SELECT bedrooms, AVG(sqft_living) AS avg_sqft_living
FROM house_price_data
GROUP BY bedrooms;

# 4	3171.3486
# 3	2526.6996
# 5	3659.3464
# 2	1953.2281
# 6	3840.5556
# 7	4891.0000
# 8	4102.5000
# 9	3692.5000
# 1	1538.0000
# 10	3755.0000

-- average price of the houses with a waterfront and without a waterfront?
SELECT waterfront, AVG(price) AS avg_price
FROM house_price_data
GROUP BY waterfront;
#0: 974311.0093
#1: 1926018.4211

-- correlation between grade and condition
SELECT "condition", AVG(grade) AS avg_grade
FROM house_price_data
GROUP BY "condition"
ORDER BY "condition";
#condition: 8.8699

-- Customer query
SELECT bedrooms, bathrooms, floors, waterfront, "condition", grade, price
FROM house_price_data
WHERE bedrooms IN (3, 4)
  AND bathrooms > 3
  AND floors = 1
  AND waterfront = 0
  AND "condition" >= 3
  AND grade >= 5
  AND price < 300000;
# none with the filtered table

-- list of properties whose prices are twice more than the average of all the properties
SELECT id, price
FROM house_price_data
WHERE price > (SELECT AVG(price)*2 FROM house_price_data);

-- Create View of same query
CREATE VIEW double_avg_price_properties AS
SELECT *
FROM house_price_data
WHERE price > (SELECT AVG(price) * 2 FROM house_price_data);

-- the difference in average prices of the properties with three and four bedrooms
SELECT
  bedrooms,
  AVG(price) AS avg_price
FROM
  house_price_data
WHERE
  bedrooms IN (3, 4)
GROUP BY
  bedrooms;
 #  4	998852.5117
# 3	905938.9696

-- different locations
SELECT DISTINCT zipcode
FROM house_price_data;
# 63 different rows returned

-- list of all the properties that were renovated.
SELECT * FROM house_price_data
WHERE yr_renovated > 0;
# 421 rows returned

-- property that is the 11th most expensive property in your database
SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 11; 
#property id: 6065300370
