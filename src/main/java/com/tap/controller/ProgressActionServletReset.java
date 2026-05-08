package com.tap.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.tap.dao.ProgressDAO;

@WebServlet("/ProgressActionServlet")
public class ProgressActionServletReset extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Safety Fallback (Check your session name in login.jsp)
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action"); // 'reset' or 'complete'
        String tech = request.getParameter("tech");     // e.g. JAVA
        String task = request.getParameter("task");     // e.g. course_read
        
        ProgressDAO dao = new ProgressDAO();

        if ("reset".equals(action)) {
            dao.resetProgress(userId, tech.toUpperCase());
        } else if ("complete".equals(action)) {
            dao.updateProgress(userId, tech.toUpperCase(), task, 1);
        }

        // Send back to the learning path
        response.sendRedirect("myLearning.jsp");
    }
}