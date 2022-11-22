SELECT * FROM sample.car_sales;

# Finding sale from each manufacturer
Select Manufacturer, Model, Sales_in_thousands*1000 as Total_Sale_in_unit
From sample.car_sales
Group by Manufacturer, Model;

# Convert data
Select Price_in_thousands*1000 as Price 
From sample.car_sales; 

# Find the most powerful engine
Select Manufacturer, Model, Max(Horsepower) as engine_power
From sample.car_sales;

# Rank by Horsepower
Select Manufacturer, Model, Horsepower
From sample.car_sales
Order by Horsepower DESC;

# Rank the car based on the sale price 
Select Manufacturer, Model, Price_in_thousands, rank() 
Over (order by Price_in_thousands ) as 'Rank' 
From sample.car_sales
Where Price_in_thousands is not null;

# Rank the car based on the horsepower
Select Manufacturer, Model, horsepower, rank()
Over (order by horsepower desc) as 'Rank'
From sample.car_sales
Group by Manufacturer;

# Find which car model has the most horsepower and rank among the afforable price
Select Manufacturer, Model, horsepower, Price_in_thousands, rank()
Over (order by horsepower desc) as 'Rank_Power' ,
rank() Over(order by Price_in_thousands desc) as 'Rank_price'
From sample.car_sales
Order by 'Rank_Power' and 'Rank_price';






