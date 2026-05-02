package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.project.DBConnection; // Adjust this import if your DBConnection is in a different package
import com.tap.model.Assignment;
import com.tap.model.AssignmentQuestion;
import com.tap.model.StudentSubmission;

public class AssignmentDAO {

    // 1. Fetch all assignments to display on the assignment list/dashboard
    public List<Assignment> getAllAssignments() {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT * FROM assignments"; // Ensure your table name matches
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Assignment a = new Assignment();
                a.setAssignmentId(rs.getInt("assignment_id"));
                a.setTitle(rs.getString("title"));
                list.add(a);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 2. Fetch a specific assignment's details by its ID
    public Assignment getAssignmentById(int id) {
        Assignment a = null;
        String sql = "SELECT * FROM assignments WHERE assignment_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = new Assignment();
                a.setAssignmentId(rs.getInt("assignment_id"));
                a.setTitle(rs.getString("title"));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return a;
    }

    // 3. Fetch all questions for a specific assignment
    public List<AssignmentQuestion> getAssignmentQuestions(int assignmentId) {
        List<AssignmentQuestion> list = new ArrayList<>();
        String sql = "SELECT * FROM assignment_questions WHERE assignment_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssignmentQuestion q = new AssignmentQuestion();
                q.setQuestionId(rs.getInt("question_id"));
                q.setAssignmentId(rs.getInt("assignment_id"));
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

    // 4. Save a student's assignment score (Used by SubmitAssignmentServlet)
    public void saveSubmission(StudentSubmission sub) {
        String sql = "INSERT INTO student_submissions (student_id, assignment_id, marks_awarded) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sub.getStudentId());
            ps.setInt(2, sub.getAssignmentId());
            ps.setInt(3, sub.getMarksAwarded());
            ps.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

//    // 5. Delete a student's score history (Used by DeleteAssignmentScoreServlet)
//    public void deleteAssignmentScore(int studentId, int assignmentId) {
//        String sql = "DELETE FROM student_submissions WHERE student_id = ? AND assignment_id = ?";
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, studentId);
//            ps.setInt(2, assignmentId);
//            ps.executeUpdate();
//        } catch (Exception e) { 
//            e.printStackTrace(); 
//        }
//    }
}