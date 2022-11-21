# Create CTE for all three table together and call it hotels 
With hotels as (
SELECT * FROM sample.hotel2018
UNION
SELECT * FROM sample.hotel2019
UNION
SELECT * FROM sample.hotel2020 
)
Select * from hotels;

# Create table for all the data
Drop table if exists sample.Hotels_Revenue;
Create table sample.Hotels_Revenue (
Hotel nvarchar(255),
Arrival_date_year numeric,
Arrival_date_month nvarchar(10), 
Stays_in_weekend_nights numeric, 
Stays_in_week_nights numeric, 
Adults numeric, 
Children numeric, 
Daily_rate numeric,
Market_segement nvarchar (255),
Meal nvarchar (10)
);
INSERT INTO sample.Hotels_Revenue (Hotel, Arrival_date_year, Arrival_date_month, Stays_in_weekend_nights, Stays_in_week_nights, Adults, children, Daily_rate, Market_segement, Meal)
Select year2018.hotel, year2018.arrival_date_year, year2018.arrival_date_month, year2018.stays_in_weekend_nights, year2018.stays_in_week_nights, year2018.adults, year2018.children, year2018.adr, year2018.market_segment, year2018.meal
From sample.hotel2018 as year2018
UNION
Select year2019.hotel, year2019.arrival_date_year, year2019.arrival_date_month, year2019.stays_in_weekend_nights, year2019.stays_in_week_nights, year2019.adults, year2019.children, year2019.adr, year2019.market_segment, year2019.meal
From sample.hotel2019 as year2019
UNION
Select year2020.hotel, year2020.arrival_date_year, year2020.arrival_date_month, year2020.stays_in_weekend_nights, year2020.stays_in_week_nights, year2020.adults, year2020.children, year2020.adr, year2020.market_segment, year2020.meal
From sample.hotel2020 as year2020 ;

Select* From sample.hotels_revenue;

 # Find revenue from the hotels in each years.   
Select arrival_date_year, hotel,
round(sum((stays_in_weekend_nights + stays_in_week_nights))*daily_rate,2) as Revenue 
From sample.hotels_revenue
Group by arrival_date_year, hotel;


# Include meal cost and marketing cost by joining market segment into the hotels table
Select * from sample.hotels_revenue
Join sample.hotalmarket as market 
On hotels_revenue.Market_segement = market.market_segment
Join sample.hotalmealcost as meal_cost
On hotels_revenue.meal = meal_cost.meal;


