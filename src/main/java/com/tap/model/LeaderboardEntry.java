package com.tap.model;

public class LeaderboardEntry {
    private int rank;
    private String studentName;
    private int totalScore;

    // Constructors
    public LeaderboardEntry() {}

    public LeaderboardEntry(int rank, String studentName, int totalScore) {
        this.rank = rank;
        this.studentName = studentName;
        this.totalScore = totalScore;
    }

    // Getters and Setters
    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }
}