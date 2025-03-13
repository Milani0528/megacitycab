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

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE bookings SET driver_id = ?, status = 'Confirmed', vehicle_type = (SELECT vehicle_type FROM cars WHERE id = (SELECT assigned_car_id FROM users WHERE id = ?)) WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(driverId));
            stmt.setInt(2, Integer.parseInt(driverId));
            stmt.setInt(3, Integer.parseInt(bookingId));
            stmt.executeUpdate();

            response.sendRedirect("admin-dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: Database issue.");
        }
    }
}
