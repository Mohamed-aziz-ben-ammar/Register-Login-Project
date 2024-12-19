<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Review Rides</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f0;
      margin: 0;
      padding: 0;
    }
    .header {
      text-align: center;
      padding: 10px;
      color: black;
      font-size: 24px;
    }
    table {
      width: 80%;
      margin: 20px auto;
      border-collapse: collapse;
      background-color: #ffffff;
      border: 1px solid #ddd;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 10px;
      text-align: left;
    }
    th {
      background-color: #f4f4f4;
    }
    .review-container {
      width: 80%;
      margin: 20px auto;
      text-align: center;
      padding: 20px;
      background-color: #ffffff;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    .review-label {
      margin: 10px 0;
    }
    .stars {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin: 10px 0;
    }
    .stars input {
      display: none;
    }
    .stars label {
      cursor: pointer;
      font-size: 24px;
      color: #ddd;
    }
    .stars input:checked ~ label {
      color: #FFD700;
    }
    button {
      padding: 10px 20px;
      border: none;
      background-color: #673AB7;
      color: white;
      border-radius: 5px;
      cursor: pointer;
      margin: 10px;
    }
    .review-btn {
      position: absolute;
      top: 70px;
      left: 10px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 5px;
      padding: 10px 20px;
      text-decoration: none;
      font-size: 16px;
      font-family: Arial, sans-serif;
      cursor: pointer;
      box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
    }
    .review-btn:hover {
      background-color: #45a049;
      box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3);
    }
    .annuler-btn {
      position: absolute;
      top: 20px;
      left: 10px;
      background-color: #ff4d4d;
      color: white;
      border: none;
      border-radius: 5px;
      padding: 10px 20px;
      text-decoration: none;
      font-size: 16px;
      font-family: Arial, sans-serif;
      cursor: pointer;
      box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
    }
    .annuler-btn:hover {
      background-color: #ff1a1a;
      box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3);
    }
    .refresh-btn {
      position: absolute;
      top: 130px;
      left: 10px;
      background-color: #2196F3;
      color: white;
      border: none;
      border-radius: 5px;
      padding: 10px 20px;
      text-decoration: none;
      font-size: 16px;
      font-family: Arial, sans-serif;
      cursor: pointer;
      box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
    }
    .refresh-btn:hover {
      background-color: #1e88e5;
      box-shadow: 3px 3px 8px rgba(0, 0, 0, 0.3);
    }
  </style>

</head>
<body>
<a href="index.html" class="annuler-btn">Log Out</a>
<a href="passengerprofile.jsp" class="review-btn">Back</a>
<a href="review.jsp" class="refresh-btn">Refresh</a>

<div class="header">
  Review Your Rides
</div>

<form method="post" action="review.jsp">
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
      int userId = 1;
      String reservationsQuery = "SELECT res.id AS reservation_id, r.id AS ride_id, r.start_point, r.destination, r.date_time, res.seats_reserved " +
              "FROM reservations res " +
              "JOIN rides r ON res.ride_id = r.id " +
              "WHERE res.user_id = ?";

      try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597");
           PreparedStatement ps = conn.prepareStatement(reservationsQuery)) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
          Timestamp rideDateTime = rs.getTimestamp("date_time");
          boolean isPastRide = rideDateTime.before(new java.util.Date());
    %>
    <tr>
      <td>
        <input type="checkbox" name="reservation_ids" value="<%= rs.getInt("reservation_id") %>" <% if (!isPastRide) { %>disabled<% } %> />
      </td>
      <td><%= rs.getInt("reservation_id") %></td>
      <td><%= rs.getInt("ride_id") %></td>
      <td><%= rs.getString("start_point") %></td>
      <td><%= rs.getString("destination") %></td>
      <td><%= rideDateTime %></td>
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

  <div class="review-container">
    <label class="review-label">Leave a Comment:</label><br>
    <textarea name="comment" rows="4" cols="50" placeholder="Write your review here..." required></textarea><br>

    <div class="stars">
      <input type="radio" id="star5" name="rating" value="5" required />
      <label for="star5">★</label>
      <input type="radio" id="star4" name="rating" value="4" />
      <label for="star4">★</label>
      <input type="radio" id="star3" name="rating" value="3" />
      <label for="star3">★</label>
      <input type="radio" id="star2" name="rating" value="2" />
      <label for="star2">★</label>
      <input type="radio" id="star1" name="rating" value="1" />
      <label for="star1">★</label>
    </div>

    <button type="submit" name="sendReview">Send Review</button>
  </div>
</form>

<%
  if (request.getMethod().equals("POST") && request.getParameter("sendReview") != null) {
    String[] selectedReservations = request.getParameterValues("reservation_ids");
    String comment = request.getParameter("comment");
    int rating = Integer.parseInt(request.getParameter("rating"));

    if (selectedReservations != null && comment != null && !comment.isEmpty()) {
      try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/carpooling", "root", "15971597")) {
        for (String reservationId : selectedReservations) {
          int reservationIdInt = Integer.parseInt(reservationId);


          try (PreparedStatement psGetRide = conn.prepareStatement(
                  "SELECT ride_id FROM reservations WHERE id = ?")) {
            psGetRide.setInt(1, reservationIdInt);
            ResultSet rs = psGetRide.executeQuery();
            if (rs.next()) {
              int rideId = rs.getInt("ride_id");


              try (PreparedStatement psInsert = conn.prepareStatement(
                      "INSERT INTO review (user_id, ride_id, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())")) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, rideId);
                psInsert.setInt(3, rating);
                psInsert.setString(4, comment);
                psInsert.executeUpdate();
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
