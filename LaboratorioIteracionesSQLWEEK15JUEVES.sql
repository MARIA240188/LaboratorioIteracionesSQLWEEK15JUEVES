USE SAKILA;

-- Escriba una consulta para encontrar cuál es el negocio total realizado por cada tienda
SELECT 

    s.store_id,

    CONCAT(a.address, ', ', c.city) AS store_location,

    SUM(p.amount) AS total_business

FROM 

    payment p

JOIN 

    rental r ON p.rental_id = r.rental_id

JOIN 

    inventory i ON r.inventory_id = i.inventory_id

JOIN 

    store s ON i.store_id = s.store_id

JOIN 

    address a ON s.address_id = a.address_id

JOIN 

    city c ON a.city_id = c.city_id

GROUP BY 

    s.store_id, store_location

ORDER BY 

    total_business DESC;
    
-- Convierta la consulta anterior en un procedimiento almacenado
DELIMITER //

CREATE PROCEDURE negocioTotalPorTienda()

BEGIN

    SELECT 

        s.store_id,

        CONCAT(a.address, ', ', c.city) AS store_location,

        SUM(p.amount) AS total_business

    FROM 

        payment p

    JOIN 

        rental r ON p.rental_id = r.rental_id

    JOIN 

        inventory i ON r.inventory_id = i.inventory_id

    JOIN 

        store s ON i.store_id = s.store_id

    JOIN 

        address a ON s.address_id = a.address_id

    JOIN 

        city c ON a.city_id = c.city_id

    GROUP BY 

        s.store_id, store_location

    ORDER BY 

        total_business DESC;

END //

 

DELIMITER ;

-- Convierta la consulta anterior en un procedimiento almacenado que tome la entrada store_idy muestre las ventas totales de esa tienda
DELIMITER //

 

CREATE PROCEDURE negocioTotalxTienda(IN input_store_id INT)

BEGIN

    SELECT 

        s.store_id,

        CONCAT(a.address, ', ', c.city) AS store_location,

        SUM(p.amount) AS total_business

    FROM 

        payment p

    JOIN 

        rental r ON p.rental_id = r.rental_id

    JOIN 

        inventory i ON r.inventory_id = i.inventory_id

    JOIN 

        store s ON i.store_id = s.store_id

    JOIN 

        address a ON s.address_id = a.address_id

    JOIN 

        city c ON a.city_id = c.city_id

    WHERE 

        s.store_id = input_store_id

    GROUP BY 

        s.store_id, store_location;

END //

 

DELIMITER ;

CALL negocioTotalxTienda(2);

-- Actualiza la consulta anterior. Declare una variable total_sales_valuede tipo float, que almacenará el resultado devuelto (del monto total de ventas de la tienda). 
-- Llame al procedimiento almacenado e imprima los resultados.
DELIMITER //

 

CREATE PROCEDURE negocioTotalxTiendaFloat(IN input_store_id INT, OUT total_sales_value FLOAT)

BEGIN

    DECLARE total_sales FLOAT;

 

    SELECT 

        SUM(p.amount) 

    INTO 

        total_sales

    FROM 

        payment p

    JOIN 

        rental r ON p.rental_id = r.rental_id

    JOIN 

        inventory i ON r.inventory_id = i.inventory_id

    JOIN 

        store s ON i.store_id = s.store_id

    WHERE 

        s.store_id = input_store_id;

 

    SET total_sales_value = total_sales;

END //

 

DELIMITER ;

-- Declarar la variable para almacenar el resultado

SET @store_id = 1;

SET @total_sales_value = 0.0;

 

-- Llamar al procedimiento almacenado

CALL negocioTotalPorTienda3(@store_id, @total_sales_value);

 

-- Seleccionar la variable para imprimir el resultado

SELECT @total_sales_value AS total_sales;

-- En la consulta anterior, agregue otra variable flag. Si el valor total de ventas de la tienda es superior a 30 000, etiquételo como green_flag; de lo contrario, etiquételo como red_flag. Actualice el procedimiento almacenado que toma una entrada como store_idy devuelve el valor de ventas total para esa tienda y valor de marca.
-- Declarar las variables para almacenar el resultado
DELIMITER //

 

CREATE PROCEDURE negocioTotalPorTienda3(

    IN input_store_id INT, 

    OUT total_sales_value FLOAT, 

    OUT flag VARCHAR(10)

)

BEGIN

    DECLARE total_sales FLOAT;

 

    SELECT 

        SUM(p.amount) 

    INTO 

        total_sales

    FROM 

        payment p

    JOIN 

        rental r ON p.rental_id = r.rental_id

    JOIN 

        inventory i ON r.inventory_id = i.inventory_id

    JOIN 

        store s ON i.store_id = s.store_id

    WHERE 

        s.store_id = input_store_id;

 

    SET total_sales_value = total_sales;

 

    IF total_sales > 30000 THEN

        SET flag = 'green_flag';

    ELSE

        SET flag = 'red_flag';

    END IF;

END //

 

DELIMITER ;
SET @store_id = 2;

SET @total_sales_value = 0.0;

SET @flag = '';

 

-- Llamar al procedimiento almacenado

CALL negocioTotalPorTienda3(@store_id, @total_sales_value, @flag);

 

-- Seleccionar las variables para imprimir los resultados

SELECT @total_sales_value AS total_sales, @flag AS flag;
