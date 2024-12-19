<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f0f0f0;
        }
        .filter-container {
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
        select, button, input {
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
            top: 130px; /* Adjust to position it below the "Send Review" button */
            left: 10px; /* Align it horizontally with the other buttons */
            background-color: #2196F3; /* Blue background for the button */
            color: white; /* White text color */
            border: none; /* Remove borders */
            border-radius: 5px; /* Rounded corners */
            padding: 10px 20px; /* Padding for the button */
            text-decoration: none; /* Remove underline from links */
            font-size: 16px; /* Adjust font size */
            font-family: Arial, sans-serif; /* Font styling */
            cursor: pointer; /* Pointer cursor on hover */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); /* Optional shadow */
            transition: all 0.3s ease; /* Smooth transition for hover effects */
        }

        .refresh-btn:hover {
            background-color: #1e88e5; /* Darker blue on hover */
            box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3); /* Enhanced shadow on hover */
        }

        .logout-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #FF5722;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
        }

        .annuler-btn {
            position: absolute;
            top: 20px; /* Adjust this value to move it further down */
            left: 10px; /* Adjust this value to move it further to the left */
            background-color: #ff4d4d; /* Red background for the button */
            color: white; /* White text color */
            border: none; /* Remove borders */
            border-radius: 5px; /* Rounded corners */
            padding: 10px 20px; /* Padding for the button */
            text-decoration: none; /* Remove underline from links */
            font-size: 16px; /* Adjust font size */
            font-family: Arial, sans-serif; /* Font styling */
            cursor: pointer; /* Pointer cursor on hover */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); /* Optional shadow */
            transition: all 0.3s ease; /* Smooth transition for hover effects */
        }

        .annuler-btn:hover {
            background-color: #ff1a1a; /* Darker red on hover */
            box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3); /* Enhanced shadow on hover */
        }

        .review-btn {
            position: absolute;
            top: 70px; /* Adjust this value to position it below the "Cancel A Reservation" button */
            left: 10px; /* Align it with the "Cancel A Reservation" button */
            background-color: #4CAF50; /* Green background for the button */
            color: white; /* White text color */
            border: none; /* Remove borders */
            border-radius: 5px; /* Rounded corners */
            padding: 10px 20px; /* Padding for the button */
            text-decoration: none; /* Remove underline from links */
            font-size: 16px; /* Adjust font size */
            font-family: Arial, sans-serif; /* Font styling */
            cursor: pointer; /* Pointer cursor on hover */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); /* Optional shadow */
            transition: all 0.3s ease; /* Smooth transition for hover effects */
        }

        .review-btn:hover {
            background-color: #45a049; /* Darker green on hover */
            box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3); /* Enhanced shadow on hover */
        }


    </style>
