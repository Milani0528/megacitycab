<%@ page import="java.sql.*" %>
<%@ page import="com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Manage Bookings</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        table { width: 80%; margin: auto; border-collapse: collapse; }
        th, td { border: 1px solid black; padding: 10px; text-align: center; }
        th { background-color: #f2f2f2; }
        button { padding: 5px 10px; cursor: pointer; }
    </style>
</head>
<body>

<h2>All Bookings</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Customer</th>
        <th>Phone</th>
        <th>Pickup</th>
        <th>Dropoff</th>
        <th>Date</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <%
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT b.id, u.full_name, u.phone, b.pickup_location, b.dropoff_location, b.booking_date, b.status FROM bookings b JOIN users u ON b.customer_id = u.id";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int bookingId = rs.getInt("id");
                String fullName = rs.getString("full_name");
                String phone = rs.getString("phone");
                String pickup = rs.getString("pickup_location");
                String dropoff = rs.getString("dropoff_location");
                String date = rs.getString("booking_date");
                String status = rs.getString("status");
    %>

    <tr>
        <td><%= bookingId %></td>
        <td><%= fullName %></td>
        <td><%= phone %></td>
        <td><%= pickup %></td>
        <td><%= dropoff %></td>
        <td><%= date %></td>
        <td><%= status %></td>
        <td>
            <% if ("Pending".equals(status)) { %>
            <form action="UpdateBookingServlet" method="post">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <input type="hidden" name="newStatus" value="Confirmed">
                <button type="submit" style="background: orange;">Confirm</button>
            </form>
            <% } else if ("Confirmed".equals(status)) { %>
            <form action="UpdateBookingServlet" method="post">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <input type="hidden" name="newStatus" value="Completed">
                <button type="submit" style="background: green; color: white;">Complete</button>
            </form>
            <% } %>
        </td>
    </tr>

    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

</table>
</body>
</html>
