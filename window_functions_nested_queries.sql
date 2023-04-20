SELECT * FROM orders_prod1;

-- Sales Analysis using window functions 
SELECT
	YEAR(created_at) AS year,
	MONTH(created_at) AS month,
	SUM(price_usd) as total_sales_month,
	ROUND(SUM(price_usd)/SUM(SUM(price_usd)) OVER(PARTITION BY YEAR(created_at)),4) as perc_over_year,
	LAG(SUM(price_usd),1) OVER(ORDER BY YEAR(created_at), MONTH(created_at)) AS prev_month,
	ROUND((SUM(price_usd))/(LAG(SUM(price_usd),1) OVER(ORDER BY YEAR(created_at), MONTH(created_at)))-1,2) AS var_prev_month,
	LAG(SUM(price_usd),12) OVER(ORDER BY YEAR(created_at)) AS prev_year,
	ROUND((SUM(price_usd))/(LAG(SUM(price_usd),12) OVER(ORDER BY YEAR(created_at)))-1,2) AS var_prev_year
FROM orders_prod1
GROUP BY 1, 2
ORDER BY 1, 2;

-- Sales Analysis using temporary table
CREATE TEMPORARY TABLE table0
SELECT
	YEAR(created_at) AS year,
	MONTH(created_at) AS month,
	COUNT(items_purchased) AS totalitems_purchased,
	ROUND(COUNT(items_purchased)/SUM(COUNT(items_purchased)) OVER(PARTITION BY YEAR(created_at)),4) AS ratio_monthoveryear,
	ROW_NUMBER() OVER(ORDER BY COUNT(items_purchased) DESC) AS ranking,
	COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) AS one_item_sales,
	CASE
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) < 500 THEN "low_cat"
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) BETWEEN 500 AND 1000 THEN "high_cat"
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) > 1000 THEN "max_cat"
	END AS one_item_sales_cat,
	COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) AS two_items_sales,
	CASE
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) < 500 THEN "low_cat"
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) BETWEEN 500 AND 1000 THEN "high_cat"
		WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) > 1000 THEN "max_cat"
	END AS two_items_sales_cat
FROM orders_prod1
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT *,
	ROW_NUMBER() OVER() AS counter
FROM table0;

-- Same Sales Analysis using nested queries
SELECT *,
	ROW_NUMBER() OVER() AS counter
FROM
	(
	SELECT
		YEAR(created_at) AS year,
		MONTH(created_at) AS month,
		COUNT(items_purchased) AS totalitems_purchased,
		ROUND(COUNT(items_purchased)/SUM(COUNT(items_purchased)) OVER(PARTITION BY YEAR(created_at)),4) AS ratio_monthoveryear,
		ROW_NUMBER() OVER(ORDER BY COUNT(items_purchased) DESC) AS ranking,
		COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) AS one_item_sales,
		CASE
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) < 500 THEN "low_cat"
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) BETWEEN 500 AND 1000 THEN "high_cat"
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "1" THEN order_id END) > 1000 THEN "max_cat"
		END AS one_item_sales_cat,
		COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) AS two_items_sales,
		CASE
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) < 500 THEN "low_cat"
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) BETWEEN 500 AND 1000 THEN "high_cat"
			WHEN COUNT(DISTINCT CASE WHEN items_purchased = "2" THEN order_id END) > 1000 THEN "max_cat"
		END AS two_items_sales_cat
	FROM orders_prod1
	GROUP BY 1, 2
	ORDER BY 1, 2
	)
	AS table1;