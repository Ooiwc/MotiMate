package dao;

import model.Mood;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MoodDAO {
    public List<Mood> getAllMoods() {
        List<Mood> moods = new ArrayList<>();
        String sql = "SELECT MOOD_ID, MOOD_NAME, DESCRIPTION, EMOJI, CREATED_AT FROM MOODS ORDER BY MOOD_ID";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Mood mood = new Mood();
                mood.setMoodId(rs.getInt("MOOD_ID"));
                mood.setMoodName(rs.getString("MOOD_NAME"));
                mood.setDescription(rs.getString("DESCRIPTION"));
                mood.setEmoji(rs.getString("EMOJI"));
                mood.setCreatedAt(rs.getTimestamp("CREATED_AT"));
                moods.add(mood);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Log the error or throw a custom exception
        }
        return moods;
    }
    
    public Mood getMoodById(int moodId) {
        String sql = "SELECT MOOD_ID, MOOD_NAME, DESCRIPTION, EMOJI, CREATED_AT FROM MOODS WHERE MOOD_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, moodId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Mood mood = new Mood();
                    mood.setMoodId(rs.getInt("MOOD_ID"));
                    mood.setMoodName(rs.getString("MOOD_NAME"));
                    mood.setDescription(rs.getString("DESCRIPTION"));
                    mood.setEmoji(rs.getString("EMOJI"));
                    mood.setCreatedAt(rs.getTimestamp("CREATED_AT"));
                    return mood;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Log the error or throw a custom exception
        }
        return null;
    }
    
    public String getMoodEmoji(Integer moodId) {
        if (moodId == null) return "📝"; // Default emoji for custom moods
        
        String sql = "SELECT EMOJI FROM MOODS WHERE MOOD_ID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, moodId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("EMOJI");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "❓"; // Default emoji if mood not found
    }
} 