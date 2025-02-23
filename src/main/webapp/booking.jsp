<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cab Booking - Mega City Cab</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .container { width: 50%; margin: auto; padding: 20px; border: 1px solid #ddd; }
        input, select { width: 90%; padding: 8px; margin: 5px 0; }
        button { padding: 10px 15px; background: green; color: white; border: none; cursor: pointer; }
        button:hover { background: darkgreen; }
    </style>
</head>
<body>
<div class="container">
    <h2>Book a Cab</h2>
    <form action="${pageContext.request.contextPath}/BookingServlet" method="post">
    <input type="text" name="customer_name" placeholder="Your Name" required><br>
        <input type="text" name="phone" placeholder="Phone Number" required><br>
        <input type="text" name="pickup_location" placeholder="Pickup Location" required><br>
        <input type="text" name="dropoff_location" placeholder="Drop-off Location" required><br>
        <label>Booking Date & Time:</label>
        <input type="datetime-local" name="booking_date" required><br>
        <button type="submit">Book Now</button>
    </form>
</div>
</body>
</html>
