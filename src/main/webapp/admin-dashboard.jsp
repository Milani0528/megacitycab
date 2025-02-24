<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Manage Bookings</title>
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand">Mega City Cab - Admin Dashboard</a>
        <a href="LogoutServlet" class="btn btn-danger">Logout</a>
    </div>
</nav>

<!-- Main Content -->
<div class="container mt-4">
    <h2 class="text-center">Manage Bookings</h2>

    <table class="table table-bordered table-striped mt-3">
        <thead class="table-primary">
        <tr>
            <th>ID</th>
            <th>Customer Name</th>
            <th>Phone</th>
            <th>Pickup Location</th>
            <th>Drop-off Location</th>
            <th>Booking Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT b.id, u.full_name, u.phone, b.pickup_location, b.dropoff_location, b.booking_date, b.status FROM bookings b JOIN users u ON b.customer_id = u.id";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("pickup_location") %></td>
            <td><%= rs.getString("dropoff_location") %></td>
            <td><%= rs.getTimestamp("booking_date") %></td>
            <td>
                <form action="UpdateBookingServlet" method="post" class="d-flex">
                    <input type="hidden" name="booking_id" value="<%= rs.getInt("id") %>">
                    <select name="status" class="form-select me-2">
                        <option value="Pending" <%= rs.getString("status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Confirmed" <%= rs.getString("status").equals("Confirmed") ? "selected" : "" %>>Confirmed</option>
                        <option value="Completed" <%= rs.getString("status").equals("Completed") ? "selected" : "" %>>Completed</option>
                    </select>
                    <button type="submit" class="btn btn-success">Update</button>
                </form>
            </td>
            <td>
                <form action="DeleteBookingServlet" method="post">
                    <input type="hidden" name="booking_id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="8" class="text-danger text-center">Error loading bookings</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
