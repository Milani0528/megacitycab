<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    HttpSession sessionObj = request.getSession(false); // Get session without creating a new one
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp"); // Redirect to login if session doesn't exist
        return;
    }

    String fullName = (String) sessionObj.getAttribute("full_name");
    String phone = (String) sessionObj.getAttribute("phone");
    String role = (String) sessionObj.getAttribute("role");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Mega City Cab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            text-align: center;
            padding: 50px;
        }
        .dashboard-container {
            background: white;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
        }
        p {
            font-size: 16px;
            margin: 10px 0;
        }
        .btn {
            display: inline-block;
            padding: 12px 20px;
            margin-top: 20px;
            font-size: 16px;
            text-decoration: none;
            color: white;
            border-radius: 5px;
            transition: 0.3s;
        }
        .book-btn {
            background-color: #28a745;
        }
        .book-btn:hover {
            background-color: #218838;
        }
        .logout-btn {
            background-color: #dc3545;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <h2>Welcome, <%= fullName %></h2>
    <p><strong>Phone:</strong> <%= phone %></p>
    <p><strong>Role:</strong> <%= role %></p>

    <!-- Book a Cab Button -->
    <a href="booking.jsp" class="btn book-btn">🚖 Book a Cab</a>

    <br><br>

    <!-- Logout Button -->
    <a href="logout.jsp" class="btn logout-btn">🚪 Logout</a>
</div>

</body>
</html>
