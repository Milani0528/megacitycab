<%@ page import="java.sql.*, com.megacitycab.utils.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Driver</title>
</head>
<body>

<h2>Register New Driver</h2>

<form method="post" action="RegisterDriverServlet">
    Full Name: <input type="text" name="full_name" required><br/>
    Phone: <input type="text" name="phone" required><br/>
    Username: <input type="text" name="username" required><br/>
    Password: <input type="password" name="password" required><br/>

    <!-- Vehicle Dropdown -->
    Select Vehicle:
    <select name="assigned_car_id" required>
        <option value="">- Select Vehicle -</option>
        <%
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT id, model, registration_number, vehicle_type " +
                        "FROM cars WHERE id NOT IN (SELECT assigned_car_id FROM users WHERE assigned_car_id IS NOT NULL)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int carId = rs.getInt("id");
                    String model = rs.getString("model");
                    String regNumber = rs.getString("registration_number");
                    String vehicleType = rs.getString("vehicle_type");
        %>
        <option value="<%= carId %>"><%= model %> - <%= regNumber %> (<%= vehicleType %>)</option>
        <%
            }

            // Handle case when no vehicles are available
            if (!rs.first()) {
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
    </select><br/><br/>

    <button type="submit">Register Driver 🚗</button>
</form>

</body>
</html>
