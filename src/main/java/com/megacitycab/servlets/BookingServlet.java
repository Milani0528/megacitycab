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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.getWriter().println("<h3>Error: You must be logged in to book a cab.</h3>");
            return;
        }

        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String bookingDate = request.getParameter("bookingDate");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO bookings (customer_id, pickup_location, dropoff_location, booking_date, status, payment_status, amount) VALUES (?, ?, ?, ?, 'Pending', 'Pending', NULL)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            stmt.setString(2, pickupLocation);
            stmt.setString(3, dropoffLocation);

            // 🔥 Fix datetime format
            bookingDate = bookingDate.replace("T", " ") + ":00"; // Ensure format yyyy-MM-dd HH:mm:ss
            stmt.setTimestamp(4, Timestamp.valueOf(bookingDate));

            stmt.executeUpdate();
            response.sendRedirect("booking_success.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Failed to book cab.</h3>");
        }
    }
}

