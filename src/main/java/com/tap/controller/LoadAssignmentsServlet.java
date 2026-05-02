package com.tap.controller;

import com.tap.dao.AssignmentDAO;
import com.tap.model.Assignment;
import com.tap.model.AssignmentQuestion;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/assignments")
public class LoadAssignmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AssignmentDAO assignmentDAO;

    public void init() {
        assignmentDAO = new AssignmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            // 1. User clicked an assignment, so load the MCQ test
            int assignmentId = Integer.parseInt(request.getParameter("id"));
            Assignment assignment = assignmentDAO.getAssignmentById(assignmentId);
            List<AssignmentQuestion> questions = assignmentDAO.getAssignmentQuestions(assignmentId);
            
            request.getSession().setAttribute("currentAssignmentQuestions", questions);
            request.setAttribute("assignment", assignment);
            request.setAttribute("questions", questions); 
            request.getRequestDispatcher("assignment_detail.jsp").forward(request, response);
            
        } else {
            // 2. THIS IS WHAT WAS MISSING! Load the main dashboard grid
            List<Assignment> listAssignments = assignmentDAO.getAllAssignments();
            request.setAttribute("listAssignments", listAssignments);
            request.getRequestDispatcher("assignment_dashboard.jsp").forward(request, response);
        }
    }
}