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
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); // Secure this later with password hashing

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setAttribute("phone", rs.getString("phone"));
                session.setAttribute("role", rs.getString("role"));

                // **🔹 Redirect based on Role**
                String role = rs.getString("role");
                if ("admin".equals(role)) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else if ("driver".equals(role)) {
                    response.sendRedirect("driver-dashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp"); // Default to customer dashboard
                }

            } else {
                response.getWriter().println("<h3>Invalid Credentials! Try Again.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error Connecting to Database</h3>");
        }
    }
}
