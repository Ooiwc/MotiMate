<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>MotiMate - Mood Tracker & Journal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .mood-tracker-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .mood-selection-container {
            margin: 20px 0;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .mood-options {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 15px;
            padding: 20px;
        }
        
        .mood-option {
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s;
            padding: 15px;
            border-radius: 10px;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            min-width: auto;
            border: 2px solid transparent;
        }
        
        .mood-option:hover {
            background: #f8f9fa;
            transform: translateY(-5px);
        }
        
        .mood-option.selected {
            background: #e3f2fd;
            border: 2px solid #3498db;
        }
        
        .mood-emoji {
            font-size: 2rem;
            margin-bottom: 8px;
        }

        .custom-mood-input {
            margin-top: 20px;
            padding: 20px;
            border-top: 1px solid #eee;
        }

        .custom-mood-input input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 10px;
        }
        
        .journal-entry {
            margin-top: 30px;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .journal-textarea {
            min-height: 200px;
            resize: vertical;
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 10px;
        }

        .motivational-quote {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            border-radius: 5px;
        }

        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }

        .success-message {
            color: #28a745;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }

        .entries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .entry-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .entry-header {
            padding: 15px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
        }

        .entry-mood {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .mood-emoji {
            font-size: 24px;
        }

        .entry-meta {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .entry-date {
            color: #666;
            font-size: 0.9em;
        }

        .entry-content {
            padding: 15px;
        }

        .entry-content h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
        }

        .entry-content p {
            margin: 0;
            color: #666;
            line-height: 1.5;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <!-- Header and sidebar remain the same -->
    <header>
        <div class="container header-content">
            <a href="dashboard.jsp" class="logo">Moti<span>Mate</span></a>
            <div class="nav-links">
                <span class="welcome-text">Welcome, <%= user.getUsername() %></span>
                <a href="dashboard.jsp">Dashboard</a>
                <a href="profile.jsp">Profile</a>
                <a href="logout" class="btn">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard">
        <!-- Sidebar remains the same -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Navigation</h3>
            </div>
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fas fa-home"></i> <span>Dashboard</span></a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> <span>Profile</span></a></li>
                <li><a href="mood-tracker.jsp" class="active"><i class="fas fa-chart-line"></i> <span>Mood Tracker</span></a></li>
                <li><a href="goals.jsp"><i class="fas fa-bullseye"></i> <span>Goals</span></a></li>
                <li><a href="community.jsp"><i class="fas fa-users"></i> <span>Community</span></a></li>
                <li><a href="resources.jsp"><i class="fas fa-book"></i> <span>Resources</span></a></li>
            </ul>
        </aside>

        <main class="main-content">
            <h1 class="page-title">Mood Tracker & Journal</h1>
            <p>Track your mood and write in your journal to reflect on your day.</p>
            
            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <form id="moodEntryForm" action="mood-tracking" method="post">
                <input type="hidden" name="action" value="add">
                <div class="card mood-selection-container">
                    <h2>How are you feeling today?</h2>
                    <p>Choose an emoji or describe your mood in your own words</p>
                    
                    <div class="mood-options">
                        <!-- First row - Basic emotions -->
                        <div class="mood-option" data-mood-id="1" data-description="Your happiness lights up the room! Keep spreading that positive energy and joy to others.">
                            <div class="mood-emoji">😃</div>
                            <p>Happy</p>
                        </div>
                        <div class="mood-option" data-mood-id="2" data-description="Finding contentment is a beautiful thing. Cherish this peaceful moment and the harmony within.">
                            <div class="mood-emoji">😊</div>
                            <p>Content</p>
                        </div>
                        <div class="mood-option" data-mood-id="3" data-description="Sometimes being neutral gives us space to reflect. Take this moment to think about what would bring you joy.">
                            <div class="mood-emoji">😐</div>
                            <p>Neutral</p>
                        </div>
                        <div class="mood-option" data-mood-id="4" data-description="It's okay to feel sad. Your feelings are valid, and remember that this moment will pass. Reach out if you need support.">
                            <div class="mood-emoji">😔</div>
                            <p>Sad</p>
                        </div>
                        <div class="mood-option" data-mood-id="5" data-description="Anger shows you care deeply. Take deep breaths, process your emotions, and remember your peace is precious.">
                            <div class="mood-emoji">😡</div>
                            <p>Angry</p>
                        </div>
                        <!-- Second row - Additional emotions -->
                        <div class="mood-option" data-mood-id="6" data-description="Being loved is one of life's greatest gifts. Cherish these moments and let them fill your heart with warmth.">
                            <div class="mood-emoji">🥰</div>
                            <p>Loved</p>
                        </div>
                        <div class="mood-option" data-mood-id="7" data-description="Rest is essential for your wellbeing. Listen to your body and give yourself permission to recharge.">
                            <div class="mood-emoji">😴</div>
                            <p>Tired</p>
                        </div>
                        <div class="mood-option" data-mood-id="8" data-description="Confusion often leads to clarity. Take things one step at a time, and don't be afraid to ask for guidance.">
                            <div class="mood-emoji">🤔</div>
                            <p>Confused</p>
                        </div>
                        <div class="mood-option" data-mood-id="9" data-description="Embracing relaxation is vital for your mental health. You deserve this peaceful moment.">
                            <div class="mood-emoji">😌</div>
                            <p>Relaxed</p>
                        </div>
                        <div class="mood-option" data-mood-id="10" data-description="Your enthusiasm is contagious! Channel this energy into making wonderful things happen.">
                            <div class="mood-emoji">🤩</div>
                            <p>Excited</p>
                        </div>
                        <!-- Third row - More emotions -->
                        <div class="mood-option" data-mood-id="11" data-description="Anxiety is temporary, but your strength is permanent. Focus on your breath and take things one moment at a time.">
                            <div class="mood-emoji">😰</div>
                            <p>Anxious</p>
                        </div>
                        <div class="mood-option" data-mood-id="12" data-description="Sometimes boredom can spark creativity. Use this moment to explore something new or revisit an old passion.">
                            <div class="mood-emoji">🥱</div>
                            <p>Bored</p>
                        </div>
                        <div class="mood-option" data-mood-id="13" data-description="Taking care of your health is important. Give yourself time to rest and recover. You'll feel better soon.">
                            <div class="mood-emoji">🤮</div>
                            <p>Sick</p>
                        </div>
                        <div class="mood-option" data-mood-id="14" data-description="Frustration shows you care about outcomes. Step back, breathe, and remember that every challenge makes you stronger.">
                            <div class="mood-emoji">😤</div>
                            <p>Frustrated</p>
                        </div>
                        <div class="mood-option" data-mood-id="15" data-description="Your concerns are valid. Remember that you've overcome challenges before, and you have the strength to face this too.">
                            <div class="mood-emoji">🥺</div>
                            <p>Worried</p>
                        </div>
                    </div>

                    <div class="custom-mood-input">
                        <h3>Or describe your mood in your own words:</h3>
                        <input type="text" id="customMood" name="customMood" placeholder="Example: Excited, Anxious, Peaceful...">
                    </div>

                    <input type="hidden" id="selectedMoodId" name="moodId">
                </div>
                
                <div class="card journal-entry">
                    <h2>Journal Entry</h2>
                    <div class="entry-date">
                        <p>Date: <span id="currentDate"></span></p>
                    </div>
                    <div class="form-group">
                        <input type="text" name="entryTitle" class="form-control" placeholder="Entry Title" required>
                    </div>
                    <div class="form-group">
                        <textarea name="journalEntry" class="form-control journal-textarea" 
                                placeholder="Write your thoughts here..." required></textarea>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-block">Save Entry</button>
                    </div>
                </div>
            </form>

            <div class="motivational-quote" id="motivationalQuote" style="display: none;">
                <h3>Daily Motivation</h3>
                <p id="quoteText"></p>
            </div>
            
            <!-- Display past entries -->
            <div class="entries-grid">
                <c:choose>
                    <c:when test="${empty entries}">
                        <!-- Default entries -->
                        <div class="card entry-card">
                            <div class="entry-header">
                                <div class="entry-mood">
                                    <span class="mood-emoji">😊</span>
                                    <h3>Happy</h3>
                                </div>
                                <div class="entry-meta">
                                    <span class="entry-date">Sample Entry</span>
                                    <form action="mood-tracking" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="entryId" value="default1">
                                        <button type="submit" class="btn btn-small btn-danger">Delete</button>
                                    </form>
                                </div>
                            </div>
                            <div class="entry-content">
                                <h4>Welcome to MoodMate!</h4>
                                <p>This is a sample entry. Start tracking your moods by adding your own entries above.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Display actual user entries -->
                        <c:forEach items="${entries}" var="entry">
                            <div class="card entry-card">
                                <div class="entry-header">
                                    <div class="entry-mood">
                                        <span class="mood-emoji">${entry.displayEmoji}</span>
                                        <h3>${entry.displayMood}</h3>
                                    </div>
                                    <div class="entry-meta">
                                        <span class="entry-date">${entry.entryDate}</span>
                                        <form action="mood-tracking" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="entryId" value="${entry.entryId}">
                                            <button type="submit" class="btn btn-small btn-danger">Delete</button>
                                        </form>
                                    </div>
                                </div>
                                <div class="entry-content">
                                    <h4>${entry.entryTitle}</h4>
                                    <p>${entry.journalEntry}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set current date
            const now = new Date();
            document.getElementById('currentDate').textContent = now.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            
            // Mood selection handling
            const moodOptions = document.querySelectorAll('.mood-option');
            const customMoodInput = document.getElementById('customMood');
            const selectedMoodIdInput = document.getElementById('selectedMoodId');
            const errorMessage = document.getElementById('errorMessage');
            const successMessage = document.getElementById('successMessage');
            const form = document.getElementById('moodEntryForm');

            moodOptions.forEach(option => {
                option.addEventListener('click', function() {
                    moodOptions.forEach(opt => opt.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedMoodIdInput.value = this.dataset.moodId;
                    customMoodInput.value = ''; // Clear custom mood when emoji is selected
                    showMotivationalQuote(this.dataset.description);
                });
            });

            customMoodInput.addEventListener('input', function(e) {
                const validMoods = ['happy', 'content', 'neutral', 'sad', 'angry',
                                  'loved', 'tired', 'confused', 'relaxed', 'excited',
                                  'anxious', 'bored', 'sick', 'frustrated', 'worried'];
                
                const customMood = e.target.value.toLowerCase().trim();
                
                if (customMood && !validMoods.includes(customMood)) {
                    errorMessage.textContent = 'Please enter one of the valid moods: ' + validMoods.join(', ');
                    errorMessage.style.display = 'block';
                    e.target.setCustomValidity('Invalid mood');
                } else {
                    errorMessage.style.display = 'none';
                    e.target.setCustomValidity('');
                }
            });

            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                if (!selectedMoodIdInput.value && !customMoodInput.value) {
                    errorMessage.textContent = 'Please select a mood or enter your own description';
                    errorMessage.style.display = 'block';
                    return;
                }

                // Show success message with the encouraging message
                let message = "Entry saved successfully! ";
                const selectedMood = document.querySelector('.mood-option.selected');
                if (selectedMood) {
                    message += selectedMood.dataset.description;
                } else if (customMoodInput.value) {
                    message += "Thank you for sharing your feelings. Every emotion you feel is valid and important.";
                }
                
                successMessage.textContent = message;
                successMessage.style.display = 'block';
                
                // Hide success message after 5 seconds
                setTimeout(() => {
                    successMessage.style.display = 'none';
                }, 5000);

                this.submit();
            });
        });

        function showMotivationalQuote(message) {
            const quoteContainer = document.getElementById('motivationalQuote');
            const quoteText = document.getElementById('quoteText');
            quoteText.textContent = message;
            quoteContainer.style.display = 'block';
        }
    </script>
</body>
</html> 