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
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve name, email, password, and role
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/carpooling?characterEncoding=latin1&useConfigs=maxPerformance",
                    "root",
                    "15971597"
            );

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int i = ps.executeUpdate();
            if (i > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("name", name);
                session.setAttribute("email", email);
                session.setAttribute("role", role);

                if ("driver".equalsIgnoreCase(role)) {
                    response.sendRedirect("driverprofile.jsp");
                } else if ("passenger".equalsIgnoreCase(role)) {
                    response.sendRedirect("passengerprofile.jsp");
                } else {
                    out.print("Invalid role. Please try again.");
                }
            } else {
                out.print("Registration failed. Please try again.");
                request.getRequestDispatcher("index.html").include(request, response);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.print("An error occurred: " + e.getMessage());
        }

        out.close();
    }
}
