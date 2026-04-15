-- ONLINE BOOK STORE
-- create books table
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(100),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Customer_name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(100),
	Country VARCHAR(150)
);

CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

-- Data cleaning:
-- Null check
SELECT * FROM books WHERE book_id IS NULL or title IS NULL or author IS NULL or genre IS NULL or published_year IS NULL or price IS NULL or stock IS NULL;
SELECT * FROM customers WHERE customer_id IS NULL or customer_name IS NULL or email IS NULL or phone IS NULL or city IS NULL or country IS NULL;
SELECT * FROM orders WHERE order_id IS NULL or customer_id IS NULL or book_id IS NULL or order_date IS NULL or quantity IS NULL or total_amount IS NULL;

-- Invalid data check
SELECT * FROM books WHERE price <=0;
SELECT * FROM books WHERE stock <=0;	-- 5books with 0 stock
SELECT * FROM orders WHERE quantity <=0 OR total_amount <=0;

-- ANALYSE BOOKS DATA
SELECT * FROM books;
SELECT COUNT(*) FROM books;	--500
SELECT COUNT(DISTINCT(author)) FROM books; --493
SELECT DISTINCT genre FROM books; -- 7GENRES --> Romance, Biography, Mystery, Fantasy, Fiction, Non_fiction, Science fiction
SELECT MIN(published_year) FROM books;	--1900
SELECT MAX(published_year) FROM books;	--2023
SELECT MIN(price) FROM books;	--5.07
SELECT MAX(price) FROM books;	--49.98
SELECT MIN(stock) FROM books;	--0
SELECT MAX(stock) FROM books;	--100
SELECT * FROM books WHERE stock=0; --5books with 0stock

-- ANALYZE CUSTOMER DATA
SELECT * FROM customers;
SELECT COUNT(*) FROM customers;	--500
SELECT COUNT(DISTINCT(email)) FROM customers; --500
SELECT COUNT(DISTINCT(city)) FROM customers; --489
SELECT COUNT(DISTINCT(country)) FROM customers;	--215

-- ANALYZE ORDER DATA
SELECT * FROM Orders;
SELECT COUNT(*) FROM orders;	--500
SELECT COUNT(DISTINCT(customer_id)) FROM orders;	--307
SELECT COUNT(DISTINCT(book_id)) FROM orders; --317
SELECT MIN(order_date) FROM orders; -- 2022-12-09
SELECT MAX(order_date) FROM orders; -- 2024-12-07
SELECT MIN(quantity) FROM orders; -- 1
SELECT MAX(quantity) FROM orders; -- 10
SELECT MIN(total_amount) FROM orders; -- 5.37
SELECT MAX(total_amount) FROM orders; --491.50

-- BASIC QUERIES
SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

--- KPI's
-- Total Orders
SELECT COUNT(*) FROM ORDERS;

-- Total Revenue
SELECT SUM(total_amount) as Total_revenue FROM orders;

-- Avg Order Value:
SELECT AVG(total_amount) as Avg_order_value
FROM orders;

-- Basics
-- Retrieve all books in the "Fiction" genre
SELECT * FROM books
WHERE genre='Fiction';

-- Find books published after the year 1950
SELECT * FROM books
WHERE published_year > 1950;

-- List all customers from the Canada
SELECT * FROM customers
WHERE country='Canada';

-- Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Retrieve the total stock of books available
SELECT SUM(stock) as Total_stock FROM books;
			
-- List all genres available in the Books table
SELECT DISTINCT genre FROM books;
			
-- Retrieve all orders where the total amount exceeds $20
SELECT * FROM orders
WHERE total_amount>20;

-- 
-- Find the details of the most expensive book
SELECT * FROM books
WHERE PRICE = (SELECT MAX(PRICE) FROM books);

-- Show all customers who ordered more than 1 quantity of a book in each order
SELECT DISTINCT c.customer_id, c.customer_name
FROM orders o JOIN customers c
ON c.customer_id = o.customer_id
WHERE o.quantity>1;

-- Find the book with the lowest stock
SELECT * FROM books
WHERE stock = (SELECT MIN(stock) FROM books); 


