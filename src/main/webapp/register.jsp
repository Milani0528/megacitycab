<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Signup - Mega City Cab</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- TailwindCSS CDN for modern design -->
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        .popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            visibility: hidden;
            opacity: 0;
            transition: all 0.3s ease;
        }

        .popup.active {
            visibility: visible;
            opacity: 1;
        }

        .popup-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            text-align: center;
            animation: popup 0.4s ease;
        }

        @keyframes popup {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
    </style>
</head>

<body class="bg-gray-100 h-screen flex justify-center items-center">

<div class="w-full max-w-md bg-white p-8 rounded-3xl shadow-2xl border border-gray-200">
    <h2 class="text-3xl font-extrabold text-center text-blue-600 mb-6">Create Your Account 🚗</h2>

    <form id="registrationForm" method="post" action="RegisterServlet">
        <input type="text" name="full_name" placeholder="Full Name" required
               class="w-full p-3 mb-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

        <input type="text" name="phone" placeholder="Phone Number" required
               class="w-full p-3 mb-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

        <input type="email" name="email" placeholder="Email (Optional)"
               class="w-full p-3 mb-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

        <input type="text" name="username" placeholder="Username" required
               class="w-full p-3 mb-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

        <input type="password" name="password" placeholder="Password" required
               class="w-full p-3 mb-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

        <input type="hidden" name="role" value="customer">

        <button type="submit"
                class="w-full bg-blue-500 text-white p-3 rounded-lg hover:bg-blue-600 transition shadow-md">
            Register
        </button>
    </form>

    <p class="text-center text-sm text-gray-500 mt-4">
        Already have an account?
        <a href="index.jsp" class="text-blue-500 hover:underline">Login Here</a>
    </p>
</div>

<div id="successPopup" class="popup">
    <div class="popup-content">
        <h2 class="text-2xl font-semibold text-green-500 mb-4">🎉 Registration Successful!</h2>
        <p class="mb-6 text-gray-600">Redirecting you to the login page...</p>
        <button onclick="redirectToLogin()"
                class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition shadow-md">
            Go to Login
        </button>
    </div>
</div>

<script>
    function redirectToLogin() {
        window.location.href = 'index.jsp';
    }

    // Show popup if registration was successful
    <% if (request.getAttribute("success") != null) { %>
    document.getElementById('successPopup').classList.add('active');
    setTimeout(() => {
        window.location.href = 'index.jsp';
    }, 2000);
    <% } %>
</script>

</body>
</html>
