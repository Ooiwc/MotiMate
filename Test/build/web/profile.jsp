<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - MotiMate</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <style>
        .profile-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #3498db;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: #fff;
            font-size: 40px;
        }
        
        .profile-info h2 {
            margin-bottom: 5px;
            color: #2c3e50;
        }
        
        .profile-info p {
            color: #7f8c8d;
        }
        
        .profile-section {
            margin-bottom: 25px;
        }
        
        .profile-section h3 {
            margin-bottom: 15px;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .btn-save {
            background-color: #2ecc71;
        }
        
        .btn-save:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="dashboard.jsp" class="logo">Moti<span>Mate</span></a>
            <div>
                <span>Welcome, <%= user.getUsername() %></span>
                <a href="logout" class="btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Navigation</h3>
            </div>
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
                <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i> <span>Profile</span></a></li>
                <li><a href="mood-tracker.jsp"><i class="fas fa-chart-line"></i> <span>Mood Tracker</span></a></li>
                <li><a href="goals.jsp"><i class="fas fa-bullseye"></i> <span>Goals</span></a></li>
                <li><a href="community.jsp"><i class="fas fa-users"></i> <span>Community</span></a></li>
                <li><a href="resources.jsp"><i class="fas fa-book"></i> <span>Resources</span></a></li>
            </ul>
        </aside>

        <main class="main-content">
            <h1 class="page-title">Your Profile</h1>
            
            <!-- Success message if any -->
            <% if(request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    Profile updated successfully!
                </div>
            <% } %>
            
            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-image">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-info">
                        <h2><%= user.getUsername() %></h2>
                        <p>Member since: January 2025</p>
                    </div>
                </div>
                
                <form action="UpdateProfileServlet" method="post">
                    <div class="profile-section">
                        <h3>Personal Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullname">Full Name</label>
                                <input type="text" id="fullname" name="fullname" class="form-control" value="John Doe">
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="john.doe@example.com">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="bio">Bio</label>
                            <textarea id="bio" name="bio" class="form-control" rows="4" placeholder="Tell us about yourself..."></textarea>
                        </div>
                    </div>
                    
                    <div class="profile-section">
                        <h3>Account Settings</h3>
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Leave blank to keep current password">
                        </div>
                        <div class="form-group">
                            <label for="confirmNewPassword">Confirm New Password</label>
                            <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control" placeholder="Confirm new password">
                        </div>
                    </div>
                    
                    <div class="profile-section">
                        <h3>Notification Preferences</h3>
                        <div class="form-group">
                            <input type="checkbox" id="emailNotif" name="emailNotif" checked>
                            <label for="emailNotif">Email notifications</label>
                        </div>
                        <div class="form-group">
                            <input type="checkbox" id="reminderNotif" name="reminderNotif" checked>
                            <label for="reminderNotif">Daily reminders</label>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-save">Save Changes</button>
                </form>
            </div>
        </main>
    </div>

    <script src="js/main.js"></script>
</body>
</html>