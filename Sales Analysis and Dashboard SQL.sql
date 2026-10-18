CREATE OR REPLACE VIEW v_Product_Enriched AS
SELECT
    p.product_id AS "Product ID",
    p.product_name AS "Product Name",
    c.category_name AS "Category Name",
    s.company_name AS "Supplier",
    p.unit_price AS "Unit Price"
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id;

CREATE OR REPLACE VIEW v_Order_Sales AS
SELECT
    o.order_id AS "Order ID",
    o.customer_id AS "Customer ID",
    o.employee_id AS "Employee ID",
    o.order_date AS "Order Date",
    od.product_id AS "Product ID",
    od.unit_price AS "Unit Price",
    od.quantity AS "Quantity",
    od.discount AS "Discount",
    ROUND(
        (od.unit_price * od.quantity * (1 - od.discount))::numeric,
        2
    ) AS "TotalLineAmount"
FROM orders o
INNER JOIN order_details od
    ON o.order_id = od.order_id;


--- View including active Customers who have sales
/*

CREATE OR REPLACE VIEW v_Customer_Geo AS
SELECT DISTINCT
    c.customer_id AS "Customer ID",
    c.company_name AS "Company Name",
    c.city AS "City",
    c.country AS "Country"
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.city IS NOT NULL
  AND c.country IS NOT NULL;
  
*/

--- View that includes inactive Customers with no sales:

CREATE OR REPLACE VIEW v_Customer_Geo AS
SELECT
    c.customer_id AS "Customer ID",
    c.company_name AS "Company Name",
    c.city AS "City",
    c.country AS "Country",
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM orders o
            WHERE o.customer_id = c.customer_id
        )
        THEN 'Active'
        ELSE 'Potential'
    END AS "Customer Status"
FROM customers c;


/* To check the view
 
SELECT * FROM v_Product_Enriched;

SELECT * FROM v_Order_Sales;

SELECT * FROM v_Customer_Geo;
 
 */
