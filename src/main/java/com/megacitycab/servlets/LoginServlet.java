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
            stmt.setString(2, password); // Insecure (password should be hashed)

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("DEBUG: Login successful for " + username);

                // Ensure session exists
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setAttribute("phone", rs.getString("phone"));
                session.setAttribute("role", rs.getString("role"));

                // Use absolute URL for redirection
                System.out.println("DEBUG: New Session ID: " + session.getId());  // Print after setting attributes
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                System.out.println("DEBUG: Redirecting to " + request.getContextPath() + "/dashboard.jsp");

                return;

            } else {
                System.out.println("DEBUG: Login failed for " + username);
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=2");
        }
    }
}


