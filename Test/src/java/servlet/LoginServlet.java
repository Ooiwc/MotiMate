package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.DBConnection;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt - Username: " + username);
        
        // Input validation
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Login failed: Empty username or password");
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Database authentication
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT USER_ID, USERNAME, EMAIL, FULL_NAME FROM APP.USERS WHERE USERNAME = ? AND PASSWORD = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    
                    System.out.println("Executing query for username: " + username);
                    
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            // Valid credentials - create User object
                            User user = new User();
                            user.setUserId(rs.getInt("USER_ID"));
                            user.setUsername(rs.getString("USERNAME"));
                            user.setEmail(rs.getString("EMAIL"));
                            user.setFullName(rs.getString("FULL_NAME"));
                            
                            // Create new session
                            HttpSession session = request.getSession();
                            session.setAttribute("user", user);
                            
                            System.out.println("Login successful for user: " + username);
                            
                            // Redirect to dashboard
                            response.sendRedirect("dashboard.jsp");
                            return;
                        } else {
                            System.out.println("Login failed - Invalid credentials for username: " + username);
                            request.setAttribute("error", "Invalid username or password");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            } catch (SQLException e) {
                System.out.println("Database error: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Database error occurred. Please try again later.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            System.out.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard.jsp");
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 