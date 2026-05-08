package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.DBConnection;

@WebServlet("/UpdateProgressServlet")
public class UpdateProgressServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String module = request.getParameter("module");
        String pStr = request.getParameter("percentage");
        int targetPercent = (pStr != null) ? Integer.parseInt(pStr) : -1;

        if (userId == null || module == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            if (targetPercent == 50) {
                // Just setting the course as "Taken"
                sql = "UPDATE student_module_progress SET course_read = 1 WHERE user_id = ? AND module = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, module);
                int rows = ps.executeUpdate();
                
                // If no row exists, create it
                if (rows == 0) {
                    String ins = "INSERT INTO student_module_progress (user_id, module, course_read, assessment_done, assignment_done) VALUES (?, ?, 1, 0, 0)";
                    PreparedStatement psIns = con.prepareStatement(ins);
                    psIns.setInt(1, userId);
                    psIns.setString(2, module);
                    psIns.executeUpdate();
                }
            } else if (targetPercent == 0) {
                // THE NUCLEAR RESET: Wipes all 3 progress parts to zero
                sql = "UPDATE student_module_progress SET course_read = 0, assessment_done = 0, assignment_done = 0 WHERE user_id = ? AND module = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setString(2, module);
                ps.executeUpdate();
                System.out.println("Reset successful for User: " + userId + " Module: " + module);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect based on the action
        if (targetPercent == 50) {
            response.sendRedirect("courseContent.jsp?tech=" + module);
        } else {
            response.sendRedirect("myLearning.jsp");
        }
    }
}