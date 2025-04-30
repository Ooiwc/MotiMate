package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;

@WebServlet(name = "SignupServlet", urlPatterns = {"/signup"})
public class SignupServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        
        System.out.println("Received signup request:");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        System.out.println("Email: " + email);
        System.out.println("Full Name: " + fullName);
        
        // Basic validation
        if (username == null || password == null || email == null || fullName == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || 
            email.trim().isEmpty() || fullName.trim().isEmpty()) {
            
            System.out.println("Validation failed: Empty fields");
            response.sendRedirect("signup.jsp?error=Please fill in all fields");
            return;
        }
        
        // Password confirmation check
        if (!password.equals(confirmPassword)) {
            System.out.println("Validation failed: Passwords don't match");
            response.sendRedirect("signup.jsp?error=Passwords do not match");
            return;
        }
        
        try {
            // Store plain password for testing
            String passwordToStore = password; // Store plain password instead of hash
            
            // Insert user into database
            try (Connection conn = DBConnection.getConnection()) {
                System.out.println("Database connection established");
                
                String sql = "INSERT INTO APP.USERS (USERNAME, PASSWORD, EMAIL, FULL_NAME) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, passwordToStore);
                    stmt.setString(3, email);
                    stmt.setString(4, fullName);
                    
                    System.out.println("Executing SQL: " + sql);
                    System.out.println("With values: " + username + ", " + passwordToStore + ", " + email + ", " + fullName);
                    
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        // Registration successful
                        System.out.println("Registration successful for user: " + username);
                        response.sendRedirect("login.jsp?success=Registration successful! Please login.");
                    } else {
                        System.out.println("Registration failed - no rows affected");
                        response.sendRedirect("signup.jsp?error=Registration failed");
                    }
                }
            } catch (SQLException e) {
                System.out.println("SQL Error: " + e.getMessage());
                e.printStackTrace();
                if (e.getMessage().contains("unique")) {
                    response.sendRedirect("signup.jsp?error=Username or email already exists");
                } else {
                    response.sendRedirect("signup.jsp?error=Database error occurred: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=An unexpected error occurred");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("signup.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 