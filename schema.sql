-- Create Customers Table:
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    region        VARCHAR(50) NOT NULL
);

-- Create Products Table:
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    category      VARCHAR(50) NOT NULL
);

-- Create Transactions Table:
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id    INT NOT NULL,
    product_id     INT NOT NULL,
    sale_date      DATE NOT NULL,
    amount         NUMERIC(12,2) NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);
