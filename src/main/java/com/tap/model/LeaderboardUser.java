package com.tap.model;

public class LeaderboardUser {
    private int rank;
    private String name;
    private int score;

    public LeaderboardUser(int rank, String name, int score) {
        this.rank = rank;
        this.name = name;
        this.score = score;
    }
    // Getters
    public int getRank() { return rank; }
    public String getName() { return name; }
    public int getScore() { return score; }
}