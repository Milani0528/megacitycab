<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sessionUser = request.getSession();
    String fullName = (String) sessionUser.getAttribute("full_name");
    String phone = (String) sessionUser.getAttribute("phone");
    int customerId = (int) sessionUser.getAttribute("userId");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book a Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 50px; max-width: 500px; }
    </style>
</head>
<body>
<div class="container bg-white p-4 rounded shadow">
    <h2 class="text-center mb-4">Book a Cab</h2>
    <form action="BookingServlet" method="post">
        <div class="mb-3">
            <label>Your Name:</label>
            <input type="text" class="form-control" value="<%= fullName %>" readonly>
        </div>
        <div class="mb-3">
            <label>Phone Number:</label>
            <input type="text" class="form-control" value="<%= phone %>" readonly>
        </div>
        <div class="mb-3">
            <label>Pickup Location:</label>
            <input type="text" name="pickupLocation" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Drop-off Location:</label>
            <input type="text" name="dropoffLocation" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Booking Date & Time:</label>
            <input type="datetime-local" name="bookingDate" class="form-control" required>
        </div>
        <input type="hidden" name="customerId" value="<%= customerId %>">
        <button type="submit" class="btn btn-success w-100">Book Now</button>
    </form>
</div>
</body>
</html>
