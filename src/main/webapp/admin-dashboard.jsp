<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card p-4 shadow-lg">
        <h2 class="text-center text-primary">
            👤 Admin - Manage Bookings
        </h2>

        <table class="table table-bordered table-striped text-center">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Pickup</th>
                <th>Drop-off</th>
                <th>Booking Date</th>
                <th>Vehicle Type</th>
                <th>Status</th>
                <th>Driver</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT b.id, u.full_name, b.pickup_location, b.dropoff_location, " +
                            "b.booking_date, b.vehicle_type, b.status, b.driver_id, b.payment_status " +
                            "FROM bookings b JOIN users u ON b.customer_id = u.id";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int bookingId = rs.getInt("id");
                        String customer = rs.getString("full_name");
                        String pickup = rs.getString("pickup_location");
                        String dropoff = rs.getString("dropoff_location");
                        String bookingDate = rs.getString("booking_date");
                        String vehicleType = rs.getString("vehicle_type");
                        String status = rs.getString("status");
                        int driverId = rs.getInt("driver_id");
            %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= customer %></td>
                <td><%= pickup %></td>
                <td><%= dropoff %></td>
                <td><%= bookingDate %></td>
                <td><%= vehicleType %></td>
                <td>
                    <span class="badge
                        <%= "Completed".equals(status) ? "bg-success" :
                            "Confirmed".equals(status) ? "bg-primary" :
                            "Pending".equals(status) ? "bg-warning" : "bg-secondary" %>">
                        <%= status %>
                    </span>
                </td>
                <td>
                    <form action="AssignDriverServlet" method="post">
                        <input type="hidden" name="booking_id" value="<%= bookingId %>">
                        <select name="driver_id" class="form-select">
                            <option value="">Select Driver</option>
                            <%
                                PreparedStatement driverStmt = conn.prepareStatement(
                                        "SELECT u.id, u.full_name FROM users u JOIN cars c ON u.assigned_car_id = c.id WHERE u.role = 'driver' AND c.vehicle_type = ?");
                                driverStmt.setString(1, vehicleType);
                                ResultSet driverRs = driverStmt.executeQuery();
                                while (driverRs.next()) {
                            %>
                            <option value="<%= driverRs.getInt("id") %>" <%= (driverRs.getInt("id") == driverId) ? "selected" : "" %> >
                                <%= driverRs.getString("full_name") %>
                            </option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn btn-warning btn-sm mt-1">Assign</button>
                    </form>
                </td>
                <td>
                    <form action="DeleteBookingServlet" method="post">
                        <input type="hidden" name="booking_id" value="<%= bookingId %>">
                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>

        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>