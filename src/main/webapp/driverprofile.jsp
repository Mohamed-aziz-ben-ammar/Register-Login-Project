<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Driver Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f0f0f0;
        }
        .form-container, .rides-container {
            margin: 20px auto;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 80%;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        input, select, button {
            padding: 10px;
            margin: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            background-color: #673AB7;
            color: white;
            border: none;
            cursor: pointer;
        }
        .refresh-btn {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
        }
        .logout-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 10px 20px;
            background-color: #ff4d4d; /* Red color */
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .logout-btn:hover {
            background-color: #ff1a1a;
            transform: scale(1.05);
        }

        .logout-btn:active {
            transform: scale(0.95);
        }

    </style>
</head>
<body>
<a href="index.html" class="logout-btn">Log Out</a>

<a href="driverprofile.jsp" class="refresh-btn">Refresh</a>
<h1>Driver Profile</h1>

<div class="form-container">
    <h2>Create a New Ride</h2>
    <form method="post" action="driverprofile.jsp">
        <label for="start_point">Start Point:</label>
        <input type="text" id="start_point" name="start_point" required>

        <label for="destination">Destination:</label>
        <input type="text" id="destination" name="destination" required>

        <label for="date_time">Date & Time:</label>
        <input type="datetime-local" id="date_time" name="date_time" required>

        <label for="available_seats">Available Seats:</label>
        <input type="number" id="available_seats" name="available_seats" min="1" required>

        <label for="price">Price:</label>
        <input type="number" id="price" name="price" min="0" step="0.01" required>

        <button type="submit" name="createRide">Create Ride</button>
    </form>
</div>

<%
    if (request.getMethod().equals("POST") && request.getParameter("createRide") != null) {
        String startPoint = request.getParameter("start_point");
        String destination = request.getParameter("destination");
        String dateTime = request.getParameter("date_time");
        int availableSeats = Integer.parseInt(request.getParameter("available_seats"));
        double price = Double.parseDouble(request.getParameter("price"));
        int driverId = 1;

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO rides (driver_id, start_point, destination, date_time, available_seats, price, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())")) {
            ps.setInt(1, driverId);
            ps.setString(2, startPoint);
            ps.setString(3, destination);
            ps.setString(4, dateTime);
            ps.setInt(5, availableSeats);
            ps.setDouble(6, price);
            ps.executeUpdate();

            out.println("<p style='color: green;'>Ride created successfully!</p>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<div class="rides-container">
    <h2>My Rides</h2>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Start Point</th>
            <th>Destination</th>
            <th>Date & Time</th>
            <th>Available Seats</th>
            <th>Price</th>
            <th>Created At</th>
        </tr>
        </thead>
        <tbody>
        <%
            int driverId = 1;
            String myRidesQuery = "SELECT id, start_point, destination, date_time, available_seats, price, created_at FROM rides WHERE driver_id = ?";

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
                 PreparedStatement ps = conn.prepareStatement(myRidesQuery)) {
                ps.setInt(1, driverId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("start_point") %></td>
            <td><%= rs.getString("destination") %></td>
            <td><%= rs.getTimestamp("date_time") %></td>
            <td><%= rs.getInt("available_seats") %></td>
            <td><%= rs.getBigDecimal("price") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
