package com.megacitycab.servlets;

import com.megacitycab.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;



import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String pickupLocation = request.getParameter("pickup_location");
        String dropoffLocation = request.getParameter("dropoff_location");
        String bookingDate = request.getParameter("booking_date");

        System.out.println("Received booking request:");
        System.out.println("Customer Name: " + customerName);
        System.out.println("Phone: " + phone);
        System.out.println("Pickup Location: " + pickupLocation);
        System.out.println("Drop-off Location: " + dropoffLocation);
        System.out.println("Booking Date: " + bookingDate);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO bookings (customer_name, phone, pickup_location, dropoff_location, booking_date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, customerName);
            stmt.setString(2, phone);
            stmt.setString(3, pickupLocation);
            stmt.setString(4, dropoffLocation);
            stmt.setString(5, bookingDate);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✅ Booking inserted successfully into the database!");
                response.getWriter().println("<h3 style='color:green;'>Booking Success! Check Console Log.</h3>");
            } else {
                System.out.println("❌ Booking insertion failed!");
                response.getWriter().println("<h3 style='color:red;'>Booking Failed! Check Console Log.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("🚨 Database Error: " + e.getMessage());
            response.getWriter().println("<h3 style='color:red;'>Error Connecting to Database! Check Console Log.</h3>");
        }
    }
}
