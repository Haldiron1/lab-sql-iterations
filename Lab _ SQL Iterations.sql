USE sakila;

#Write a query to find what is the total business done by each store.
SELECT s.store_id, 
       CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
       SUM(p.amount) AS total_sales
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, manager_name;

#Convert the previous query into a stored procedure.
DELIMITER //

CREATE PROCEDURE STOREBIZZ()
BEGIN
    SELECT s.store_id, 
           CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
           SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    GROUP BY s.store_id, manager_name;
END //

DELIMITER ;

CALL STOREBIZZ();


#Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //

CREATE PROCEDURE REVENUESTORE(IN store_id_input INT)
BEGIN
    SELECT CONCAT(st.first_name, ' ', st.last_name) AS manager_name,
           SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = store_id_input
    GROUP BY manager_name;
END //

DELIMITER ;

CALL REVENUESTORE(1); -- Replace 1 with the desired store_id

#Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
#Call the stored procedure and print the results

DELIMITER //

CREATE PROCEDURE REVENUESTORE3(IN store_id_input INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE manager_name VARCHAR(255);
    
    SELECT CONCAT(st.first_name, ' ', st.last_name) INTO manager_name
    FROM staff st
    WHERE st.store_id = store_id_input
    LIMIT 1;
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = store_id_input;
    
    SELECT manager_name, total_sales_value AS total_sales;

END //

DELIMITER ;

CALL REVENUESTORE3(1); -- Replace 1 with the desired store_id


#In the previous query, add another variable flag. 
#If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag.
# Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS REVENUESTORE3;


DELIMITER //

CREATE PROCEDURE REVENUESTORE3(IN store_id_input INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE manager_name VARCHAR(255);
    DECLARE flag VARCHAR(10); -- Declare the flag variable
    
    SELECT CONCAT(st.first_name, ' ', st.last_name) INTO manager_name
    FROM staff st
    WHERE st.store_id = store_id_input
    LIMIT 1;
    
    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = store_id_input;
    
    -- Determine the flag based on total_sales_value
    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
    
    SELECT manager_name, total_sales_value AS total_sales, flag;

END //

DELIMITER ;

CALL REVENUESTORE3(2); -- Replace 1 with the desired store_id









