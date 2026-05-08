package com.tap.dao;

import java.sql.*;
import java.util.*;
import com.project.DBConnection; 
import com.tap.model.Question;

public class QuestionDAO {

    // =========================================================================
    // 1. CREATE / INSERT METHODS
    // =========================================================================

    public boolean batchInsertQuestions(List<Question> list) {
        String sql = "INSERT INTO questions (question_text, option_a, option_b, option_c, option_d, correct_option, folder_category, question_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            for (Question q : list) {
                ps.setString(1, q.getQuestionText().trim());
                ps.setString(2, q.getOptionA().trim());
                ps.setString(3, q.getOptionB().trim());
                ps.setString(4, q.getOptionC().trim());
                ps.setString(5, q.getOptionD().trim());
                ps.setString(6, q.getCorrectOption().trim()); 
                ps.setString(7, q.getFolderCategory().trim());
                ps.setString(8, q.getQuestionType().trim());
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    /**
     * PATH 1: For MCQ / Quiz Scores (Assessments)
     * Targets Table: student_scores
     */
    public void saveAssessmentScore(int userId, String tech, int score) {
        String sql = "INSERT INTO student_scores (user_id, technology, marks) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, tech.toUpperCase().trim());
            ps.setInt(3, score);
            
            ps.executeUpdate();
            System.out.println("Assessment Saved: User " + userId + " | Tech: " + tech + " | Marks: " + score);
        } catch (Exception e) {
            System.err.println("Error saving Assessment score: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * PATH 2: For Project / Task Scores (Assignments)
     * Targets Table: student_submissions
     */
    public void saveAssignmentScore(int userId, String tech, int marks) {
        // student_id and module match your latest table structure
        String sql = "INSERT INTO student_submissions (student_id, module, marks_awarded) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, tech.toUpperCase().trim());
            ps.setInt(3, marks);
            
            ps.executeUpdate();
            System.out.println("Assignment Saved: User " + userId + " | Tech: " + tech + " | Marks: " + marks);
        } catch (Exception e) {
            System.err.println("Error saving Assignment score: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // =========================================================================
    // 2. READ / FETCH METHODS
    // =========================================================================

    public List<Question> getDynamicQuestions(String tech, String type) {
        List<Question> list = new ArrayList<>();
        
        // Using TRIM and UPPER to ensure exact matching in the DB
        String sql = "SELECT * FROM questions WHERE TRIM(UPPER(folder_category)) = TRIM(UPPER(?)) AND TRIM(UPPER(question_type)) = TRIM(UPPER(?))";
        
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, tech != null ? tech : "");
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setCorrectOption(rs.getString("correct_option"));
                list.add(q);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public List<Question> getAllQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions ORDER BY question_id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while(rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setFolderCategory(rs.getString("folder_category"));
                q.setQuestionType(rs.getString("question_type"));
                q.setCorrectOption(rs.getString("correct_option"));
                list.add(q);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Question getQuestionById(int id) {
        Question q = null;
        String sql = "SELECT * FROM questions WHERE question_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setCorrectOption(rs.getString("correct_option"));
                q.setFolderCategory(rs.getString("folder_category"));
                q.setQuestionType(rs.getString("question_type"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return q;
    }

    // =========================================================================
    // 3. UPDATE & DELETE METHODS
    // =========================================================================

    public boolean updateQuestion(Question q) {
        String sql = "UPDATE questions SET question_text=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_option=? WHERE question_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectOption());
            ps.setInt(7, q.getQuestionId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteQuestion(int id) {
        String sql = "DELETE FROM questions WHERE question_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}