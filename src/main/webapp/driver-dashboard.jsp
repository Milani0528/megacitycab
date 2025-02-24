<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, com.megacitycab.utils.DBConnection" %>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function validateAndSubmit(bookingId) {
            let fareInput = document.getElementById("fare-" + bookingId);
            let fareHiddenInput = document.getElementById("fare-hidden-" + bookingId);
            let completeButton = document.getElementById("complete-btn-" + bookingId);

            if (!fareInput.value || isNaN(fareInput.value) || parseFloat(fareInput.value) <= 0) {
                alert("Please enter a valid fare amount!");
                return false;  // Prevent form submission
            }

            fareHiddenInput.value = fareInput.value;
            completeButton.innerText = "Processing...";
            completeButton.disabled = true;

            return true;  // Allow form submission
        }
    </script>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card p-4 shadow">
        <h2 class="text-center text-primary">
            🚖 Driver - Assigned Trips
        </h2>
        <p class="text-center"><strong>Welcome, <%= driverName %></strong></p>

        <table class="table table-bordered table-striped text-center">
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
                    String query = "SELECT b.id, u.full_name AS customer_name, b.pickup_location, b.dropoff_location, " +
                            "b.booking_date, b.status, b.amount, b.payment_status " +
                            "FROM bookings b " +
                            "JOIN users u ON b.customer_id = u.id " +
                            "WHERE b.driver_id = ?";

                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, driverId);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int bookingId = rs.getInt("id");
                        String customerName = rs.getString("customer_name");
                        String pickup = rs.getString("pickup_location");
                        String dropoff = rs.getString("dropoff_location");
                        String bookingDate = rs.getString("booking_date");
                        String status = rs.getString("status");
                        double fare = rs.getDouble("amount");
                        String paymentStatus = rs.getString("payment_status");
            %>
            <tr>
                <td><%= bookingId %></td>
                <td><%= customerName %></td>
                <td><%= pickup %></td>
                <td><%= dropoff %></td>
                <td><%= bookingDate %></td>
                <td>
                    <span class="badge <%= "Completed".equals(status) ? "bg-success" : "bg-warning" %>">
                        <%= status %>
                    </span>
                </td>
                <td>
                    <% if (fare > 0) { %>
                    $<%= fare %>
                    <% } else { %>
                    <form action="CompleteTripServlet" method="post" onsubmit="return validateAndSubmit(<%= bookingId %>)">
                        <input type="hidden" name="bookingId" value="<%= bookingId %>">  <!-- FIXED: Ensure name matches servlet -->
                        <input type="hidden" id="fare-hidden-<%= bookingId %>" name="fare">
                        <input type="number" id="fare-<%= bookingId %>" class="form-control form-control-sm" placeholder="Enter Fare" required>
                        <button type="submit" id="complete-btn-<%= bookingId %>" class="btn btn-success btn-sm mt-2">Complete Trip</button>
                    </form>
                    <% } %>
                </td>
                <td>
                    <% if ("Paid".equals(paymentStatus)) { %>
                    <span class="badge bg-success">Paid</span>
                    <% } else { %>
                    <span class="badge bg-danger">Not Paid</span>
                    <% } %>
                </td>
                <td>
                    <% if ("Completed".equals(status)) { %>
                    <button class="btn btn-secondary btn-sm" disabled>✔️ Completed</button>
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

        <!-- Logout Button -->
        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
