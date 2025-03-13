package com.megacitycab.servlets;

import com.megacitycab.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.getWriter().println("<h3>Error: You must be logged in to book a cab.</h3>");
            return;
        }

        // ✅ Fix Parameter Name Mismatch
        String pickupLocation = request.getParameter("pickup_location");
        String dropoffLocation = request.getParameter("dropoff_location");
        String bookingDate = request.getParameter("booking_date");

        // ✅ Debugging: Print Values for Verification
        System.out.println("DEBUG: Pickup = " + pickupLocation);
        System.out.println("DEBUG: Drop-off = " + dropoffLocation);
        System.out.println("DEBUG: Booking Date (Raw) = " + bookingDate);

        // 🚨 Ensure `bookingDate` is not null before proceeding
        if (bookingDate == null || bookingDate.trim().isEmpty()) {
            response.getWriter().println("<h3>Error: Booking Date is required.</h3>");
            return;
        }

        // ✅ Fix Date Format (Convert `yyyy-MM-ddTHH:mm` to `yyyy-MM-dd HH:mm:ss`)
        bookingDate = bookingDate.replace("T", " ") + ":00";

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO bookings (customer_id, pickup_location, dropoff_location, booking_date, status, payment_status, amount) VALUES (?, ?, ?, ?, 'Pending', 'Pending', NULL)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            stmt.setString(2, pickupLocation);
            stmt.setString(3, dropoffLocation);
            stmt.setTimestamp(4, Timestamp.valueOf(bookingDate));

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("dashboard.jsp");
            } else {
                response.getWriter().println("<h3>Error: Failed to book cab.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
