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

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String newStatus = request.getParameter("newStatus");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE bookings SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, bookingId);
            stmt.executeUpdate();
            response.sendRedirect("admin-dashboard.jsp"); // Reload dashboard
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Unable to update booking status.</h3>");
        }
    }
}
