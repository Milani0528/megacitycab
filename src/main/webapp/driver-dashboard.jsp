<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection, javax.servlet.http.*, javax.servlet.*" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int driverId = (int) sessionObj.getAttribute("userId");
    String driverName = (String) sessionObj.getAttribute("full_name");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Driver Dashboard - Mega City Cab</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        body {
            background-color: #f4f4f4;
        }
        .dashboard-container {
            max-width: 1100px;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        .btn-action {
            font-size: 14px;
            padding: 5px 12px;
            margin: 2px;
        }
    </style>
</head>
<body>

<div class="container dashboard-container">
    <h2 class="text-center text-primary mb-4">🚖 Driver - Assigned Trips</h2>
    <h5 class="text-center">Welcome, <%= driverName %></h5>

    <div class="table-responsive mt-4">
        <table class="table table-bordered table-striped table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Pickup</th>
                <th>Drop-off</th>
                <th>Booking Date</th>
                <th>Status</th>
                <th>Fare</th>
                <th>Payment</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT b.id, u.full_name AS customer_name, b.pickup_location, " +
                            "b.dropoff_location, b.booking_date, b.status, b.amount, b.payment_status " +
                            "FROM bookings b JOIN users u ON b.customer_id = u.id WHERE b.driver_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, driverId);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int bookingId = rs.getInt("id");
                        String status = rs.getString("status");
                        double fare = rs.getDouble("amount");
                        String paymentStatus = rs.getString("payment_status");
            %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("pickup_location") %></td>
                <td><%= rs.getString("dropoff_location") %></td>
                <td><%= rs.getTimestamp("booking_date") %></td>

                <!-- Status -->
                <td>
                    <% if ("Pending".equals(status)) { %>
                    <span class="badge bg-warning">Pending</span>
                    <% } else { %>
                    <span class="badge bg-success">Completed</span>
                    <% } %>
                </td>

                <!-- Fare Entry -->
                <td>
                    <% if (fare > 0) { %>
                    <span class="badge bg-primary">$<%= fare %></span>
                    <% } else { %>
                    <form action="CompleteTripServlet" method="post" class="d-inline">
                        <input type="hidden" name="bookingId" value="<%= bookingId %>">
                        <input type="number" step="0.01" class="form-control form-control-sm d-inline-block w-50"
                               name="fare" placeholder="Enter Fare" required>
                        <button type="submit" class="btn btn-success btn-sm btn-action">
                            <i class="fas fa-check-circle"></i> Complete Trip
                        </button>
                    </form>
                    <% } %>
                </td>

                <!-- Payment Status -->
                <td>
                    <% if ("Paid".equals(paymentStatus)) { %>
                    <span class="badge bg-success">Paid</span>
                    <% } else { %>
                    <span class="badge bg-danger">Not Paid</span>
                    <% } %>
                </td>

                <!-- Action -->
                <td>
                    <% if (fare > 0) { %>
                    <button class="btn btn-secondary btn-sm btn-action" disabled>
                        <i class="fas fa-ban"></i> Completed
                    </button>
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
    <div class="text-center mt-4">
        <a href="index.jsp" class="btn btn-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
