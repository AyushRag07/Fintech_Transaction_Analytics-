ALTER TABLE customers
MODIFY customer_id VARCHAR(10);

ALTER TABLE accounts
MODIFY account_id VARCHAR(10),
MODIFY customer_id VARCHAR(10);

ALTER TABLE transactions
MODIFY account_id VARCHAR(10);

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE accounts
ADD PRIMARY KEY (account_id);

ALTER TABLE transactions
ADD PRIMARY KEY (transaction_id);

ALTER TABLE accounts
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_account
FOREIGN KEY (account_id)
REFERENCES accounts(account_id);

ALTER TABLE customers
MODIFY signup_date DATE;

ALTER TABLE transactions
MODIFY transaction_date DATETIME;

UPDATE customers
SET signup_date = DATE_SUB(signup_date, INTERVAL 3 YEAR);

SELECT
    transaction_category,
    COUNT(*)
FROM transactions
GROUP BY transaction_category;