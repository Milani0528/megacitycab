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

@WebServlet("/AssignDriverServlet")
public class AssignDriverServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingId = request.getParameter("booking_id");
        String driverId = request.getParameter("driver_id");

        if (bookingId == null || driverId == null || driverId.isEmpty()) {
            response.getWriter().println("Error: Invalid booking or driver selection.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // ✅ Step 1: Update the booking to assign the driver AND set status to Confirmed
            String sql = "UPDATE bookings SET driver_id = ?, status = 'Confirmed' WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(driverId));
            stmt.setInt(2, Integer.parseInt(bookingId));

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("admin-dashboard.jsp"); // ✅ Reload the page to reflect changes
            } else {
                response.getWriter().println("Error: Failed to assign driver.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: Database issue.");
        }
    }
}
