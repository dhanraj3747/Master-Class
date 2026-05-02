package com.tap.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.dao.ProgressDAO;
import com.tap.model.StudentProgress;

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Ensure user is logged in
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the logged-in student's ID (adjust "studentId" based on what you named it in LoginServlet)
        int studentId = (int) session.getAttribute("studentId");

        // Fetch progress data
        ProgressDAO progressDAO = new ProgressDAO();
        StudentProgress progress = progressDAO.getStudentProgress(studentId);

        // Send data to the JSP
        request.setAttribute("progress", progress);

        // Forward to the student dashboard
        RequestDispatcher dispatcher = request.getRequestDispatcher("studentDashboard.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}