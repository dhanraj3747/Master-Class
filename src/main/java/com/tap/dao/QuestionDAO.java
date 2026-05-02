package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.project.DBConnection;
import com.tap.model.Question;

public class QuestionDAO {

    // This method takes the list of questions from your CSV and pushes them to MySQL in one go
   
public boolean batchInsertQuestions(List<Question> questionList) {
        
        // Notice we are strictly using 'correct_option' here to match your database
	String query = "INSERT IGNORE INTO questions (folder_category, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?)";
        boolean isSuccess = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            conn.setAutoCommit(false); 

            for (Question q : questionList) {
                pstmt.setString(1, q.getFolderCategory());
                pstmt.setString(2, q.getQuestionText());
                pstmt.setString(3, q.getOptionA());
                pstmt.setString(4, q.getOptionB());
                pstmt.setString(5, q.getOptionC());
                pstmt.setString(6, q.getOptionD());
                
                // Using getCorrectOption() to pull the data correctly
                pstmt.setString(7, q.getCorrectOption()); 
                
                pstmt.addBatch(); 
            }

            int[] results = pstmt.executeBatch(); 
            conn.commit(); 
            
            isSuccess = results.length > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isSuccess;
    }

//NEW: Fetch questions strictly by their Folder Category for the Practice Bank
public List<Question> getQuestionsByCategory(String category) {
    List<Question> list = new ArrayList<>();
    String query = "SELECT * FROM questions WHERE folder_category = ?";
    
    try (Connection conn = DBConnection.getConnection(); // Make sure your DB connection class name is correct
         PreparedStatement ps = conn.prepareStatement(query)) {
         
        ps.setString(1, category);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Question q = new Question();
            q.setQuestionId(rs.getInt("question_id"));
            q.setQuestionText(rs.getString("question_text"));
            q.setOptionA(rs.getString("option_a"));
            q.setOptionB(rs.getString("option_b"));
            q.setOptionC(rs.getString("option_c"));
            q.setOptionD(rs.getString("option_d"));
            
            // Note: Ensure this matches the exact getter/setter in your Question.java model
            q.setCorrectOption(rs.getString("correct_option")); 
            
            list.add(q);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}