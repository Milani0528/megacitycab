<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<h2 class="text-center mb-4">Make Payment</h2>

<form action="PaymentServlet" method="post" class="col-md-6 offset-md-3">
    <input type="hidden" name="bookingId" value="<%= bookingId %>">

    <div class="mb-3">
        <label for="amount" class="form-label">Enter Amount:</label>
        <input type="number" step="0.01" class="form-control" name="amount" required>
    </div>

    <button type="submit" class="btn btn-success w-100">Confirm Payment</button>
</form>

<a href="dashboard.jsp" class="btn btn-secondary mt-3 d-block text-center">Cancel</a>
</body>
</html>
