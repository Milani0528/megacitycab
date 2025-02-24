<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Mega City Cab - Login</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        form { width: 300px; margin: auto; padding: 20px; border: 1px solid #ddd; background: #f9f9f9; border-radius: 10px; }
        button { margin-top: 10px; padding: 10px; background: green; color: white; border: none; cursor: pointer; width: 100%; }
        button:hover { background: darkgreen; }
        .signup-btn { background: blue; }
        .signup-btn:hover { background: darkblue; }
    </style>
</head>
<body>
<h2>Welcome to Mega City Cab</h2>
<form action="login" method="post">
    <label>Username:</label>
    <input type="text" name="username" required><br><br>
    <label>Password:</label>
    <input type="password" name="password" required><br><br>
    <button type="submit">Login</button>
</form>
<br>
<!-- Signup Button -->
<form action="register.jsp" method="get">
    <button type="submit" class="signup-btn">Signup</button>
</form>
</body>
</html>
