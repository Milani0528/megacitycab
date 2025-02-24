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

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // Default role is 'customer' or 'driver'

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (full_name, phone, email, username, password, role) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, email);
            stmt.setString(4, username);
            stmt.setString(5, password); // Secure it with hashing in production
            stmt.setString(6, role);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("<h3>Registration Successful! <a href='index.jsp'>Login Here</a></h3>");
            } else {
                response.getWriter().println("<h3>Registration Failed. Try Again.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error Registering User.</h3>");
        }
    }
}
