package com.tap.dao;

import java.sql.*;
import java.util.*;
import com.project.DBConnection;
import com.tap.model.StudentProgressSummary;

/**
 * The "Brain" of the Admin Analytics Page.
 * Fetches unique data for all 6 students across 5 technologies.
 */
public class AdminAnalyticsDAO {

    /**
     * Main method to fetch the complete analytics list.
     * Logic: 1. Get unique students -> 2. Get 50/75/100% Progress -> 3. Get MCQ Marks -> 4. Get Task Marks.
     */
    public List<StudentProgressSummary> getAllStudentProgress() {
        List<StudentProgressSummary> studentList = new ArrayList<>();
        
        // This query ensures we only get the 6 unique students, preventing the "21 student" bug.
        String getStudentsSql = "SELECT id, name FROM users WHERE role = 'student'"; 

        try (Connection con = DBConnection.getConnection();
             PreparedStatement psStudents = con.prepareStatement(getStudentsSql);
             ResultSet rsStudents = psStudents.executeQuery()) {

            while (rsStudents.next()) {
                int studentId = rsStudents.getInt("id");
                String studentName = rsStudents.getString("name");

                // 1. Fetch % Progress Map (Uses the 50-25-25 formula)
                Map<String, Integer> progressMap = getDetailedProgress(con, studentId);

                // 2. Fetch Assessment Scores Map (Points from MCQ Quizzes)
                // Table: student_scores | Columns: user_id, technology, marks
                Map<String, Integer> assessMap = getTechScores(con, studentId, "student_scores", "marks", "user_id", "technology");

                // 3. Fetch Assignment Scores Map (Points from Uploaded Tasks)
                // Table: student_submissions | Columns: student_id, module, marks_awarded
                Map<String, Integer> assignMap = getTechScores(con, studentId, "student_submissions", "marks_awarded", "student_id", "module");

                // Add the fully populated student data to the list
                studentList.add(new StudentProgressSummary(studentId, studentName, progressMap, assessMap, assignMap));
            }
        } catch (Exception e) { 
            System.err.println("Fatal Error in AdminAnalyticsDAO: " + e.getMessage());
            e.printStackTrace(); 
        }
        return studentList;
    }

    /**
     * Calculates the % completion based on: 
     * Course Read (50%) + Assessment Done (25%) + Assignment Done (25%)
     */
    private Map<String, Integer> getDetailedProgress(Connection con, int studentId) {
        Map<String, Integer> map = new HashMap<>();
        String[] modules = {"JAVA", "HTML", "CSS", "JAVASCRIPT", "PYTHON"};
        
        // Initialize all technologies to 0% by default
        for (String m : modules) map.put(m, 0);

        String sql = "SELECT module, course_read, assessment_done, assignment_done FROM student_module_progress WHERE user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String modName = rs.getString("module").toUpperCase().trim();
                int percent = (rs.getInt("course_read") * 50) + 
                              (rs.getInt("assessment_done") * 25) + 
                              (rs.getInt("assignment_done") * 25);
                map.put(modName, percent);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return map;
    }

    /**
     * Universal helper to group raw scores by technology.
     * Used for both Assessment (Quizzes) and Submissions (Tasks).
     */
    private Map<String, Integer> getTechScores(Connection con, int studentId, String table, String markCol, String idCol, String techCol) {
        Map<String, Integer> map = new HashMap<>();
        
        // Dynamic SQL based on the table we are querying
        String sql = "SELECT " + techCol + ", SUM(" + markCol + ") FROM " + table + 
                     " WHERE " + idCol + " = ? GROUP BY " + techCol;
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String techName = rs.getString(1);
                if (techName != null) {
                    map.put(techName.toUpperCase().trim(), rs.getInt(2));
                }
            }
        } catch (SQLException e) { 
            // This will log if column names don't match the database fix
            System.err.println("Error querying scores from " + table + ": " + e.getMessage());
        }
        return map;
    }
}