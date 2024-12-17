package com.example.registerloginproject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve email and password
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = getUser(email, password);
            if (user != null) {
                // If authenticated, create session attribute and redirect user to appropriate profile
                HttpSession session = request.getSession();
                session.setAttribute("name", user.getName());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("role", user.getRole());

                if ("driver".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("driverprofile.jsp");
                } else if ("passenger".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("passengerprofile.jsp");
                } else {
                    out.print("Invalid role. Please contact support.");
                }
            } else {
                out.print("<h4>Sorry, email or password is incorrect!</h4>");
                request.getRequestDispatcher("index.html").include(request, response);
            }
        } catch (Exception e2) {
            e2.printStackTrace();
            out.print("An error occurred: " + e2.getMessage());
        }

        out.close();
    }

    private User getUser(String email, String password) throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/carpooling?characterEncoding=latin1&useConfigs=maxPerformance",
                "root",
                "15971597"
        );

        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return new User(rs.getString("name"), rs.getString("email"), rs.getString("password"), rs.getString("role"));
        } else {
            return null;
        }
    }
}

// Updated User class
class User {
    private String name;
    private String email;
    private String password;
    private String role;

    public User(String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }
}