SELECT transaction_id,
       transaction_date,
       transaction_time,
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,

---Adding columns to enrich our data for better insights
   Dayname(transaction_date) AS Day_name,
   Monthname(transaction_date) AS Month_name,
   Dayofmonth(transaction_date) AS Day_of_month,
CASE
     WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
     ELSE 'Weekday'
     END AS Day_Classification,
CASE 
     WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '05:00:00' AND '09:59:59' THEN '01.Morning Rush'
     WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '10:00:00' AND '11:59:59' THEN '02.Mid Morning'
     WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '12:00:00' AND '16:59:59' THEN '03.Afternoon'
     WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '17:00:00' AND '18:00:00' THEN '04.Evening'
     ELSE '05.Night'
     END AS Time_classification,
CASE 
    WHEN(transaction_qty*unit_price) <=50 THEN '01.Low spend'
    WHEN(transaction_qty*unit_price) BETWEEN 51 AND 200 THEN '02.Medium spend'
    WHEN(transaction_qty*unit_price) BETWEEN 201 AND 300 THEN '03.Good spend'
    ELSE '04.High spend'
    END AS Spend_buckets,
---Add revenue column
   transaction_qty*unit_price AS Revenue
FROM workspace.default.bright_coffee_shop_sales;
