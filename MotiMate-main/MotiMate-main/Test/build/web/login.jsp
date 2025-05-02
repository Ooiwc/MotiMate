<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MotiMate - Your Motivation Partner</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="login.jsp" class="logo">Moti<span>Mate</span></a>
            <a href="signup.jsp" class="btn">Sign Up</a>
        </div>
    </header>

    <div class="container">
        <div class="form-container">
            <h2 class="form-title">Log In to Your Account</h2>
            
            <!-- Show error message if any -->
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <button type="submit" class="btn btn-block">Log In</button>
                
                <div class="form-footer">
                    <p>Don't have an account? <a href="signup.jsp">Sign Up</a></p>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <div class="container">
            <p><center>&copy; 2025 MotiMate. All rights reserved.</center></p>
        </div>
    </footer>
</body>
</html> 