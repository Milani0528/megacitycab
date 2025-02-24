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

@WebServlet("/AssignDriverServlet")
public class AssignDriverServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        int driverId = Integer.parseInt(request.getParameter("driver_id"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE bookings SET driver_id = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            stmt.setInt(2, bookingId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.getWriter().println("<h3>Error: Unable to assign driver.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Database Error.</h3>");
        }
    }
}
