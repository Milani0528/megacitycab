package com.megacitycab.servlets;

import com.megacitycab.models.Booking;
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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AdminBookingServlet")
public class AdminBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Booking> bookings = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String query = "SELECT b.id, u.full_name, u.phone, b.pickup_location, b.dropoff_location, b.booking_date, b.status " +
                    "FROM bookings b " +
                    "JOIN users u ON b.customer_id = u.id";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("pickup_location"),
                        rs.getString("dropoff_location"),
                        rs.getTimestamp("booking_date"),
                        rs.getString("status")
                );
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Store bookings list in request attribute
        request.setAttribute("bookings", bookings);

        // Forward to JSP page
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}
