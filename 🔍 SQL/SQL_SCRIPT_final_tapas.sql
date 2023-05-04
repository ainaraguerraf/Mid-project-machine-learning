# This is the alternative way that we found to upload the data. 
# We decided to study in SQL the info about the houses that costs more than 650K, as the project asked to study these special cases. 

# 1. Create a database called house_price_regression.
CREATE SCHEMA `house_price_regression`;

#2. Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.
USE house_price_regression;


# 3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
# 4. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
SELECT * 
FROM house_price_data #table that we previously exported in Python
limit 100;


# 5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE house_price_data  DROP COLUMN "date";
SELECT * FROM house_price_data  LIMIT 10;

# 6. Use sql query to find how many rows of data you have.
SELECT COUNT(*) FROM house_price_data ;
# 5205

# 7. Now we will try to find the unique values in some of the categorical columns:
SELECT DISTINCT bedrooms FROM house_price_data ; # From 1 to 10
SELECT DISTINCT bathrooms FROM house_price_data ;
#4.5, 2.5, 2.75, 1.75, 1, 2.25, 3.25, 4, 1.5, 3.5, 3, 4.75, 5, 2, 4.25, 3.75, 5.25, 6, 5.5, 6.75, 5.75, 8, 0.75, 1.25, 7.75, 6.25, 6.5
SELECT DISTINCT grade FROM house_price_data ; # 11, 8, 9, 7, 10, 12, 5, 6, 13

# 8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
SELECT *
FROM house_price_data 
ORDER BY price DESC
LIMIT 10; 
# The highest selling price is 7700000, followed by: 7060000, 6890000, 5570000, 5350000, 5300000, 5110000 & 4670000

# 9. What is the average price of all the properties in your data?
SELECT AVG(price) AS average_price FROM house_price_data;
# In this case the average price of the most expensive houses is: 998629.3735

# 10.1 What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
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

# 10.2 What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
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

# 10.3 What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
SELECT waterfront, AVG(price) AS avg_price
FROM house_price_data
GROUP BY waterfront;
#0: 974311.0093
#1: 1926018.4211

# 10.4 Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
SELECT "condition", AVG(grade) AS avg_grade
FROM house_price_data
GROUP BY "condition"
ORDER BY "condition";
#condition: 8.8699

# One of the customers is only interested in the following houses:
SELECT bedrooms, bathrooms, floors, waterfront, "condition", grade, price
FROM house_price_data
WHERE bedrooms IN (3, 4) # Number of bedrooms either 3 or 4
  AND bathrooms > 3 # Bathrooms more than 3
  AND floors = 1 # One Floor
  AND waterfront = 0 #No waterfront
  AND "condition" >= 3 #Condition should be 3 at least
  AND grade >= 5 #Grade should be 5 at least
  AND price < 300000; #Price less than 300000
# none with the filtered table because it is already filtered to have a price above 650K, which contradicts the last part of the statement.

# 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
SELECT id, price
FROM house_price_data
WHERE price > (SELECT AVG(price)*2 FROM house_price_data);

# 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
CREATE VIEW double_avg_price_properties AS
SELECT *
FROM house_price_data
WHERE price > (SELECT AVG(price) * 2 FROM house_price_data);

# 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?
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

# 15. What are the different locations where properties are available in your database? (distinct zip codes)
SELECT DISTINCT zipcode
FROM house_price_data;
# 63 different rows returned

# 16. Show the list of all the properties that were renovated.
SELECT * FROM house_price_data
WHERE yr_renovated > 0;
# 421 rows returned

# 17. Provide the details of the property that is the 11th most expensive property in your database.
SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 11; 
#property id: 6065300370
