package com.tap.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.project.DBConnection;
import com.tap.model.Course;

public class CourseDao {

    public List<Course> getEnrolledCourses(int userId) {
        List<Course> courseList = new ArrayList<>();
        
        // Logic: We join student_data with scores and submissions to calculate dynamic 100% progress
        String query = "SELECT s.id, s.user_id, s.course, " +
                       "(SELECT COUNT(*) FROM student_scores sc WHERE sc.student_id = s.user_id AND sc.assessment_id = s.id) as assessment_status, " +
                       "(SELECT COUNT(*) FROM student_submissions sub WHERE sub.student_id = s.user_id AND sub.assignment_id = s.id) as assignment_status " +
                       "FROM student_data s WHERE s.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCourseName(rs.getString("course"));
                
                // Calculate Dynamic Progress
                int hasAssessment = rs.getInt("assessment_status"); // > 0 means done
                int hasAssignment = rs.getInt("assignment_status"); // > 0 means done
                
                int calcProgress = 0;
                if(hasAssessment > 0 && hasAssignment > 0) {
                    calcProgress = 100; // Only 100% if BOTH are done
                } else if (hasAssessment > 0 || hasAssignment > 0) {
                    calcProgress = 50; // Optional: 50% if only one is done
                }
                
                c.setCompletionPercentage(calcProgress);
                courseList.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }
}