use littlelemondb;

CREATE VIEW  OrdersView AS SELECT orderID, totalCost, quantity FROM Orders where quantity>2;


CREATE VIEW  MoreThan150OrdersView AS select C.CustomerID,C.fullName, O.orderID, O.totalCost, 
 M.cuisines as "MenuName",
 M.starters as "CourseName" 
 FROM
    Customers C
JOIN
    Orders O ON C.CustomerID = O.CustomerID
JOIN
    Orders_has_Menu OM ON O.OrderID = OM.orderID
JOIN
    Menu M ON OM.menuId = M.id
WHERE
    O.TotalCost > 150;
    
CREATE VIEW  Morethan2OrdersView AS SELECT
   M.cuisines as "MenuName"
FROM
    Menu M
WHERE
    M.id =ANY (
        SELECT OM.menuID
        FROM Orders_has_Menu OM
        JOIN Orders O ON OM.orderID = O.orderID
        WHERE O.Quantity > 2
    );
# STORE PROCEDURES
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(quantity) 
    FROM Orders;
END //

DELIMITER ;
call GetMaxQuantity();

PREPARE GetOrderDetail from 'SELECT orderID,quantity,totalCost as "cost" FROM Orders where OrderID =?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;


DELIMITER //
CREATE PROCEDURE CancelOrder(IN orderIDParam INT)
BEGIN
    DECLARE conformation VARCHAR(100);
    
    DELETE FROM Orders
    WHERE orderID = orderIDParam;
    
    SET conformation = CONCAT('order ', orderIDParam, ' is cancelled');
    SELECT conformation AS confirmation;
END //

DELIMITER ;
call CancelOrder(1);

DELIMITER //
CREATE PROCEDURE CheckBooking(IN bookingDateParam DATE, IN tableNumberParam INT)
BEGIN
    DECLARE bookingStatus VARCHAR(100);
    DECLARE existingBooking INT;    
    SELECT COUNT(*) INTO existingBooking
    FROM Bookings
    WHERE date = bookingDateParam AND tableNumber = tableNumberParam;
    
    IF existingBooking > 0 THEN
        SET bookingStatus = CONCAT('Table ', tableNumberParam, ' is already booked');
    ELSE
        SET bookingStatus = CONCAT('Table ', tableNumberParam, ' is available');
    END IF;    
    SELECT bookingStatus AS `Booking status`;
END //
DELIMITER ;
CALL CheckBooking('2022-11-12', 3);

DELIMITER //
CREATE PROCEDURE AddValidBooking(IN bookingDateParam DATE, IN tableNumberParam INT)
BEGIN
    DECLARE bookingStatus VARCHAR(100);
    DECLARE existingBooking INT;
    START TRANSACTION;
    -- Check if the table is already booked on the given date
    SELECT COUNT(*) INTO existingBooking
    FROM Bookings
    WHERE date = bookingDateParam AND tableNumber = tableNumberParam;
    
    IF existingBooking > 0 THEN
        SET bookingStatus = CONCAT('Table ', tableNumberParam, ' is already booked - booking cancelled');
        ROLLBACK;
    ELSE
        -- Insert the new booking record
        INSERT INTO Bookings (date, tableNumber, customerID, staffID)
        VALUES (bookingDateParam, tableNumberParam, 1, 1);  -- Assuming default customer and staff IDs
        SET bookingStatus = CONCAT('Table ', tableNumberParam, ' is available - booking confirmed');
        COMMIT;
    END IF;
    SELECT bookingStatus AS `Booking status`;
END //
DELIMITER ;
CALL AddValidBooking('2022-10-10', 5);


