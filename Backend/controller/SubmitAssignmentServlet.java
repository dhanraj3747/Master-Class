package com.tap.controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.tap.dao.AssignmentDAO;
import com.tap.model.*;

@WebServlet("/submitAssignment")
public class SubmitAssignmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("userId");
        
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        List<AssignmentQuestion> questions = (List<AssignmentQuestion>) session.getAttribute("currentAssignmentQuestions");
        
        int score = 0;
        Map<Integer, String> userAnswers = new HashMap<>();
        
        for (AssignmentQuestion q : questions) {
            String ans = request.getParameter("q_" + q.getQuestionId());
            userAnswers.put(q.getQuestionId(), ans != null ? ans : "None");
            if (ans != null && ans.equals(q.getCorrectOption())) score++;
        }

        StudentSubmission sub = new StudentSubmission();
        sub.setStudentId(studentId);
        sub.setAssignmentId(assignmentId);
        sub.setMarksAwarded(score);
        
        new AssignmentDAO().saveSubmission(sub);

        request.setAttribute("finalScore", score);
        request.setAttribute("totalQuestions", questions.size());
        request.setAttribute("questionsList", questions);
        request.setAttribute("userAnswers", userAnswers);
        request.getRequestDispatcher("assignment_result.jsp").forward(request, response);
    }
}