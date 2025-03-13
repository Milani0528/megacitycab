<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection, javax.servlet.http.*, javax.servlet.*" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int userId = (int) sessionObj.getAttribute("userId");
    String fullName = (String) sessionObj.getAttribute("full_name");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - Mega City Cab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-center mb-4">Welcome, <%= fullName %>!</h2>

    <!-- Booking Form -->
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">Book a Cab</div>
        <div class="card-body">
            <form action="BookingServlet" method="post">
                <input type="hidden" name="customer_id" value="<%= userId %>">

                <div class="mb-3">
                    <label class="form-label">Pickup Location</label>
                    <input type="text" class="form-control" name="pickup_location" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Drop-off Location</label>
                    <input type="text" class="form-control" name="dropoff_location" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Booking Date & Time</label>
                    <input type="datetime-local" class="form-control" name="booking_date" required>
                </div>

                <button type="submit" class="btn btn-success w-100">Book Now</button>
            </form>
        </div>
    </div>

    <!-- Bookings Table -->
    <h3 class="text-center">My Bookings</h3>
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Pickup</th>
                <th>Drop-off</th>
                <th>Booking Date</th>
                <th>Status</th>
                <th>Driver</th>
                <th>Vehicle</th>
                <th>Fare</th>
                <th>Payment</th>
            </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT b.id, b.pickup_location, b.dropoff_location, b.booking_date, b.status, " +
                            "u.full_name AS driver_name, c.model AS car_model, c.registration_number, c.vehicle_type, " +
                            "b.amount, b.payment_status " +
                            "FROM bookings b " +
                            "LEFT JOIN users u ON b.driver_id = u.id " +
                            "LEFT JOIN cars c ON u.assigned_car_id = c.id " +
                            "WHERE b.customer_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        double amount = rs.getDouble("amount");
                        boolean isFareSet = amount > 0;
                        String paymentStatus = rs.getString("payment_status");
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("pickup_location") %></td>
                <td><%= rs.getString("dropoff_location") %></td>
                <td><%= rs.getTimestamp("booking_date") %></td>
                <td>
                    <% if ("Completed".equals(rs.getString("status"))) { %>
                    <span class="badge bg-success">Completed</span>
                    <% } else { %>
                    <span class="badge bg-warning"><%= rs.getString("status") %></span>
                    <% } %>
                </td>
                <td><%= (rs.getString("driver_name") != null) ? rs.getString("driver_name") : "Not Assigned" %></td>

                <!-- Vehicle Details -->
                <td>
                    <% if (rs.getString("car_model") != null) { %>
                    <%= rs.getString("car_model") %> - <%= rs.getString("registration_number") %> (<%= rs.getString("vehicle_type") %>)
                    <% } else { %>
                    <span class="text-muted">Not Assigned</span>
                    <% } %>
                </td>

                <!-- Fare Display -->
                <td>
                    <% if (isFareSet) { %>
                    $<%= amount %>
                    <% } else { %>
                    <span class="text-muted">Pending</span>
                    <% } %>
                </td>

                <!-- Payment Button -->
                <td>
                    <% if (isFareSet) { %>
                    <% if ("Pending".equals(paymentStatus)) { %>
                    <form action="PaymentServlet" method="post">
                        <input type="hidden" name="bookingId" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn btn-success btn-sm">Pay Now</button>
                    </form>
                    <% } else { %>
                    <span class="badge bg-success">Paid</span>
                    <% } %>
                    <% } else { %>
                    <span class="text-muted">Waiting for Driver</span>
                    <% } %>
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
    </div>

    <!-- Logout Button -->
    <div class="text-center mt-3">
        <a href="index.jsp" class="btn btn-danger">Logout</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