-- ADVANCE QUERIES
-- Retrieve the total number of books sold for each genre
SELECT genre, sum(quantity) AS total_books_sold
FROM orders o JOIN books b
ON o.book_id = b.book_id
GROUP BY genre;

-- Find the average price of books in the "Fantasy" genre
SELECT AVG(price) AS avgprice 
FROM books
WHERE genre='Fantasy';

-- List customers who have placed at least 2 orders
SELECT c.customer_id, c.customer_name, count(*) as ordercount
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,  c.customer_name
HAVING count(*) >1;

-- Find the most frequently ordered book
WITH freqOrderedBook as(
	SELECT b.book_id, b.title, count(*) as ordercount, DENSE_RANK() OVER(ORDER BY count(*) desc) as rnk
	FROM orders o JOIN books b
	ON o.book_id = b.book_id
	GROUP BY b.book_id, b.title
)
SELECT * FROM freqOrderedBook
where rnk=1;

-- Show the top 3 most expensive books of 'Fantasy' Genre
WITH cte_books AS (
	SELECT *, rank() over(partition by genre order by price desc) as rnk  
	FROM books
)
SELECT * 
FROM cte_books
WHERE genre = 'Fantasy' AND rnk <=3;

-- Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM books b JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.author;

-- List the cities where customers who spent over $30 are located
SELECT DISTINCT city
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- Find the customer who spent the most on orders
SELECT c.customer_id, c.customer_name, sum(o.total_amount) AS totalspend
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY totalspend DESC
LIMIT 1;

-- Calculate the stock remaining after fulfilling all orders
WITH cte_bookdetails as (
	SELECT b.book_id, b.title, COALESCE(b.stock,0) as totalstock, SUM(COALESCE(o.quantity,0)) as qtyordered
	FROM orders o RIGHT JOIN books b
	ON o.book_id = b.book_id
	GROUP BY b.book_id, b.title
)
SELECT book_id, title, totalstock, qtyordered,  (totalstock - qtyordered) as QtyLeft
FROM cte_bookdetails
ORDER BY QtyLeft DESC;


-- BUSINESS-LEVEL INSIGHTS
-- Sales Trend Analysis
SELECT TO_CHAR(DATE_TRUNC('MONTH', order_date), 'YYYY-MM') as year_month , SUM(total_amount) as TotalRevenue
FROM orders
GROUP BY DATE_TRUNC('MONTH', order_date)
ORDER BY year_month;

-- Top 10 Customers (Revenue Contribution)
SELECT c.customer_id, c.customer_name, sum(total_amount) as TotalRevenue
FROM orders o JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY TotalRevenue desc
LIMIT 10;

-- Inventory Risk Analysis - identify low stock risk
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) as TotalOrderedQty, (b.stock - COALESCE(SUM(o.quantity), 0)) as TotalAvailableQty
FROM books b LEFT JOIN orders o  
ON o.book_id = b.book_id
GROUP BY b.book_id, b.title, b.stock
HAVING (b.stock - COALESCE(SUM(o.quantity), 0)) BETWEEN 0 AND 5
ORDER BY TotalAvailableQty;

-- Inventory Risk Analysis - identify overpromising items
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) as TotalOrderedQty, (b.stock - COALESCE(SUM(o.quantity), 0)) as TotalAvailableQty
FROM books b LEFT JOIN orders o  
ON o.book_id = b.book_id
GROUP BY b.book_id, b.title, b.stock
HAVING (b.stock - COALESCE(SUM(o.quantity), 0)) < 0
ORDER BY b.book_id;

-- Best Selling Genre (Revenue Based)
WITH cte_bestSellingGenre AS (
	SELECT b.genre, SUM(o.total_amount) as TotalRevenue, DENSE_RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS rnk
	FROM orders o JOIN books b
	ON o.book_id = b.book_id
	GROUP BY b.genre
)
SELECT * FROM cte_bestSellingGenre WHERE rnk=1;

-- customer segmentation
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) as TotalRevenue,
	CASE
		WHEN SUM(o.total_amount) > 300 THEN 'High Value Customers'
		WHEN SUM(o.total_amount) BETWEEN 150 AND 300 THEN 'Mid Value Customers'
		ELSE 'Low Value Customers'
	END AS CustomerSegment
FROM customers c LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
