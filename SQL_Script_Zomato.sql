
# Inner JOin to join ciuntry table and currency table to the main table

select m.CountryCode, m.Currency, c.Countryname, cur.USDRate from main m
left join country c on m.CountryCode = c.CountryID
left join currency cur on m.Currency = cur.Currency;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Calendar Table

alter table main
add column month_fullname varchar(20),
add column Quarter varchar(2),
add column YearMonth varchar(20),
add column WeekDay_No int,
add column weekday_name varchar(20),
add column financial_month int,
add column financial_quarter varchar(4);

update main
set
month_fullname = case month_opening
when 1 then 'January'
when 2 then 'February'
when 3 then 'March'
when 4 then 'April'
when 5 then 'May'
when 6 then 'June'
when 7 then 'July'
when 8 then 'August'
when 9 then 'September'
when 10 then 'October'
when 11 then 'November'
when 12 then 'December'
end,

Quarter = CONCAT('Q', 
CASE 
WHEN month_opening BETWEEN 1 AND 3 THEN 1
WHEN month_opening BETWEEN 4 AND 6 THEN 2
WHEN month_opening BETWEEN 7 AND 9 THEN 3
WHEN month_opening BETWEEN 10 AND 12 THEN 4
END),

YearMonth = CONCAT(year_opening, '-', month_fullname),

WeekDay_No = DAYOFWEEK(STR_TO_DATE(CONCAT(year_opening, '-', month_opening, '-', day_opening), '%Y-%m-%d')),

weekday_name = DAYNAME(STR_TO_DATE(CONCAT(year_opening, '-', month_opening, '-', day_opening), '%Y-%m-%d')),

Financial_Month = CASE
WHEN month_opening BETWEEN 4 AND 12 THEN month_opening - 3
ELSE month_opening + 9
END,

Financial_Quarter = CONCAT('FQ-', CASE
WHEN month_opening BETWEEN 4 AND 6 THEN 1
WHEN month_opening BETWEEN 7 AND 9 THEN 2
WHEN month_opening BETWEEN 10 AND 12 THEN 3
ELSE 4
END);
 
 select * from main;
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 # Average cost of two in USD
 
ALTER TABLE main
ADD COLUMN Average_cost_for_two_in_USD DECIMAL(10, 2);

UPDATE main m
JOIN currency cur on m.currency = cur.currency
SET m.Average_cost_for_two_in_USD = m.Average_cost_for_two * cur.USDrate;

select * from main;

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Number of Restaurants based on City and Country

select c.countryname, count(restaurantid) as No_of_Restaurants from main m inner join country c on m.countrycode = c.countryid 
group by c.countryname;

select city, count(restaurantid) as No_of_Restaurants from main
group by city;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Number of Restaurants opened based on Year , Quarter and Month

select m.year_opening, count(restaurantid) as No_of_Restaurants from main m
group by Year_opening
order by Year_opening;

select m.quarter, count(restaurantid) as No_of_Restaurants from main m
group by Quarter
order by Quarter;

select m.month_fullname, count(restaurantid) as No_of_Restaurants from main m
group by month_fullname
order by month_fullname;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Count of Restaurants based on Average Ratings

select 
case
 when rating <=1 then "0-1" 
 when rating <=2 then "1-2" 
 when rating <=3 then "2-3" 
 when Rating<=4 then "3-4"
 when Rating<=5 then "4-5" 
 end 
 Rating_Range,count(restaurantid) as Restro_Count from main
group by rating_range  order by rating_range;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# buckets based on Average Price of reasonable size and no of restaurants that fall in each bucket

SELECT
    COST_RANGE,
    count(*) as Restro_Count
FROM(
	SELECT
      CASE
          WHEN AVERAGE_COST_FOR_TWO BETWEEN 0 AND 300 THEN '0-300'
          WHEN AVERAGE_COST_FOR_TWO BETWEEN 301 AND 600 THEN '301-600'
          WHEN AVERAGE_COST_FOR_TWO BETWEEN 601 AND 10000 THEN '601-10000'
          WHEN AVERAGE_COST_FOR_TWO BETWEEN 10001 AND 43000 THEN '10001-43000'
          ELSE 'OTHER'
	  END AS COST_RANGE
   FROM
      main
) AS SUBQUERY
GROUP BY
     COST_RANGE;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Percentage of Resturants based on "Has_Table_booking" 

SELECT 
    HAS_TABLE_BOOKING AS TABLE_BOOKING_STATUS,
    COUNT(*) AS RESTAURANT_COUNT,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM MAIN), 2) AS PERCENTAGE
FROM 
    MAIN
GROUP BY 
    HAS_TABLE_BOOKING;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Percentage of Resturants based on "Has_Online_delivery"

SELECT 
    HAS_ONLINE_DELIVERY AS TABLE_BOOKING_STATUS,
    COUNT(*) AS RESTAURANT_COUNT,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM MAIN), 2) AS PERCENTAGE
FROM 
    MAIN
GROUP BY 
    HAS_ONLINE_DELIVERY;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 