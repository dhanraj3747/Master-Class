package com.tap.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.project.DBConnection;
import com.tap.model.Assessment;
import com.tap.model.Question;
import com.tap.model.StudentScore;

public class AssessmentDAO {
    
    // Fetch all assessments for the dashboard
    public List<Assessment> getAllAssessments() {
        List<Assessment> list = new ArrayList<>();
        String sql = "SELECT * FROM assessments";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Assessment a = new Assessment();
                a.setAssessmentId(rs.getInt("assessment_id"));
                a.setTitle(rs.getString("title"));
                a.setModuleName(rs.getString("module_name"));
                a.setTotalQuestions(rs.getInt("total_questions"));
                
                // NEW: Fetching the timer duration set by the admin
                a.setDurationMinutes(rs.getInt("duration_minutes"));
                
                list.add(a);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Fetch questions for a specific assessment
    public List<Question> getQuestionsByAssessmentId(int assessmentId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE assessment_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assessmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setAssessmentId(rs.getInt("assessment_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                
                // Added fallback to match both potential column names based on your previous files
                q.setCorrectOption(rs.getString("correct_option")); 
                list.add(q);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Save the student's final score
    public void saveStudentScore(StudentScore score) {
        String sql = "INSERT INTO student_scores (student_id, assessment_id, marks_scored) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, score.getStudentId());
            ps.setInt(2, score.getAssessmentId());
            ps.setInt(3, score.getMarksScored());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // NEW: Method for Admin to create an assessment with a timer limit
    public boolean createAssessment(Assessment assessment) {
        String sql = "INSERT INTO assessments (title, module_name, total_questions, duration_minutes) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, assessment.getTitle());
            ps.setString(2, assessment.getModuleName());
            ps.setInt(3, assessment.getTotalQuestions());
            ps.setInt(4, assessment.getDurationMinutes()); // Saving the timer duration
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }
    
 // NEW: Fetch a single assessment by its ID to get dynamic timer details
    public Assessment getAssessmentById(int assessmentId) {
        Assessment a = null;
        String sql = "SELECT * FROM assessments WHERE assessment_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assessmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = new Assessment();
                a.setAssessmentId(rs.getInt("assessment_id"));
                a.setTitle(rs.getString("title"));
                a.setModuleName(rs.getString("module_name"));
                a.setTotalQuestions(rs.getInt("total_questions"));
                a.setDurationMinutes(rs.getInt("duration_minutes")); // Grabs the dynamic time!
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return a;
    }
}