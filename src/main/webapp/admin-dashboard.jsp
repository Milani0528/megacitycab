<%@ page import="com.megacitycab.models.Booking" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
<h1>All Bookings</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Customer Name</th>
        <th>Phone</th>
        <th>Pickup Location</th>
        <th>Drop-off Location</th>
        <th>Booking Date</th>
        <th>Status</th>
    </tr>

    <%
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
        if (bookings != null) {
            for (Booking booking : bookings) {
    %>
    <tr>
        <td><%= booking.getId() %></td>
        <td><%= booking.getCustomerName() %></td>
        <td><%= booking.getPhone() %></td>
        <td><%= booking.getPickupLocation() %></td>
        <td><%= booking.getDropoffLocation() %></td>
        <td><%= booking.getBookingDate() %></td>
        <td><%= booking.getStatus() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="7">No bookings available</td></tr>
    <%
        }
    %>
</table>
</body>
</html>
