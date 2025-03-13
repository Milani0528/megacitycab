<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, com.megacitycab.utils.DBConnection" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int driverId = (int) sessionObj.getAttribute("userId");
    String driverName = (String) sessionObj.getAttribute("full_name");

    String vehicleType = "";
    int completedTrips = 0;
    double totalEarnings = 0;
    double commission = 0;
    double balanceEarnings = 0;

    try (Connection conn = DBConnection.getConnection()) {
        String vehicleQuery = "SELECT c.vehicle_type FROM cars c JOIN users u ON u.assigned_car_id = c.id WHERE u.id = ?";
        PreparedStatement vehicleStmt = conn.prepareStatement(vehicleQuery);
        vehicleStmt.setInt(1, driverId);
        ResultSet vehicleRs = vehicleStmt.executeQuery();
        if (vehicleRs.next()) {
            vehicleType = vehicleRs.getString("vehicle_type");
        }

        String earningsQuery = "SELECT COUNT(*) AS completed_trips, SUM(amount) AS total_earnings " +
                "FROM bookings WHERE driver_id = ? AND status = 'Completed' AND payment_status = 'Paid'";
        PreparedStatement earningsStmt = conn.prepareStatement(earningsQuery);
        earningsStmt.setInt(1, driverId);
        ResultSet earningsRs = earningsStmt.executeQuery();
        if (earningsRs.next()) {
            completedTrips = earningsRs.getInt("completed_trips");
            totalEarnings = earningsRs.getDouble("total_earnings");
        }

        commission = totalEarnings * 0.2;
        balanceEarnings = totalEarnings - commission;

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Format values to 2 decimal places
    String formattedCommission = String.format("%.2f", commission);
    String formattedTotalEarnings = String.format("%.2f", totalEarnings);
    String formattedBalanceEarnings = String.format("%.2f", balanceEarnings);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Driver Dashboard - Mega City Cab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f0f4f8;
            font-family: 'Arial', sans-serif;
        }

        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        .modern-table th {
            background-color: #333;
            color: #fff;
            padding: 15px;
            border-radius: 8px;
        }

        .modern-table td {
            padding: 15px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .modern-table tr:hover td {
            transform: scale(1.02);
            transition: 0.3s;
        }

        .summary-container {
            padding: 25px;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            border-radius: 15px;
            color: white;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }

        .summary-container h4 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .summary-container p {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .badge-paid {
            background: #28a745;
            padding: 5px 10px;
            border-radius: 5px;
            color: white;
        }

        .badge-pending {
            background: #ffc107;
            padding: 5px 10px;
            border-radius: 5px;
            color: black;
        }

        .btn-complete {
            background-color: #28a745;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
        }

        .btn-complete:hover {
            background-color: #218838;
        }

        .btn-logout {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
        }

        .btn-logout:hover {
            background-color: #c82333;
        }

    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row">
        <!-- Left Side: Trip Details -->
        <div class="col-md-8">
            <div class="card p-4 shadow-lg">
                <h2 class="text-center text-primary">🚖 Driver - Assigned Trips</h2>

                <table class="modern-table text-center">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Pickup</th>
                        <th>Drop-off</th>
                        <th>Status</th>
                        <th>Fare</th>
                        <th>Payment</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT b.id, u.full_name AS customer_name, b.pickup_location, " +
                                    "b.dropoff_location, b.status, b.amount, b.payment_status " +
                                    "FROM bookings b JOIN users u ON b.customer_id = u.id WHERE b.driver_id = ?";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            stmt.setInt(1, driverId);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("customer_name") %></td>
                        <td><%= rs.getString("pickup_location") %></td>
                        <td><%= rs.getString("dropoff_location") %></td>
                        <td><span class="badge badge-paid"><%= rs.getString("status") %></span></td>
                        <td>$<%= rs.getDouble("amount") %></td>
                        <td><span class="badge <%= "Paid".equals(rs.getString("payment_status")) ? "badge-paid" : "badge-pending" %>"><%= rs.getString("payment_status") %></span></td>
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
                    <a href="index.jsp" class="btn btn-logout">Logout</a>
                </div>
            </div>
        </div>

        <!-- Right Side: Summary -->
        <div class="col-md-4">
            <div class="summary-container shadow-lg">
                <h4>Driver Summary 🚗</h4>
                <p><strong>Name:</strong> <%= driverName %></p>
                <p><strong>Vehicle Type:</strong> <%= vehicleType %></p>
                <p><strong>Completed Trips:</strong> <%= completedTrips %></p>
                <p><strong>Total Earnings:</strong> $<%= formattedTotalEarnings %></p>
                <p><strong>Commission (20%):</strong> $<%= formattedCommission %></p>
                <p><strong>Balance Earnings:</strong> $<%= formattedBalanceEarnings %></p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
