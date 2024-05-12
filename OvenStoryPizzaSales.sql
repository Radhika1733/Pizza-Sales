CREATE DATABASE oven_story_pizza;

CREATE TABLE orders (
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id) );

CREATE TABLE orders_details (
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id) );


 -- Retrieve the total number of orders placed.
 
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
 
 
 -- Calculate the total revenue generated from pizza sales.
 
SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pizza_id;
    
    
-- Identify the highest-priced pizza.

SELECT 
    pizzatypes.name, pizzas.price
FROM
    pizzatypes
        JOIN
    pizzas ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC 
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizzatypes.name, SUM(orders_details.quantity) AS quantity
FROM
    pizzatypes
        JOIN
    pizzas ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzatypes.name
ORDER BY quantity DESC
LIMIT 5;
    
    
-- Join the necessary tables to find the total quantity of each pizza category ordered. 

SELECT 
    pizzatypes.category,
    SUM(orders_details.quantity) AS quantity
FROM
    pizzatypes
        JOIN
    pizzas ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzatypes.category
ORDER BY quantity DESC; 


-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);


-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizzatypes
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg_quantity
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
    
-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizzatypes.name,
    SUM(orders_details.quantity * pizzas.price) AS revenue
FROM
    pizzatypes
        JOIN
    pizzas ON pizzas.pizza_type_id = pizzatypes.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzatypes.name
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizzatypes.category,
    ROUND(SUM(orders_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(orders_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    orders_details
                        JOIN
                    pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100,
            0) AS revenue
FROM
    pizzatypes
        JOIN
    pizzas ON pizzas.pizza_type_id = pizzatypes.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzatypes.category
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time.

SELECT 
    order_date,
	SUM(revenue) OVER(ORDER BY order_date) as cum_revenue
FROM
    (SELECT 
         orders.order_date,
         SUM(orders_details.quantity * pizzas.price) AS revenue
	 FROM
         orders_details
               JOIN
		  pizzas ON pizzas.pizza_id = orders_details.pizza_id
               JOIN
          orders ON orders_details.order_id = orders.order_id
     GROUP BY orders.order_date) as sales;


--   Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT 
    name, revenue
FROM
    (SELECT 
		 category, name, revenue,
		 RANK() OVER(PARTITION BY category ORDER BY revenue DESC) as RN
     FROM
         (SELECT 
               pizzatypes.category, pizzatypes.name,
               SUM((orders_details.quantity) * pizzas.price) as revenue
          FROM 
              pizzatypes 
                  JOIN 
		    pizzas ON pizzatypes.pizza_type_id = pizzas.pizza_type_id
                  JOIN 
			orders_details ON orders_details.pizza_id = pizzas.pizza_id
          GROUP BY pizzatypes.category, pizzatypes.name) as A) as B
WHERE RN <= 3;
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    