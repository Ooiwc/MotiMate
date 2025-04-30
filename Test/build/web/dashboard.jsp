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
    <title>Dashboard - MotiMate</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dashboard.css">
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
                <li><a href="dashboard.jsp" class="active"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> <span>Profile</span></a></li>
                <li><a href="mood-tracker.jsp"><i class="fas fa-chart-line"></i> <span>Mood Tracker</span></a></li>
                <li><a href="goals.jsp"><i class="fas fa-bullseye"></i> <span>Goals</span></a></li>
                <li><a href="community.jsp"><i class="fas fa-users"></i> <span>Community</span></a></li>
                <li><a href="resources.jsp"><i class="fas fa-book"></i> <span>Resources</span></a></li>
            </ul>
        </aside>

        <main class="main-content">
            <h1 class="page-title">Dashboard</h1>
            
            <div class="dashboard-cards">
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3 class="card-title">Mood Tracker & Journal</h3>
                    <p class="card-description">Track your emotions and write journal entries to understand your emotional patterns.</p>
                    <a href="mood-tracker.jsp" class="card-link">Go to Mood Tracker <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-bullseye"></i>
                    </div>
                    <h3 class="card-title">Set and Track Goals</h3>
                    <p class="card-description">Create personal goals, track your progress, and stay motivated.</p>
                    <a href="goals.jsp" class="card-link">Go to Goals <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="card-title">Community Discussions</h3>
                    <p class="card-description">Connect with others, share experiences, and get support from the community.</p>
                    <a href="community.jsp" class="card-link">Go to Community <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="card">
                    <div class="card-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <h3 class="card-title">Resource Library</h3>
                    <p class="card-description">Access helpful resources, articles, and tools for mental well-being.</p>
                    <a href="resources.jsp" class="card-link">Go to Resources <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
            
            <div class="widget">
                <h3 class="widget-title">Daily Motivation</h3>
                <blockquote>
                    "The only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle."
                    <footer>— Steve Jobs</footer>
                </blockquote>
            </div>
            
            <div class="widget">
                <h3 class="widget-title">Your Recent Activity</h3>
                <p>No recent activity to show. Start tracking your mood or setting goals!</p>
            </div>
        </main>
    </div>

    <script src="js/main.js"></script>
</body>
</html>