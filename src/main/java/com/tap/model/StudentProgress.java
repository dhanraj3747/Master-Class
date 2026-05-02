package com.tap.model;

public class StudentProgress {
    private int totalTasks;
    private int completedTasks;
    private int percentage;

    // Default Constructor
    public StudentProgress() {
    }

    // Parameterized Constructor
    public StudentProgress(int totalTasks, int completedTasks, int percentage) {
        this.totalTasks = totalTasks;
        this.completedTasks = completedTasks;
        this.percentage = percentage;
    }

    // Getters and Setters
    public int getTotalTasks() {
        return totalTasks;
    }

    public void setTotalTasks(int totalTasks) {
        this.totalTasks = totalTasks;
    }

    public int getCompletedTasks() {
        return completedTasks;
    }

    public void setCompletedTasks(int completedTasks) {
        this.completedTasks = completedTasks;
    }

    public int getPercentage() {
        return percentage;
    }

    public void setPercentage(int percentage) {
        this.percentage = percentage;
    }
}