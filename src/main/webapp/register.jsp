<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Signup - Mega City Cab</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        form { width: 350px; margin: auto; padding: 20px; border: 1px solid #ddd; background: #f9f9f9; border-radius: 10px; }
        input, select { width: 100%; padding: 8px; margin-top: 10px; }
        button { margin-top: 10px; padding: 10px; background: blue; color: white; border: none; cursor: pointer; width: 100%; }
        button:hover { background: darkblue; }
    </style>
</head>
<body>
<h2>Signup for Mega City Cab</h2>
<form action="RegisterServlet" method="post">
    <input type="text" name="full_name" placeholder="Full Name" required><br>
    <input type="text" name="phone" placeholder="Phone Number" required><br>
    <input type="email" name="email" placeholder="Email (Optional)"><br>
    <input type="text" name="username" placeholder="Username" required><br>
    <input type="password" name="password" placeholder="Password" required><br>
    <select name="role">
        <option value="customer">Customer</option>
        <option value="driver">Driver</option>
    </select><br>
    <button type="submit">Register</button>
</form>
</body>
</html>
