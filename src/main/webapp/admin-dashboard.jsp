<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - All Bookings</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
<h2>All Bookings</h2>
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
        ArrayList<String[]> bookings = (ArrayList<String[]>) request.getAttribute("bookings");
        if (bookings != null) {
            for (String[] booking : bookings) {
    %>
    <tr>
        <td><%= booking[0] %></td>
        <td><%= booking[1] %></td>
        <td><%= booking[2] %></td>
        <td><%= booking[3] %></td>
        <td><%= booking[4] %></td>
        <td><%= booking[5] %></td>
        <td><%= booking[6] %></td>
    </tr>
    <%
            }
        }
    %>
</table>
</body>
</html>
