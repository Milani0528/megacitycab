<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Mega City Cab - Login</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        form { width: 300px; margin: auto; padding: 20px; border: 1px solid #ddd; }
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
</body>
</html>