</head>
<body>
<a href="passengerprofile.jsp" class="refresh-btn">Refresh</a>
<h1>Carpooling</h1>
<div class="filter-container">
    <form method="get" action="passengerprofile.jsp">
        <label for="start_point">Start Point:</label>
        <select name="start_point" id="start_point">
            <option value="" selected>All Start Points</option>
            <%
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT DISTINCT start_point FROM rides")) {
                    while (rs.next()) {
            %>
            <option value="<%= rs.getString("start_point") %>"><%= rs.getString("start_point") %></option>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <label for="destination">Destination:</label>
        <select name="destination" id="destination">
            <option value="" selected>All Destinations</option>
            <%
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT DISTINCT destination FROM rides")) {
                    while (rs.next()) {
            %>
            <option value="<%= rs.getString("destination") %>"><%= rs.getString("destination") %></option>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <button type="submit">Filter</button>
    </form>
</div>

<form method="post" action="passengerprofile.jsp">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Driver Name</th>
            <th>Start Point</th>
            <th>Destination</th>
            <th>Date Time</th>
            <th>Available Seats</th>
            <th>Price</th>
            <th>Reserve</th>
        </tr>
        </thead>
        <tbody>
        <%
            String selectedStartPoint = request.getParameter("start_point");
            String selectedDestination = request.getParameter("destination");

            String query = "SELECT r.id, r.driver_id, r.start_point, r.destination, r.date_time, r.available_seats, r.price, u.name " +
                    "FROM rides r " +
                    "JOIN users u ON r.driver_id = u.id " +
                    "WHERE u.role = 'driver'";

            if (selectedStartPoint != null && !selectedStartPoint.isEmpty()) {
                query += " AND r.start_point = '" + selectedStartPoint + "'";
            }
            if (selectedDestination != null && !selectedDestination.isEmpty()) {
                query += " AND r.destination = '" + selectedDestination + "'";
            }

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("start_point") %></td>
            <td><%= rs.getString("destination") %></td>
            <td><%= rs.getTimestamp("date_time") %></td>
            <td><%= rs.getInt("available_seats") %></td>
            <td><%= rs.getBigDecimal("price") %></td>
            <td>
                <% if (rs.getInt("available_seats") > 0) { %>
                <input type="checkbox" name="reserve" value="<%= rs.getInt("id") %>">
                <input type="number" name="seats_<%= rs.getInt("id") %>" min="1" max="<%= rs.getInt("available_seats") %>" placeholder="Seats">
                <% } else { %>
                <span>No available seats</span>
                <% } %>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
    <button type="submit" name="reserveSelected">Reserve Selected</button>
</form>

<%
    if (request.getMethod().equals("POST") && request.getParameter("reserveSelected") != null) {
        String[] selectedRides = request.getParameterValues("reserve");
        if (selectedRides != null) {
            for (String rideId : selectedRides) {
                int rideIdInt = Integer.parseInt(rideId);
                int seatsToReserve = Integer.parseInt(request.getParameter("seats_" + rideIdInt));
                int userId = 1;  // Replace with actual logged-in user ID

                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
                     PreparedStatement ps = conn.prepareStatement(
                             "INSERT INTO reservations (ride_id, user_id, seats_reserved, created_at) VALUES (?, ?, ?, NOW())")) {
                    ps.setInt(1, rideIdInt);
                    ps.setInt(2, userId);
                    ps.setInt(3, seatsToReserve);
                    ps.executeUpdate();

                    try (PreparedStatement psUpdate = conn.prepareStatement(
                            "UPDATE rides SET available_seats = available_seats - ? WHERE id = ?")) {
                        psUpdate.setInt(1, seatsToReserve);
                        psUpdate.setInt(2, rideIdInt);
                        psUpdate.executeUpdate();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<h2>My Reservations</h2>
<table>
    <thead>
    <tr>
        <th>Reservation ID</th>
        <th>Ride ID</th>
        <th>Start Point</th>
        <th>Destination</th>
        <th>Date Time</th>
        <th>Seats Reserved</th>
    </tr>
    </thead>
    <tbody>
    <%
        int userId = 1;  // Replace with actual logged-in user ID
        String myReservationsQuery = "SELECT res.id AS reservation_id, r.id AS ride_id, r.start_point, r.destination, r.date_time, res.seats_reserved " +
                "FROM reservations res " +
                "JOIN rides r ON res.ride_id = r.id " +
                "WHERE res.user_id = ?";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
             PreparedStatement ps = conn.prepareStatement(myReservationsQuery)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("reservation_id") %></td>
        <td><%= rs.getInt("ride_id") %></td>
        <td><%= rs.getString("start_point") %></td>
        <td><%= rs.getString("destination") %></td>
        <td><%= rs.getTimestamp("date_time") %></td>
        <td><%= rs.getInt("seats_reserved") %></td>
    </tr>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
    </tbody>
</table>
<!-- Logout Button at the Top-Right -->
<a href="index.html" class="logout-btn">Logout</a>

<!-- Annuler Button at the Bottom of the Page -->
<a href="annuler.jsp" class="annuler-btn">Cancel A Reservation</a>
<!-- review Button at the Bottom of the Page -->
<a href="review.jsp" class="review-btn">Send Review</a>

</body>
</html>
