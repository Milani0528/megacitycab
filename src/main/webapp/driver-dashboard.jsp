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
        // Fetch Vehicle Type
        String vehicleQuery = "SELECT c.vehicle_type FROM cars c JOIN users u ON u.assigned_car_id = c.id WHERE u.id = ?";
        PreparedStatement vehicleStmt = conn.prepareStatement(vehicleQuery);
        vehicleStmt.setInt(1, driverId);
        ResultSet vehicleRs = vehicleStmt.executeQuery();
        if (vehicleRs.next()) {
            vehicleType = vehicleRs.getString("vehicle_type");
        }

        // Fetch Earnings for Completed & Paid Trips
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

        .trip-card {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .trip-card:hover {
            transform: translateY(-5px);
        }

        .summary-container {
            padding: 25px;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            border-radius: 15px;
            color: white;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }

        .badge-paid { background: #28a745; padding: 5px 10px; border-radius: 5px; color: white; }
        .badge-pending { background: #ffc107; padding: 5px 10px; border-radius: 5px; color: black; }
        .badge-danger { background: #dc3545; padding: 5px 10px; border-radius: 5px; color: white; }

        .btn-submit {
            background-color: #28a745;
            padding: 8px 16px;
            border-radius: 5px;
            color: white;
        }

        .btn-submit:hover {
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
        <!-- Left Side: Trip Cards -->
        <div class="col-md-8">
            <h2 class="text-center text-primary">🚖 Driver - Assigned Trips</h2>

            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT b.id, u.full_name AS customer_name, b.pickup_location, b.dropoff_location, " +
                            "b.status, b.amount, b.payment_status FROM bookings b " +
                            "JOIN users u ON b.customer_id = u.id WHERE b.driver_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, driverId);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
            <div class="trip-card">
                <h5><strong>Booking ID: <%= rs.getInt("id") %></strong></h5>
                <p><strong>Customer:</strong> <%= rs.getString("customer_name") %></p>
                <p><strong>Pickup:</strong> <%= rs.getString("pickup_location") %></p>
                <p><strong>Drop-off:</strong> <%= rs.getString("dropoff_location") %></p>
                <p><strong>Status:</strong> <span class="badge <%= rs.getString("status").equals("Completed") ? "badge-paid" : "badge-pending" %>">
                    <%= rs.getString("status") %></span></p>
                <p><strong>Fare:</strong> $<%= rs.getDouble("amount") %></p>
                <p><strong>Payment:</strong> <span class="badge <%= rs.getString("payment_status").equals("Paid") ? "badge-paid" : "badge-danger" %>">
                    <%= rs.getString("payment_status") %></span></p>

                <% if (!"Completed".equals(rs.getString("status"))) { %>
                <form action="CompleteTripServlet" method="post">
                    <input type="hidden" name="bookingId" value="<%= rs.getInt("id") %>">
                    <input type="hidden" name="driverId" value="<%= driverId %>">
                    <input type="number" step="0.01" min="0" name="fare" placeholder="Enter Fare" class="form-control mb-2" required>
                    <button type="submit" class="btn-submit">Complete Trip</button>
                </form>
                <% } %>
            </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>

            <div class="text-center mt-3">
                <a href="index.jsp" class="btn btn-logout">Logout</a>
            </div>
        </div>

        <!-- Right Side: Summary -->
        <div class="col-md-4">
            <div class="summary-container">
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
