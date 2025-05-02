package servlet;

import dao.MoodEntryDAO;
import dao.MoodDAO;
import model.Mood;
import model.MoodEntry;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MoodTrackingServlet", urlPatterns = {"/mood-tracking"})
public class MoodTrackingServlet extends HttpServlet {

    private MoodEntryDAO moodEntryDAO;
    private MoodDAO moodDAO;

    @Override
    public void init() throws ServletException {
        moodEntryDAO = new MoodEntryDAO();
        moodDAO = new MoodDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get all available moods for the dropdown
        List<Mood> moods = moodDAO.getAllMoods();
        request.setAttribute("moods", moods);

        // Get user's mood entries
        List<MoodEntry> entries = moodEntryDAO.getUserEntries(user.getUserId());
        request.setAttribute("entries", entries);

        request.getRequestDispatcher("mood-tracker.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Handle adding new mood entry
            MoodEntry entry = new MoodEntry();
            entry.setUserId(user.getUserId());
            
            String moodIdStr = request.getParameter("moodId");
            if (moodIdStr != null && !moodIdStr.isEmpty()) {
                entry.setMoodId(Integer.parseInt(moodIdStr));
            }
            
            entry.setCustomMood(request.getParameter("customMood"));
            entry.setEntryTitle(request.getParameter("entryTitle"));
            entry.setJournalEntry(request.getParameter("journalEntry"));
            
            if (moodEntryDAO.addEntry(entry)) {
                request.setAttribute("message", "Mood entry added successfully!");
            } else {
                request.setAttribute("error", "Failed to add mood entry.");
            }
        } else if ("update".equals(action)) {
            // Handle updating existing mood entry
            String entryIdStr = request.getParameter("entryId");
            if (entryIdStr != null && !entryIdStr.isEmpty()) {
                int entryId = Integer.parseInt(entryIdStr);
                MoodEntry entry = moodEntryDAO.getEntry(entryId, user.getUserId());
                if (entry != null) {
                    String moodIdStr = request.getParameter("moodId");
                    if (moodIdStr != null && !moodIdStr.isEmpty()) {
                        entry.setMoodId(Integer.parseInt(moodIdStr));
                    } else {
                        entry.setMoodId(null);
                    }
                    
                    entry.setCustomMood(request.getParameter("customMood"));
                    entry.setEntryTitle(request.getParameter("entryTitle"));
                    entry.setJournalEntry(request.getParameter("journalEntry"));
                    
                    if (moodEntryDAO.updateEntry(entry)) {
                        request.setAttribute("message", "Mood entry updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update mood entry.");
                    }
                } else {
                    request.setAttribute("error", "Entry not found or unauthorized access.");
                }
            } else {
                request.setAttribute("error", "Invalid entry ID.");
            }
        } else if ("delete".equals(action)) {
            // Handle deleting mood entry
            String entryIdStr = request.getParameter("entryId");
            if (entryIdStr != null && !entryIdStr.isEmpty()) {
                int entryId = Integer.parseInt(entryIdStr);
                if (moodEntryDAO.deleteEntry(entryId, user.getUserId())) {
                    request.setAttribute("message", "Mood entry deleted successfully!");
                } else {
                    request.setAttribute("error", "Failed to delete mood entry.");
                }
            }
        }

        // Reload entries to reflect changes
        List<MoodEntry> entries = moodEntryDAO.getUserEntries(user.getUserId());
        request.setAttribute("entries", entries);
        request.getRequestDispatcher("mood-tracker.jsp").forward(request, response);
    }
}