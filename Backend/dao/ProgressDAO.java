package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.project.DBConnection;
import com.tap.model.StudentProgress;

public class ProgressDAO {

    /**
     * Fetches the progress status for a specific student and module.
     * status[0] = Course Read, status[1] = Assessment Done, status[2] = Assignment Done
     */
    public int[] getModuleStatus(int userId, String module) {
        int[] status = {0, 0, 0}; 
        String sql = "SELECT course_read, assessment_done, assignment_done FROM student_module_progress WHERE user_id=? AND module=?";
        
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, module);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                status[0] = rs.getInt("course_read");
                status[1] = rs.getInt("assessment_done");
                status[2] = rs.getInt("assignment_done");
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return status;
    }

    /**
     * Updates progress for a specific student. 
     * If no record exists for this module, it automatically creates one (UPSERT logic).
     */
    public void updateProgress(int userId, String module, String column, int val) {
        // First try to update existing record
        String updateSql = "UPDATE student_module_progress SET " + column + "=? WHERE user_id=? AND module=?";
        
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setInt(1, val);
            ps.setInt(2, userId);
            ps.setString(3, module);
            
            int rowsAffected = ps.executeUpdate();
            
            // If the student doesn't have a record for this module yet, insert it
            if (rowsAffected == 0) {
                String insertSql = "INSERT INTO student_module_progress (user_id, module, " + column + ") VALUES (?, ?, ?)";
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setInt(1, userId);
                    psInsert.setString(2, module);
                    psInsert.setInt(3, val);
                    psInsert.executeUpdate();
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
    
    /**
     * Resets all progress for a specific module to 0.
     */
    public void resetProgress(int userId, String module) {
        String sql = "UPDATE student_module_progress SET course_read=0, assessment_done=0, assignment_done=0 WHERE user_id=? AND module=?";
        try (Connection con = DBConnection.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, module);
            ps.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    public StudentProgress getStudentProgress(int studentId) {
        // Placeholder for future implementation if needed
        return null;
    }
}