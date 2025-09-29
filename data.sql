-- Customers (5 rows)
INSERT INTO customers (customer_id, name, region) VALUES (1001, 'John Doe', 'Kigali');
INSERT INTO customers (customer_id, name, region) VALUES (1002, 'Jane Smith', 'Huye');
INSERT INTO customers (customer_id, name, region) VALUES (1003, 'Eric Niyonzima', 'Musanze');
INSERT INTO customers (customer_id, name, region) VALUES (1004, 'Alice Uwimana', 'Rubavu');
INSERT INTO customers (customer_id, name, region) VALUES (1005, 'David Habimana', 'Kigali');

--Products (5 rows)
INSERT INTO products (product_id, name, category) VALUES (2001, 'Coffee Beans', 'Beverages');
INSERT INTO products (product_id, name, category) VALUES (2002, 'Green Tea', 'Beverages');
INSERT INTO products (product_id, name, category) VALUES (2003, 'Milk Powder', 'Dairy');
INSERT INTO products (product_id, name, category) VALUES (2004, 'Sugar', 'Grocery');
INSERT INTO products (product_id, name, category) VALUES (2005, 'Bread', 'Bakery');

--Transactions (5 rows)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount)
VALUES (3001, 1001, 2001, DATE '2024-01-15', 25000);

INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount)
VALUES (3002, 1002, 2002, DATE '2024-02-05', 12000);

INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount)
VALUES (3003, 1003, 2003, DATE '2024-03-10', 18000);

INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount)
VALUES (3004, 1004, 2004, DATE '2024-03-20', 8000);

INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount)
VALUES (3005, 1005, 2005, DATE '2024-04-02', 15000);