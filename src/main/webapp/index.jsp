<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab - Login</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
        }
        .btn-login {
            background-color: #28a745;
            color: white;
        }
        .btn-login:hover {
            background-color: #218838;
        }
        .btn-signup {
            background-color: #007bff;
            color: white;
        }
        .btn-signup:hover {
            background-color: #0056b3;
        }
        .table-container {
            max-width: 600px;
            margin: 20px auto;
        }
    </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand mx-auto">Mega City Cab - Login</a>
    </div>
</nav>

<!-- Login Form -->
<div class="container">
    <div class="login-container">
        <h2 class="text-center mb-4">Welcome to Mega City Cab</h2>
        <form action="login" method="post">
            <div class="mb-3">
                <label class="form-label">Username:</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password:</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-login w-100">🚖 Login</button>
        </form>
        <br>
        <!-- Signup Button -->
        <form action="register.jsp" method="get">
            <button type="submit" class="btn btn-signup w-100">📝 Signup</button>
        </form>
    </div>
</div>

<!-- User Credentials Table (Dynamically Fetched) -->
<div class="container table-container">
    <h4 class="text-center">Test User Credentials</h4>
    <table class="table table-bordered table-striped text-center">
        <thead class="table-dark">
        <tr>
            <th>Username</th>
            <th>Password</th>
            <th>Role</th>
        </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT username, password, role FROM users");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    String username = rs.getString("username");
                    String password = rs.getString("password");
                    String role = rs.getString("role");
        %>
        <tr>
            <td><%= username %></td>
            <td><%= password %></td>
            <td><%= role %></td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="3" class="text-danger">⚠️ Error fetching user data</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
