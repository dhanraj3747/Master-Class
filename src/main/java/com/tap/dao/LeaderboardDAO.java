package com.tap.dao;

import java.sql.*;
import java.util.*;
import com.project.DBConnection;
import com.tap.model.LeaderboardUser;

public class LeaderboardDAO {

    public List<LeaderboardUser> getTopRankings() {
        List<LeaderboardUser> list = new ArrayList<>();
        // This query sums up the weighted progress across all modules per student
        String sql = "SELECT u.name, " +
                     "SUM((p.course_read * 50) + (p.assessment_done * 25) + (p.assignment_done * 25)) as total_score " +
                     "FROM users u " +
                     "LEFT JOIN student_module_progress p ON u.id = p.user_id " +
                     "WHERE u.role = 'student' " +
                     "GROUP BY u.id, u.name " +
                     "ORDER BY total_score DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int rank = 1;
            while (rs.next()) {
                list.add(new LeaderboardUser(
                    rank++, 
                    rs.getString("name"), 
                    rs.getInt("total_score")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        return list;
    }
}