<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Driver - Mega City Cab</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #43cea2, #185a9d);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Arial', sans-serif;
        }

        .register-container {
            background: #ffffff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 400px;
            animation: fadeIn 1s ease;
        }

        .register-container h2 {
            margin-bottom: 20px;
            color: #185a9d;
            font-weight: bold;
            text-align: center;
        }

        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ccc;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #43cea2;
            box-shadow: 0 0 10px rgba(67, 206, 162, 0.4);
        }

        .btn-register {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #43cea2, #185a9d);
            border: none;
            border-radius: 8px;
            color: #fff;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #185a9d, #43cea2);
            box-shadow: 0 5px 15px rgba(24, 90, 157, 0.4);
        }

        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #185a9d;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-select option[disabled] {
            color: #999;
        }
    </style>
</head>
<body>

<div class="register-container">
    <h2>Register New Driver</h2>

    <form method="post" action="RegisterDriverServlet">

        <input type="text" name="full_name" class="form-control" placeholder="Full Name" required>
        <input type="text" name="phone" class="form-control" placeholder="Phone Number" required>
        <input type="text" name="username" class="form-control" placeholder="Username" required>
        <input type="password" name="password" class="form-control" placeholder="Password" required>

        <select name="assigned_car_id" class="form-control" required>
            <option value="" disabled selected>- Select Vehicle -</option>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT id, model, registration_number, vehicle_type " +
                            "FROM cars WHERE id NOT IN (SELECT assigned_car_id FROM users WHERE assigned_car_id IS NOT NULL)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();

                    boolean hasVehicles = false;
                    while (rs.next()) {
                        hasVehicles = true;
                        int carId = rs.getInt("id");
                        String model = rs.getString("model");
                        String regNumber = rs.getString("registration_number");
                        String vehicleType = rs.getString("vehicle_type");
            %>
            <option value="<%= carId %>"><%= model %> - <%= regNumber %> (<%= vehicleType %>)</option>
            <%
                }

                if (!hasVehicles) {
            %>
            <option disabled>No vehicles available</option>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            %>
            <option disabled>Error fetching vehicles</option>
            <%
                }
            %>
        </select>

        <button type="submit" class="btn-register mt-3">Register Driver</button>
    </form>

    <a href="admin-dashboard.jsp" class="back-link">Back to Dashboard</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
