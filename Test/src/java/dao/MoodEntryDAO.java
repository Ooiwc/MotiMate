package dao;

import model.MoodEntry;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class MoodEntryDAO {
    // Valid mood names (lowercase for case-insensitive comparison)
    private static final Set<String> VALID_MOODS = new HashSet<>(Arrays.asList(
        "happy", "content", "neutral", "sad", "angry",
        "loved", "tired", "confused", "relaxed", "excited",
        "anxious", "bored", "sick", "frustrated", "worried"
    ));
    
    public boolean isValidMoodName(String customMood) {
        if (customMood == null || customMood.trim().isEmpty()) {
            return false;
        }
        return VALID_MOODS.contains(customMood.toLowerCase().trim());
    }
    
    public Integer getMoodIdByName(String moodName) {
        String sql = "SELECT MOOD_ID FROM MOODS WHERE LOWER(MOOD_NAME) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, moodName.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("MOOD_ID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addEntry(MoodEntry entry) {
        // If custom mood is provided, validate and convert to mood_id
        if (entry.getCustomMood() != null && !entry.getCustomMood().trim().isEmpty()) {
            if (!isValidMoodName(entry.getCustomMood())) {
                return false; // Invalid mood name
            }
            // Convert custom mood to mood_id
            Integer moodId = getMoodIdByName(entry.getCustomMood());
            if (moodId == null) {
                return false; // Mood not found in database
            }
            entry.setMoodId(moodId);
        }
        
        String sql = "INSERT INTO MOOD_ENTRIES (USER_ID, MOOD_ID, CUSTOM_MOOD, ENTRY_TITLE, JOURNAL_ENTRY) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, entry.getUserId());
            if (entry.getMoodId() != null) {
                stmt.setInt(2, entry.getMoodId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, entry.getCustomMood());
            stmt.setString(4, entry.getEntryTitle());
            stmt.setString(5, entry.getJournalEntry());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        entry.setEntryId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<MoodEntry> getUserEntries(int userId) {
        List<MoodEntry> entries = new ArrayList<>();
        String sql = "SELECT e.*, m.MOOD_NAME, m.EMOJI FROM MOOD_ENTRIES e " +
                    "LEFT JOIN MOODS m ON e.MOOD_ID = m.MOOD_ID " +
                    "WHERE e.USER_ID = ? ORDER BY e.ENTRY_DATE DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MoodEntry entry = new MoodEntry();
                    entry.setEntryId(rs.getInt("ENTRY_ID"));
                    entry.setUserId(rs.getInt("USER_ID"));
                    entry.setMoodId(rs.getInt("MOOD_ID"));
                    entry.setCustomMood(rs.getString("CUSTOM_MOOD"));
                    entry.setEntryTitle(rs.getString("ENTRY_TITLE"));
                    entry.setJournalEntry(rs.getString("JOURNAL_ENTRY"));
                    entry.setEntryDate(rs.getTimestamp("ENTRY_DATE"));
                    
                    // Get mood name and emoji from MOODS table
                    String moodName = rs.getString("MOOD_NAME");
                    String emoji = rs.getString("EMOJI");
                    if (moodName != null) {
                        entry.setDisplayMood(moodName);
                        entry.setDisplayEmoji(emoji);
                    } else {
                        entry.setDisplayMood(entry.getCustomMood());
                        entry.setDisplayEmoji("❓"); // Default emoji for unknown moods
                    }
                    
                    entries.add(entry);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return entries;
    }
    
    public boolean deleteEntry(int entryId, int userId) {
        String sql = "DELETE FROM MOOD_ENTRIES WHERE ENTRY_ID = ? AND USER_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entryId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public MoodEntry getEntry(int entryId, int userId) {
        String sql = "SELECT e.*, m.MOOD_NAME, m.EMOJI FROM MOOD_ENTRIES e " +
                    "LEFT JOIN MOODS m ON e.MOOD_ID = m.MOOD_ID " +
                    "WHERE e.ENTRY_ID = ? AND e.USER_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, entryId);
            stmt.setInt(2, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    MoodEntry entry = new MoodEntry();
                    entry.setEntryId(rs.getInt("ENTRY_ID"));
                    entry.setUserId(rs.getInt("USER_ID"));
                    entry.setMoodId(rs.getInt("MOOD_ID"));
                    entry.setCustomMood(rs.getString("CUSTOM_MOOD"));
                    entry.setEntryTitle(rs.getString("ENTRY_TITLE"));
                    entry.setJournalEntry(rs.getString("JOURNAL_ENTRY"));
                    entry.setEntryDate(rs.getTimestamp("ENTRY_DATE"));
                    
                    // Get mood name and emoji from MOODS table
                    String moodName = rs.getString("MOOD_NAME");
                    String emoji = rs.getString("EMOJI");
                    if (moodName != null) {
                        entry.setDisplayMood(moodName);
                        entry.setDisplayEmoji(emoji);
                    } else {
                        entry.setDisplayMood(entry.getCustomMood());
                        entry.setDisplayEmoji("❓"); // Default emoji for unknown moods
                    }
                    
                    return entry;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
} 