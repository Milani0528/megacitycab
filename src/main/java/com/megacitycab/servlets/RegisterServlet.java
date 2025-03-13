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
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (full_name, phone, email, username, password, role) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, email);
            stmt.setString(4, username);
            stmt.setString(5, password);
            stmt.setString(6, role);

            int result = stmt.executeUpdate();

            if (result > 0) {
                // Set attribute to show success popup
                request.setAttribute("success", true);
            }

            // Forward back to the registration page
            request.getRequestDispatcher("register.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error Registering User.</h3>");
        }
    }
}
