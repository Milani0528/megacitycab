<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Mega City Cab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
            background-color: #f4f4f4;
        }
        .container {
            width: 50%;
            margin: auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        }
        .logout {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 20px;
            background-color: red;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .logout:hover {
            background-color: darkred;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Welcome to Mega City Cab Dashboard</h2>
    <a href="booking.jsp" style="display: inline-block; padding: 10px 20px; background: green; color: white; text-decoration: none; border-radius: 5px;">Book a Cab</a>
    <%
        // Check if user session exists
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp"); // Redirect to login page
        } else {
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
    %>
    <p>Hello, <b><%= username %></b>!</p>
    <p>Your Role: <b><%= role %></b></p>

    <a class="logout" href="logout">Logout</a>
    <%
        }
    %>
</div>
</body>
</html>
