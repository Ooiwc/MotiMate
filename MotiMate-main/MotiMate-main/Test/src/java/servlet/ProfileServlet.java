/*package servlet;

import com.google.gson.JsonObject;
import dao.UserDAO;
import model.User;
import util.PasswordHasher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Get the current user from session
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "User not logged in");
                out.print(jsonResponse.toString());
                return;
            }

            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String bio = request.getParameter("bio");
            String newPassword = request.getParameter("newPassword");
            boolean emailNotifications = "on".equals(request.getParameter("emailNotifications"));
            boolean dailyReminders = "on".equals(request.getParameter("dailyReminders"));

            // Update user object
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setBio(bio);
            currentUser.setEmailNotifications(emailNotifications);
            currentUser.setDailyReminders(dailyReminders);

            // Handle password update if provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                String hashedPassword = PasswordHasher.hashPassword(newPassword);
                currentUser.setPassword(hashedPassword);
            }

            // Update in database
            boolean updated = userDAO.updateUser(currentUser);

            if (updated) {
                // Update session with new user data
                request.getSession().setAttribute("user", currentUser);
                
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Profile updated successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update profile");
            }

        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "An error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(jsonResponse.toString());
    }
} 

*/