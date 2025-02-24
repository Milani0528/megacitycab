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

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .dashboard-container {
            background: white;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        h2 {
            color: #007bff;
        }
        .btn-custom {
            width: 100%;
            font-size: 18px;
            font-weight: bold;
            transition: all 0.3s ease-in-out;
        }
        .btn-book {
            background-color: #28a745;
            color: white;
        }
        .btn-book:hover {
            background-color: #218838;
            color: white;
        }
        .btn-logout {
            background-color: #dc3545;
            color: white;
        }
        .btn-logout:hover {
            background-color: #c82333;
            color: white;
        }
    </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand">Mega City Cab - Dashboard</a>
        <a href="LogoutServlet" class="btn btn-danger">Logout</a>
    </div>
</nav>

<!-- Main Content -->
<div class="container mt-5">
    <div class="dashboard-container p-4">
        <h2>Welcome, <%= fullName %> 👋</h2>
        <p class="text-muted"><strong>Phone:</strong> <%= phone %></p>
        <p class="text-muted"><strong>Role:</strong> <%= role %></p>

        <!-- Book a Cab Button -->
        <a href="booking.jsp" class="btn btn-book btn-lg btn-custom mb-3">🚖 Book a Cab</a>

        <!-- Logout Button -->
        <a href="LogoutServlet" class="btn btn-logout btn-lg btn-custom">🚪 Logout</a>
    </div>
</div>

</body>
</html>
