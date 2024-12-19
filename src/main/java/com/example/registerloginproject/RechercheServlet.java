package com.example.registerloginproject;

// Jakarta EE (Servlets)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// SQL
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

// Other utilities (optional, depending on your needs)
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet("/RechercheServlet")
public class RechercheServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jdbcURL = "jdbc:mysql://localhost:3306/carpooling";
        String dbUser = "root";
        String dbPassword = "15971597";

        try {
            // Connect to database
            Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // SQL Query with JOIN to get driver name
            String sql = "SELECT r.id AS ride_id, u.name AS driver_name, r.start_point, r.destination, r.date_time, r.available_seats, r.price " +
                    "FROM rides r " +
                    "JOIN users u ON r.driver_id = u.id";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            // Store results in a list
            ArrayList<Ride> rides = new ArrayList<>();
            while (resultSet.next()) {
                Ride ride = new Ride();
                ride.setId(resultSet.getInt("ride_id"));
                ride.setDriverName(resultSet.getString("driver_name"));
                ride.setStartPoint(resultSet.getString("start_point"));
                ride.setDestination(resultSet.getString("destination"));
                ride.setDateTime(resultSet.getString("date_time"));
                ride.setAvailableSeats(resultSet.getInt("available_seats"));
                ride.setPrice(resultSet.getDouble("price"));
                rides.add(ride);
            }

            // Set rides in request scope
            request.setAttribute("rides", rides);

            // Close resources
            resultSet.close();
            statement.close();
            connection.close();

            // Forward to JSP
            request.getRequestDispatcher("ride_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error connecting to database or retrieving data.");
        }
    }
    public class Ride {
        private int id;
        private String driverName;
        private String startPoint;
        private String destination;
        private String dateTime;
        private int availableSeats;
        private double price;

        // Getters and setters
        public int getId() {
            return id;
        }
        public void setId(int id) {
            this.id = id;
        }
        public String getDriverName() {
            return driverName;
        }
        public void setDriverName(String driverName) {
            this.driverName = driverName;
        }
        public String getStartPoint() {
            return startPoint;
        }
        public void setStartPoint(String startPoint) {
            this.startPoint = startPoint;
        }
        public String getDestination() {
            return destination;
        }
        public void setDestination(String destination) {
            this.destination = destination;
        }
        public String getDateTime() {
            return dateTime;
        }
        public void setDateTime(String dateTime) {
            this.dateTime = dateTime;
        }
        public int getAvailableSeats() {
            return availableSeats;
        }
        public void setAvailableSeats(int availableSeats) {
            this.availableSeats = availableSeats;
        }
        public double getPrice() {
            return price;
        }
        public void setPrice(double price) {
            this.price = price;
        }
    }

}
