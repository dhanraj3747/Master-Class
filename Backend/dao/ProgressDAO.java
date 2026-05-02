package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.project.DBConnection;
import com.tap.model.StudentProgress;

public class ProgressDAO {

    public StudentProgress getStudentProgress(int studentId) {
        StudentProgress progress = new StudentProgress();
        int totalTests = 0;
        int completedTests = 0;

        // Query 1: Get Total Number of Assessments Available
        // TODO: Update table name 'assessments' if yours is different
        String totalQuery = "SELECT COUNT(*) AS total FROM assessments";
        
        // Query 2: Get Number of Assessments Completed by this Student
        // TODO: Update table name 'results' and column 'student_id' if yours are different
        String completedQuery = "SELECT COUNT(*) AS completed FROM results WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            
            // Execute Total Query
            try (PreparedStatement pstmt1 = conn.prepareStatement(totalQuery);
                 ResultSet rs1 = pstmt1.executeQuery()) {
                if (rs1.next()) {
                    totalTests = rs1.getInt("total");
                }
            }

            // Execute Completed Query
            try (PreparedStatement pstmt2 = conn.prepareStatement(completedQuery)) {
                pstmt2.setInt(1, studentId);
                try (ResultSet rs2 = pstmt2.executeQuery()) {
                    if (rs2.next()) {
                        completedTests = rs2.getInt("completed");
                    }
                }
            }

            // Calculate percentage
            int percentage = 0;
            if (totalTests > 0) {
                percentage = (int) (((double) completedTests / totalTests) * 100);
            }

            // Set data into the model (You need to create the StudentProgress.java POJO if you haven't)
            progress.setTotalTasks(totalTests);
            progress.setCompletedTasks(completedTests);
            progress.setPercentage(percentage);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

        return progress;
    }
}