<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Passenger Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            border-bottom: 1px solid #ddd;
        }
        .header h1 {
            margin: 0 auto;
            color: black;
            text-align: center;
        }
        .header .btn {
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ddd;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }
        .header .btn:hover {
            background-color: #ddd;
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
        .annulation-btn {
            background-color: #E91E63;
            margin: 10px auto;
        }
    </style>
</head>
<body>

<div class="header">
    <a href="annuler.jsp" class="btn">Refresh</a>
    <h1>Ride Cancel</h1>
    <a href="passengerprofile.jsp" class="btn">Back</a>
</div>



<h2>My Reservations</h2>
<form method="post" action="annuler.jsp">
    <table>
        <thead>
        <tr>
            <th>Select</th>
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
            <td><input type="checkbox" name="reservation_ids" value="<%= rs.getInt("reservation_id") %>" /></td>
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
    <button class="annulation-btn" type="submit" name="annulateSelected">Annulate Selected</button>
</form>

<%
    if (request.getMethod().equals("POST") && request.getParameter("annulateSelected") != null) {
        String[] reservationIds = request.getParameterValues("reservation_ids");
        if (reservationIds != null) {
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597")) {
                for (String reservationId : reservationIds) {
                    int reservationIdInt = Integer.parseInt(reservationId);

                    try (PreparedStatement psGetSeats = conn.prepareStatement(
                            "SELECT ride_id, seats_reserved FROM reservations WHERE id = ?")) {
                        psGetSeats.setInt(1, reservationIdInt);
                        ResultSet rs = psGetSeats.executeQuery();
                        if (rs.next()) {
                            int rideId = rs.getInt("ride_id");
                            int seatsReserved = rs.getInt("seats_reserved");

                            try (PreparedStatement psUpdateSeats = conn.prepareStatement(
                                    "UPDATE rides SET available_seats = available_seats + ? WHERE id = ?")) {
                                psUpdateSeats.setInt(1, seatsReserved);
                                psUpdateSeats.setInt(2, rideId);
                                psUpdateSeats.executeUpdate();
                            }

                            try (PreparedStatement psDelete = conn.prepareStatement(
                                    "DELETE FROM reservations WHERE id = ?")) {
                                psDelete.setInt(1, reservationIdInt);
                                psDelete.executeUpdate();
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
