# US Stores sales from 2010 to 2011

Select * 
From sample.sales;

# Find Percentage of each state show in the data
Select state, (COUNT(*) / (SELECT COUNT(state) FROM sample.sales)) * 100 AS Percentage
From sample.sales
Group by state;

# Find the percentage of each product type in each state. 
Select state, 
		Product_type, 
		(Count(*)/(Select count(Product_type) From sample.sales)* 100) AS Percentage_of_Product
From sample.sales
Group by state, Product_type;

# Find the profit in each state and product_type
Select Pro.State, Pro.Product_type, Pro.S, Pro.fit
From (Select state, Product_type, max(Profit) as fit, max(Sales) as S
		From sample.sales
        Group by state, Product_type) as Pro






