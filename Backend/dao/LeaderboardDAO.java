package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.project.DBConnection; // Assuming this is your connection utility based on your screenshot
import com.tap.model.LeaderboardEntry;

public class LeaderboardDAO {

    public List<LeaderboardEntry> getTopStudents() {
        List<LeaderboardEntry> leaderboard = new ArrayList<>();
        
        // TODO: Change 'users', 'results', and their column names to match your exact MySQL tables!
        String query = "SELECT u.name AS studentName, IFNULL(SUM(s.marks_scored), 0) AS totalScore " +
                "FROM users u " +
                "LEFT JOIN student_scores s ON u.id = s.student_id " +
                "WHERE u.role = 'student' " +  // <-- THIS REMOVES THE ADMIN
                "GROUP BY u.id " +
                "ORDER BY totalScore DESC " +
                "LIMIT 6";

        try (Connection conn = DBConnection.getConnection(); // Use your existing DBConnection class
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            int currentRank = 1;

            while (rs.next()) {
                String name = rs.getString("studentName");
                int score = rs.getInt("totalScore");
                
                LeaderboardEntry entry = new LeaderboardEntry(currentRank, name, score);
                leaderboard.add(entry);
                
                currentRank++; // Increment rank for the next student
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

        return leaderboard;
    }
}