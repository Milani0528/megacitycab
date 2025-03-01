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

@WebServlet("/CompleteTripServlet")
public class CompleteTripServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form parameters
        String bookingIdStr = request.getParameter("bookingId");  // Ensure name matches form
        String fareStr = request.getParameter("fare");

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

            int bookingId = Integer.parseInt(bookingIdStr);
            double fare = Double.parseDouble(fareStr);

            // Update the database
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "UPDATE bookings SET status = 'Completed', amount = ?, payment_status = 'Pending' WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setDouble(1, fare);
                stmt.setInt(2, bookingId);
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

