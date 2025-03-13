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

@WebServlet("/RegisterDriverServlet")
public class RegisterDriverServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{

        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String assignedCarId = request.getParameter("assigned_car_id");

        try(Connection conn = DBConnection.getConnection()){
            String sql = "INSERT INTO users (full_name, phone, username, password, role, assigned_car_id) " +
                    "VALUES (?, ?, ?, ?, 'driver', ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, phone);
            stmt.setString(3, username);
            stmt.setString(4, password);
            stmt.setInt(5, Integer.parseInt(assignedCarId));

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("index.jsp");
            } else {
                response.getWriter().println("Error: Failed to register driver.");
            }


        }catch (Exception e){
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }

    }


}
