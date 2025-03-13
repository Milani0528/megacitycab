package com.megacitycab.servlets;

import com.megacitycab.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/CompleteTripServlet")
public class CompleteTripServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String bookingIdStr = request.getParameter("bookingId");
        String fareStr = request.getParameter("fare");
        String driverIdStr = request.getParameter("driverId");  // New: Get driver ID

        try {
            // Validate inputs
            if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                response.getWriter().println("<h3>Error: Booking ID is missing!</h3>");
                return;
            }
            if (fareStr == null || fareStr.isEmpty()) {
                response.getWriter().println("<h3>Error: Fare amount cannot be empty!</h3>");
                return;
            }
            if (driverIdStr == null || driverIdStr.isEmpty()) {
                response.getWriter().println("<h3>Error: Driver ID is missing!</h3>");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            double fare = Double.parseDouble(fareStr);
            int driverId = Integer.parseInt(driverIdStr);

            String vehicleType = null;

            // Fetch vehicle type for the driver
            try (Connection conn = DBConnection.getConnection()) {
                String vehicleSql = "SELECT c.vehicle_type FROM cars c " +
                        "INNER JOIN users u ON u.assigned_car_id = c.id " +
                        "WHERE u.id = ?";
                PreparedStatement vehicleStmt = conn.prepareStatement(vehicleSql);
                vehicleStmt.setInt(1, driverId);
                ResultSet rs = vehicleStmt.executeQuery();

                if (rs.next()) {
                    vehicleType = rs.getString("vehicle_type");
                } else {
                    response.getWriter().println("<h3>Error: Vehicle type not found for the driver!</h3>");
                    return;
                }

                // Update the bookings table with fare and vehicle type
                String sql = "UPDATE bookings SET status = 'Completed', amount = ?, payment_status = 'Pending', vehicle_type = ? WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setDouble(1, fare);
                stmt.setString(2, vehicleType);
                stmt.setInt(3, bookingId);
                stmt.executeUpdate();
            }

            // Redirect back to driver dashboard
            response.sendRedirect("driver-dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}

