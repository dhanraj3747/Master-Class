package com.tap.model;

public class Course {
    private int id;
    private int userId;
    private String courseName;
    private int completionPercentage; // Track progression
    private int marks;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public int getCompletionPercentage() { return completionPercentage; }
    public void setCompletionPercentage(int completionPercentage) { this.completionPercentage = completionPercentage; }
    
    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }
}