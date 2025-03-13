<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Help - Mega City Cab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f0f4f8;
            font-family: 'Arial', sans-serif;
        }

        .help-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .help-header {
            font-size: 28px;
            font-weight: bold;
            color: #2575fc;
            text-align: center;
            margin-bottom: 20px;
        }

        .faq-section h5 {
            color: #333;
            font-weight: bold;
        }

        .faq-section p {
            color: #555;
            line-height: 1.6;
        }

        .contact-info {
            margin-top: 30px;
            padding: 20px;
            background: #e8f0fe;
            border-radius: 10px;
        }

        .btn-back {
            background-color: #2575fc;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-back:hover {
            background-color: #1e63d0;
        }

    </style>
</head>
<body>

<div class="help-container">
    <h2 class="help-header">🚖 Help & Support - Mega City Cab</h2>

    <div class="faq-section">
        <h5>1. How to Book a Cab?</h5>
        <p>Login to your account and fill out the booking form with your pickup, drop-off location, and desired time. Click on "Book Now".</p>

        <h5>2. How can I check my booking status?</h5>
        <p>Go to your dashboard to see all your current and past bookings along with their status.</p>

        <h5>3. How do I pay for my trip?</h5>
        <p>Once the trip is completed, if the fare is confirmed, you can proceed to the payment section and complete the payment.</p>

        <h5>4. How can I contact my assigned driver?</h5>
        <p>Once a driver is assigned to your trip, their name and vehicle details will be visible on your dashboard.</p>

        <h5>5. How to cancel a booking?</h5>
        <p>Please contact our support team using the information below to cancel a booking.</p>
    </div>

    <div class="contact-info">
        <h5>📞 Contact Support:</h5>
        <p><strong>Email:</strong> support@megacitycab.com</p>
        <p><strong>Phone:</strong> +1-800-123-4567</p>
        <p><strong>Working Hours:</strong> 8:00 AM - 10:00 PM (Everyday)</p>
    </div>

    <div class="text-center mt-4">
        <a href="index.jsp" class="btn-back">🔙 Back to Home</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
