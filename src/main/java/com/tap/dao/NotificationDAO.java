package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp; 
import java.util.ArrayList;
import java.util.List;
import com.project.DBConnection;
import com.tap.model.Notification;

public class NotificationDAO {

    /**
     * The Fix: Changed rs.getInt("id") to rs.getInt("notification_id")
     * Logic: Fetches only unread notifications from the last 5 minutes.
     */
    public List<Notification> getUnreadNotifications(int studentId) {
        List<Notification> list = new ArrayList<>();
        
        String sql = "SELECT * FROM notifications " +
                     "WHERE student_id = ? AND is_read = 0 " +
                     "AND created_at >= NOW() - INTERVAL 5 MINUTE " +
                     "ORDER BY created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                // THE CULPRIT WAS HERE: rs.getInt("id") is now rs.getInt("notification_id")
                list.add(new Notification(
                    rs.getInt("notification_id"), 
                    rs.getInt("student_id"),
                    rs.getString("file_name"),
                    rs.getString("upload_type"),
                    rs.getString("topic_folder"),
                    rs.getBoolean("is_read"),
                    rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            System.err.println("Error fetching notifications: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Broadcasts detailed notifications to all students in a single batch.
     */
    public void sendNotificationToAll(String fileName, String uploadType, String topicFolder) {
        int[] allStudentIds = {1, 2, 3, 4, 5, 6}; 
        String sql = "INSERT INTO notifications (student_id, file_name, upload_type, topic_folder, is_read, created_at) " +
                     "VALUES (?, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            con.setAutoCommit(false); // Optimization for batch processing
            
            for (int id : allStudentIds) {
                pstmt.setInt(1, id);
                pstmt.setString(2, fileName);
                pstmt.setString(3, uploadType);
                pstmt.setString(4, topicFolder);
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            con.commit();
            System.out.println("Batch notifications sent successfully for: " + fileName);
            
        } catch (Exception e) {
            System.err.println("Error sending batch notifications: " + e.getMessage());
            e.printStackTrace();
        }
    }
}