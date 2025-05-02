package model;

import java.sql.Timestamp;

public class MoodEntry {
    private Integer entryId;
    private Integer userId;
    private Integer moodId;
    private String customMood;
    private String entryTitle;
    private String journalEntry;
    private Timestamp entryDate;
    private String displayMood;    // For displaying the mood name
    private String displayEmoji;   // For displaying the emoji

    public MoodEntry() {
    }

    // Getters and Setters
    public Integer getEntryId() {
        return entryId;
    }

    public void setEntryId(Integer entryId) {
        this.entryId = entryId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getMoodId() {
        return moodId;
    }

    public void setMoodId(Integer moodId) {
        this.moodId = moodId;
    }

    public String getCustomMood() {
        return customMood;
    }

    public void setCustomMood(String customMood) {
        this.customMood = customMood;
    }

    public String getEntryTitle() {
        return entryTitle;
    }

    public void setEntryTitle(String entryTitle) {
        this.entryTitle = entryTitle;
    }

    public String getJournalEntry() {
        return journalEntry;
    }

    public void setJournalEntry(String journalEntry) {
        this.journalEntry = journalEntry;
    }

    public Timestamp getEntryDate() {
        return entryDate;
    }

    public void setEntryDate(Timestamp entryDate) {
        this.entryDate = entryDate;
    }

    // New getters and setters for display fields
    public String getDisplayMood() {
        return displayMood;
    }

    public void setDisplayMood(String displayMood) {
        this.displayMood = displayMood;
    }

    public String getDisplayEmoji() {
        return displayEmoji;
    }

    public void setDisplayEmoji(String displayEmoji) {
        this.displayEmoji = displayEmoji;
    }
} 