
use littlelemondb;

INSERT INTO Customers (fullName, contactNumber, email)
VALUES
    ('John Doe', '123-456-7890', 'john@example.com'),
    ('Jane Smith', '987-654-3210', 'jane@example.com');

INSERT INTO Staff (fullName, role, salary)
VALUES
    ('Manager A', 'Manager', 50000),
    ('Waiter B', 'Waiter', 25000);

INSERT INTO Bookings (bookingID, date, tableNumber, customerID, staffID)
VALUES
    (1, '2022-10-10', 5, 1, 1),
    (2, '2022-11-12', 3, 3, 2),
    (3, '2022-10-11', 2, 2, 1),
    (4, '2022-10-13', 2, 1, 2);


INSERT INTO Orders (orderDate, quantity, totalCost, customerID)
VALUES
    ('2023-08-30', 3, 180.50, 1),
    ('2023-08-31', 2, 120.75, 2);

INSERT INTO Order_Delivery_Status (deliveryDate, status, orderID)
VALUES
    ('2023-08-31', 'Delivered', 1),
    ('2023-09-01', 'In Progress', 2);

INSERT INTO Menu (cuisines, starters, courses, drinks, desserts)
VALUES
    ('Italian', 'Garlic Bread', 'Pasta', 'Wine', 'Tiramisu'),
    ('Chinese', 'Spring Rolls', 'Fried Rice', 'Tea', 'Fortune Cookie');
INSERT INTO Orders_has_Menu (orderID, menuID)
VALUES
    (1, 1),
    (1, 2),
    (2, 2);


