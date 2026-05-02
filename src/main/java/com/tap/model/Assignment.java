package com.tap.model;

import java.util.Date;

public class Assignment {
    private int assignmentId;
    private String moduleName;
    private String title;
    private String description;
    private Date dueDate;
    private int maxScore;

    public Assignment() {}

    public Assignment(int assignmentId, String moduleName, String title, String description, Date dueDate, int maxScore) {
        this.assignmentId = assignmentId;
        this.moduleName = moduleName;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.maxScore = maxScore;
    }

    // Getters and Setters
    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public int getMaxScore() { return maxScore; }
    public void setMaxScore(int maxScore) { this.maxScore = maxScore; }
}