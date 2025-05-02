<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        .entry-actions {
            display: flex;
            gap: 5px;
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

        .btn-danger, .btn-primary, .btn-info {
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-primary {
            background-color: #3498db;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-info {
            background-color: #17a2b8;
        }

        .btn-info:hover {
            background-color: #138496;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow: auto;
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 600px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            animation: modalopen 0.4s;
        }
        
        @keyframes modalopen {
            from {opacity: 0; transform: translateY(-60px);}
            to {opacity: 1; transform: translateY(0);}
        }
        
        .close-modal {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        
        .close-modal:hover,
        .close-modal:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        
        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        
        .modal-cancel {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .modal-cancel:hover {
            background-color: #5a6268;
        }
        
        .modal-confirm {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .modal-confirm:hover {
            background-color: #2980b9;
        }
        
        .modal-confirm-delete {
            background-color: #dc3545;
        }
        
        .modal-confirm-delete:hover {
            background-color: #c82333;
        }
        
        .modal-title {
            margin-top: 0;
            color: #2c3e50;
        }

        .view-entry-content p {
            margin: 10px 0;
            line-height: 1.6;
        }

        .edit-mood-options {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }

        .edit-mood-option {
            text-align: center;
            cursor: pointer;
            padding: 10px;
            border-radius: 8px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 2px solid transparent;
        }

        .edit-mood-option:hover {
            background: #f8f9fa;
        }

        .edit-mood-option.selected {
            background: #e3f2fd;
            border: 2px solid #3498db;
        }
    </style>
</head>
<body>
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
                        <div class="mood-option" data-mood-id="1" data-description="Your happiness lights up the room! Keep spreading that positive energy and joy to others." data-emoji="😃">
                            <div class="mood-emoji">😃</div>
                            <p>Happy</p>
                        </div>
                        <div class="mood-option" data-mood-id="2" data-description="Finding contentment is a beautiful thing. Cherish this peaceful moment and the harmony within." data-emoji="😊">
                            <div class="mood-emoji">😊</div>
                            <p>Content</p>
                        </div>
                        <div class="mood-option" data-mood-id="3" data-description="Sometimes being neutral gives us space to reflect. Take this moment to think about what would bring you joy." data-emoji="😐">
                            <div class="mood-emoji">😐</div>
                            <p>Neutral</p>
                        </div>
                        <div class="mood-option" data-mood-id="4" data-description="It's okay to feel sad. Your feelings are valid, and remember that this moment will pass. Reach out if you need support." data-emoji="😔">
                            <div class="mood-emoji">😔</div>
                            <p>Sad</p>
                        </div>
                        <div class="mood-option" data-mood-id="5" data-description="Anger shows you care deeply. Take deep breaths, process your emotions, and remember your peace is precious." data-emoji="😡">
                            <div class="mood-emoji">😡</div>
                            <p>Angry</p>
                        </div>
                        <div class="mood-option" data-mood-id="6" data-description="Being loved is one of life's greatest gifts. Cherish these moments and let them fill your heart with warmth." data-emoji="🥰">
                            <div class="mood-emoji">🥰</div>
                            <p>Loved</p>
                        </div>
                        <div class="mood-option" data-mood-id="7" data-description="Rest is essential for your wellbeing. Listen to your body and give yourself permission to recharge." data-emoji="😴">
                            <div class="mood-emoji">😴</div>
                            <p>Tired</p>
                        </div>
                        <div class="mood-option" data-mood-id="8" data-description="Confusion often leads to clarity. Take things one step at a time, and don't be afraid to ask for guidance." data-emoji="🤔">
                            <div class="mood-emoji">🤔</div>
                            <p>Confused</p>
                        </div>
                        <div class="mood-option" data-mood-id="9" data-description="Embracing relaxation is vital for your mental health. You deserve this peaceful moment." data-emoji="😌">
                            <div class="mood-emoji">😌</div>
                            <p>Relaxed</p>
                        </div>
                        <div class="mood-option" data-mood-id="10" data-description="Your enthusiasm is contagious! Channel this energy into making wonderful things happen." data-emoji="🤩">
                            <div class="mood-emoji">🤩</div>
                            <p>Excited</p>
                        </div>
                        <div class="mood-option" data-mood-id="11" data-description="Anxiety is temporary, but your strength is permanent. Focus on your breath and take things one moment at a time." data-emoji="😰">
                            <div class="mood-emoji">😰</div>
                            <p>Anxious</p>
                        </div>
                        <div class="mood-option" data-mood-id="12" data-description="Sometimes boredom can spark creativity. Use this moment to explore something new or revisit an old passion." data-emoji="🥱">
                            <div class="mood-emoji">🥱</div>
                            <p>Bored</p>
                        </div>
                        <div class="mood-option" data-mood-id="13" data-description="Taking care of your health is important. Give yourself time to rest and recover. You'll feel better soon." data-emoji="🤮">
                            <div class="mood-emoji">🤮</div>
                            <p>Sick</p>
                        </div>
                        <div class="mood-option" data-mood-id="14" data-description="Frustration shows you care about outcomes. Step back, breathe, and remember that every challenge makes you stronger." data-emoji="😤">
                            <div class="mood-emoji">😤</div>
                            <p>Frustrated</p>
                        </div>
                        <div class="mood-option" data-mood-id="15" data-description="Your concerns are valid. Remember that you've overcome challenges before, and you have the strength to face this too." data-emoji="🥺">
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
                        <button type="button" id="saveEntryBtn" class="btn btn-block">Save Entry</button>
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
                                    <div class="entry-actions">
                                        <button type="button" class="btn btn-small btn-info view-entry-btn" data-entry-id="default1">View</button>
                                        <button type="button" class="btn btn-small btn-primary edit-entry-btn" data-entry-id="default1">Edit</button>
                                        <button type="button" class="btn btn-small btn-danger delete-entry-btn" data-entry-id="default1">Delete</button>
                                    </div>
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
                                        <span class="entry-date"><fmt:formatDate value="${entry.entryDate}" pattern="yyyy-MM-dd" /></span>
                                        <div class="entry-actions">
                                            <button type="button" class="btn btn-small btn-info view-entry-btn" 
                                                    data-entry-id="${entry.entryId}"
                                                    data-mood-id="${entry.moodId}"
                                                    data-custom-mood="${entry.customMood}"
                                                    data-title="${entry.entryTitle}"
                                                    data-content="${entry.journalEntry}"
                                                    data-date="${entry.entryDate}"
                                                    data-emoji="${entry.displayEmoji}">View</button>
                                            <button type="button" class="btn btn-small btn-primary edit-entry-btn"
                                                    data-entry-id="${entry.entryId}"
                                                    data-mood-id="${entry.moodId}"
                                                    data-custom-mood="${entry.customMood}"
                                                    data-title="${entry.entryTitle}"
                                                    data-content="${entry.journalEntry}"
                                                    data-emoji="${entry.displayEmoji}">Edit</button>
                                            <button type="button" class="btn btn-small btn-danger delete-entry-btn" 
                                                    data-entry-id="${entry.entryId}">Delete</button>
                                        </div>
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
    
    <!-- Save Entry Confirmation Modal -->
    <div id="saveConfirmModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" id="closeSaveModal">×</span>
            <h3 class="modal-title">Save Journal Entry</h3>
            <p>Are you sure you want to save this mood and journal entry?</p>
            <div id="saveModalMoodDisplay"></div>
            <div class="modal-buttons">
                <button class="modal-cancel" id="cancelSave">Cancel</button>
                <button class="modal-confirm" id="confirmSave">Save Entry</button>
            </div>
        </div>
    </div>
    
    <!-- Delete Entry Confirmation Modal -->
    <div id="deleteConfirmModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" id="closeDeleteModal">×</span>
            <h3 class="modal-title">Delete Journal Entry</h3>
            <p>Are you sure you want to delete this entry? This action cannot be undone.</p>
            <div class="modal-buttons">
                <button class="modal-cancel" id="cancelDelete">Cancel</button>
                <button class="modal-confirm modal-confirm-delete" id="confirmDelete">Delete Entry</button>
            </div>
        </div>
    </div>
    
    <!-- View Entry Modal -->
    <div id="viewEntryModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" id="closeViewModal">×</span>
            <h3 class="modal-title">Journal Entry Details</h3>
            <div class="view-entry-content">
                <p><strong>Date:</strong> <span id="viewEntryDate"></span></p>
                <p><strong>Mood:</strong> <span id="viewEntryMood"></span></p>
                <p><strong>Title:</strong> <span id="viewEntryTitle"></span></p>
                <p><strong>Entry:</strong></p>
                <p id="viewEntryContent"></p>
            </div>
            <div class="modal-buttons">
                <button class="modal-cancel" id="closeView">Close</button>
            </div>
        </div>
    </div>
    
    <!-- Edit Entry Modal -->
    <div id="editEntryModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" id="closeEditModal">×</span>
            <h3 class="modal-title">Edit Journal Entry</h3>
            <form id="editEntryForm" action="mood-tracking" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="editEntryId" name="entryId">
                <div class="form-group">
                    <label for="editMoodId">Mood</label>
                    <div class="edit-mood-options">
                        <div class="edit-mood-option" data-mood-id="1" data-emoji="😃"><div class="mood-emoji">😃</div><p>Happy</p></div>
                        <div class="edit-mood-option" data-mood-id="2" data-emoji="😊"><div class="mood-emoji">😊</div><p>Content</p></div>
                        <div class="edit-mood-option" data-mood-id="3" data-emoji="😐"><div class="mood-emoji">😐</div><p>Neutral</p></div>
                        <div class="edit-mood-option" data-mood-id="4" data-emoji="😔"><div class="mood-emoji">😔</div><p>Sad</p></div>
                        <div class="edit-mood-option" data-mood-id="5" data-emoji="😡"><div class="mood-emoji">😡</div><p>Angry</p></div>
                        <div class="edit-mood-option" data-mood-id="6" data-emoji="🥰"><div class="mood-emoji">🥰</div><p>Loved</p></div>
                        <div class="edit-mood-option" data-mood-id="7" data-emoji="😴"><div class="mood-emoji">😴</div><p>Tired</p></div>
                        <div class="edit-mood-option" data-mood-id="8" data-emoji="🤔"><div class="mood-emoji">🤔</div><p>Confused</p></div>
                        <div class="edit-mood-option" data-mood-id="9" data-emoji="😌"><div class="mood-emoji">😌</div><p>Relaxed</p></div>
                        <div class="edit-mood-option" data-mood-id="10" data-emoji="🤩"><div class="mood-emoji">🤩</div><p>Excited</p></div>
                        <div class="edit-mood-option" data-mood-id="11" data-emoji="😰"><div class="mood-emoji">😰</div><p>Anxious</p></div>
                        <div class="edit-mood-option" data-mood-id="12" data-emoji="🥱"><div class="mood-emoji">🥱</div><p>Bored</p></div>
                        <div class="edit-mood-option" data-mood-id="13" data-emoji="🤮"><div class="mood-emoji">🤮</div><p>Sick</p></div>
                        <div class="edit-mood-option" data-mood-id="14" data-emoji="😤"><div class="mood-emoji">😤</div><p>Frustrated</p></div>
                        <div class="edit-mood-option" data-mood-id="15" data-emoji="🥺"><div class="mood-emoji">🥺</div><p>Worried</p></div>
                    </div>
                    <input type="hidden" id="editMoodId" name="moodId">
                    <input type="hidden" id="editEmoji" name="displayEmoji">
                </div>
                <div class="form-group">
                    <label for="editCustomMood">Or describe your mood:</label>
                    <input type="text" id="editCustomMood" name="customMood" class="form-control" placeholder="Example: Excited, Anxious...">
                </div>
                <div class="form-group">
                    <label for="editEntryTitle">Title</label>
                    <input type="text" id="editEntryTitle" name="entryTitle" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="editJournalEntry">Journal Entry</label>
                    <textarea id="editJournalEntry" name="journalEntry" class="form-control journal-textarea" required></textarea>
                </div>
                <div class="modal-buttons">
                    <button type="button" class="modal-cancel" id="cancelEdit">Cancel</button>
                    <button type="submit" class="modal-confirm">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Hidden form for delete submissions -->
    <form id="deleteEntryForm" action="mood-tracking" method="post" style="display: none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" id="deleteEntryId" name="entryId" value="">
    </form>

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
            const saveEntryBtn = document.getElementById('saveEntryBtn');
            
            // Modal elements
            const saveConfirmModal = document.getElementById('saveConfirmModal');
            const deleteConfirmModal = document.getElementById('deleteConfirmModal');
            const viewEntryModal = document.getElementById('viewEntryModal');
            const editEntryModal = document.getElementById('editEntryModal');
            const closeSaveModal = document.getElementById('closeSaveModal');
            const closeDeleteModal = document.getElementById('closeDeleteModal');
            const closeViewModal = document.getElementById('closeViewModal');
            const closeEditModal = document.getElementById('closeEditModal');
            const cancelSave = document.getElementById('cancelSave');
            const confirmSave = document.getElementById('confirmSave');
            const cancelDelete = document.getElementById('cancelDelete');
            const confirmDelete = document.getElementById('confirmDelete');
            const cancelEdit = document.getElementById('cancelEdit');
            const closeView = document.getElementById('closeView');
            const saveModalMoodDisplay = document.getElementById('saveModalMoodDisplay');
            const deleteEntryForm = document.getElementById('deleteEntryForm');
            const deleteEntryId = document.getElementById('deleteEntryId');
            
            // Entry buttons
            const deleteButtons = document.querySelectorAll('.delete-entry-btn');
            const viewButtons = document.querySelectorAll('.view-entry-btn');
            const editButtons = document.querySelectorAll('.edit-entry-btn');

            // Mood selection for new entry
            moodOptions.forEach(option => {
                option.addEventListener('click', function() {
                    moodOptions.forEach(opt => opt.classList.remove('selected'));
                    this.classList.add('selected');
                    selectedMoodIdInput.value = this.dataset.moodId;
                    customMoodInput.value = '';
                    showMotivationalQuote(this.dataset.description);
                });
            });

            customMoodInput.addEventListener('input', function(e) {
                const validMoods = ['happy', 'content', 'neutral', 'sad', 'angry',
                                  'loved', 'tired', 'confused', 'relaxed', 'excited',
                                  'anxious', 'bored', 'sick', 'frustrated', 'worried'];
                
                const customMood = e.target.value.toLowerCase().trim();
                
                if (customMood) {
                    moodOptions.forEach(opt => opt.classList.remove('selected'));
                    selectedMoodIdInput.value = '';
                }
                
                if (customMood && !validMoods.includes(customMood)) {
                    errorMessage.textContent = 'Please enter one of the valid moods: ' + validMoods.join(', ');
                    errorMessage.style.display = 'block';
                    e.target.setCustomValidity('Invalid mood');
                } else {
                    errorMessage.style.display = 'none';
                    e.target.setCustomValidity('');
                }
            });
            
            // Save Entry Button Click Handler
            saveEntryBtn.addEventListener('click', function() {
                const entryTitle = form.elements['entryTitle'].value;
                const journalEntry = form.elements['journalEntry'].value;
                
                if (!entryTitle || !journalEntry) {
                    errorMessage.textContent = 'Please fill in both the title and journal entry';
                    errorMessage.style.display = 'block';
                    return;
                }
                
                if (!selectedMoodIdInput.value && !customMoodInput.value) {
                    errorMessage.textContent = 'Please select a mood or enter your own description';
                    errorMessage.style.display = 'block';
                    return;
                }
                
                errorMessage.style.display = 'none';
                
                let moodDisplayHTML = '<p><strong>Mood:</strong> ';
                const selectedMood = document.querySelector('.mood-option.selected');
                if (selectedMood) {
                    const emoji = selectedMood.querySelector('.mood-emoji').textContent;
                    const moodText = selectedMood.querySelector('p').textContent;
                    moodDisplayHTML += `${emoji} ${moodText}</p>`;
                } else if (customMoodInput.value) {
                    moodDisplayHTML += `${customMoodInput.value}</p>`;
                }
                
                moodDisplayHTML += `<p><strong>Title:</strong> ${entryTitle}</p>`;
                saveModalMoodDisplay.innerHTML = moodDisplayHTML;
                
                saveConfirmModal.style.display = 'block';
            });
            
            // View Entry Button Click Handlers
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const entryId = this.dataset.entryId;
                    const moodId = this.dataset.moodId;
                    const customMood = this.dataset.customMood || '';
                    const title = this.dataset.title;
                    const content = this.dataset.content;
                    const date = this.dataset.date;
                    const emoji = this.dataset.emoji;

                    document.getElementById('viewEntryDate').textContent = new Date(date).toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                    });
                    document.getElementById('viewEntryMood').textContent = customMood || `${emoji} ${this.parentElement.parentElement.querySelector('.entry-mood h3').textContent}`;
                    document.getElementById('viewEntryTitle').textContent = title;
                    document.getElementById('viewEntryContent').textContent = content;

                    viewEntryModal.style.display = 'block';
                });
            });
            
            // Edit Entry Button Click Handlers
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const entryId = this.dataset.entryId;
                    const moodId = this.dataset.moodId;
                    const customMood = this.dataset.customMood || '';
                    const title = this.dataset.title;
                    const content = this.dataset.content;
                    const emoji = this.dataset.emoji;

                    // Populate edit form
                    document.getElementById('editEntryId').value = entryId;
                    document.getElementById('editEntryTitle').value = title;
                    document.getElementById('editJournalEntry').value = content;
                    document.getElementById('editCustomMood').value = customMood;
                    document.getElementById('editEmoji').value = emoji;

                    // Handle mood selection
                    const editMoodOptions = document.querySelectorAll('.edit-mood-option');
                    editMoodOptions.forEach(opt => opt.classList.remove('selected'));
                    if (moodId) {
                        const selectedOption = document.querySelector(`.edit-mood-option[data-mood-id="${moodId}"]`);
                        if (selectedOption) {
                            selectedOption.classList.add('selected');
                            document.getElementById('editMoodId').value = moodId;
                            document.getElementById('editEmoji').value = selectedOption.dataset.emoji;
                        }
                    } else if (customMood) {
                        document.getElementById('editMoodId').value = '';
                        document.getElementById('editEmoji').value = '📝'; // Default emoji for custom mood
                    }

                    // Mood selection for edit modal
                    editMoodOptions.forEach(option => {
                        option.addEventListener('click', function() {
                            editMoodOptions.forEach(opt => opt.classList.remove('selected'));
                            this.classList.add('selected');
                            document.getElementById('editMoodId').value = this.dataset.moodId;
                            document.getElementById('editEmoji').value = this.dataset.emoji;
                            document.getElementById('editCustomMood').value = '';
                        });
                    });

                    // Custom mood input for edit modal
                    document.getElementById('editCustomMood').addEventListener('input', function() {
                        if (this.value) {
                            editMoodOptions.forEach(opt => opt.classList.remove('selected'));
                            document.getElementById('editMoodId').value = '';
                            document.getElementById('editEmoji').value = '📝'; // Default emoji for custom mood
                        }
                    });

                    editEntryModal.style.display = 'block';
                });
            });
            
            // Delete Entry Button Click Handlers
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const entryId = this.getAttribute('data-entry-id');
                    deleteEntryId.value = entryId;
                    deleteConfirmModal.style.display = 'block';
                });
            });
            
            // Modal Close Handlers
            closeSaveModal.addEventListener('click', function() {
                saveConfirmModal.style.display = 'none';
            });
            
            closeDeleteModal.addEventListener('click', function() {
                deleteConfirmModal.style.display = 'none';
            });
            
            closeViewModal.addEventListener('click', function() {
                viewEntryModal.style.display = 'none';
            });
            
            closeEditModal.addEventListener('click', function() {
                editEntryModal.style.display = 'none';
            });
            
            cancelSave.addEventListener('click', function() {
                saveConfirmModal.style.display = 'none';
            });
            
            cancelDelete.addEventListener('click', function() {
                deleteConfirmModal.style.display = 'none';
            });
            
            closeView.addEventListener('click', function() {
                viewEntryModal.style.display = 'none';
            });
            
            cancelEdit.addEventListener('click', function() {
                editEntryModal.style.display = 'none';
            });
            
            // Confirm Save Handler
            confirmSave.addEventListener('click', function() {
                saveConfirmModal.style.display = 'none';
                
                let message = "Entry saved successfully! ";
                const selectedMood = document.querySelector('.mood-option.selected');
                if (selectedMood) {
                    message += selectedMood.dataset.description;
                } else if (customMoodInput.value) {
                    message += "Thank you for sharing your feelings. Every emotion you feel is valid and important.";
                }
                
                successMessage.textContent = message;
                successMessage.style.display = 'block';
                
                setTimeout(() => {
                    successMessage.style.display = 'none';
                }, 5000);
                
                form.submit();
            });
            
            // Confirm Delete Handler
            confirmDelete.addEventListener('click', function() {
                deleteConfirmModal.style.display = 'none';
                
                successMessage.textContent = "Entry deleted successfully.";
                successMessage.style.display = 'block';
                
                setTimeout(() => {
                    successMessage.style.display = 'none';
                }, 3000);
                
                deleteEntryForm.submit();
            });
            
            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                if (event.target === saveConfirmModal) {
                    saveConfirmModal.style.display = 'none';
                }
                if (event.target === deleteConfirmModal) {
                    deleteConfirmModal.style.display = 'none';
                }
                if (event.target === viewEntryModal) {
                    viewEntryModal.style.display = 'none';
                }
                if (event.target === editEntryModal) {
                    editEntryModal.style.display = 'none';
                }
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