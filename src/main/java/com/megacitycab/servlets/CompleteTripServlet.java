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

        String bookingIdStr = request.getParameter("bookingId");
        String fareStr = request.getParameter("fare");
        String driverIdStr = request.getParameter("driverId");

        try {
            if (bookingIdStr == null || fareStr == null || driverIdStr == null) {
                response.getWriter().println("<h3>Error: Required parameters are missing!</h3>");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            double fare = Double.parseDouble(fareStr);
            int driverId = Integer.parseInt(driverIdStr);

            String vehicleType = null;

            try (Connection conn = DBConnection.getConnection()) {
                String vehicleSql = "SELECT c.vehicle_type FROM cars c INNER JOIN users u ON u.assigned_car_id = c.id WHERE u.id = ?";
                PreparedStatement vehicleStmt = conn.prepareStatement(vehicleSql);
                vehicleStmt.setInt(1, driverId);
                ResultSet rs = vehicleStmt.executeQuery();

                if (rs.next()) {
                    vehicleType = rs.getString("vehicle_type");
                } else {
                    response.getWriter().println("<h3>Error: Vehicle type not found for the driver!</h3>");
                    return;
                }

                String updateSql = "UPDATE bookings SET status = 'Completed', amount = ?, payment_status = 'Pending', vehicle_type = ? WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(updateSql);
                stmt.setDouble(1, fare);
                stmt.setString(2, vehicleType);
                stmt.setInt(3, bookingId);
                stmt.executeUpdate();
            }

            response.sendRedirect("driver-dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}

