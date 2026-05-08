package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.dao.QuestionDAO;
import com.tap.dao.ProgressDAO;
import com.tap.model.Question;
import com.tap.model.QuestionResult;

@WebServlet("/submitAssignment")
public class SubmitAssignmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // 1. Session Protection: Secure the route for logged-in students only
        Integer studentId = (Integer) session.getAttribute("userId");
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Extract Request Parameters
        String folderTech = request.getParameter("folder"); // e.g., "JAVA", "HTML"
        String timeSpent = request.getParameter("timeSpent"); 
        
        QuestionDAO qDao = new QuestionDAO();
        
        // 3. Dynamic Question Retrieval (Specifically for 'Assignment' type)
        List<Question> questions = qDao.getDynamicQuestions(folderTech, "Assignment");
        
        int score = 0;
        List<QuestionResult> reviewList = new ArrayList<>();

        // 4. THE INDESTRUCTIBLE SCORING ENGINE (For Assignments)
        if (questions != null && !questions.isEmpty()) {
            for (Question q : questions) {
                String selectedVal = request.getParameter("q_" + q.getQuestionId());
                String correctVal = q.getCorrectOption();
                boolean isCorrect = false;

                if (selectedVal != null && correctVal != null) {
                    // Normalize strings: remove all whitespace and lowercase for perfect comparison
                    String cleanSelected = selectedVal.replaceAll("\\s+", "").toLowerCase();
                    String cleanCorrect = correctVal.replaceAll("\\s+", "").toLowerCase();

                    if (cleanSelected.equals(cleanCorrect)) {
                        score++;
                        isCorrect = true;
                    }
                }
                
                reviewList.add(new QuestionResult(
                    q.getQuestionText(), 
                    (selectedVal != null ? selectedVal : "Skipped"), 
                    correctVal, 
                    isCorrect
                ));
            }
        }

        // 5. DATABASE UPDATES (THE CRITICAL FIXES)
        int totalQuestions = (questions != null) ? questions.size() : 0;
        String techKey = (folderTech != null) ? folderTech.toUpperCase().trim() : "GENERAL";

        // THE FIX: Directing the score to the ASSIGNMENT-specific method
        // This ensures points go to 'student_submissions' table, NOT the quiz table
        qDao.saveAssignmentScore(studentId, techKey, score);

        // Update the Progress Dashboard (Adds the final 25% to reach 100% completion)
        ProgressDAO progressDao = new ProgressDAO();
        progressDao.updateProgress(studentId, techKey, "assignment_done", 1);

        // 6. Forward Data to Result Summary
        int accuracy = (totalQuestions > 0) ? (int)(((double) score / totalQuestions) * 100) : 0;

        request.setAttribute("score", score);
        request.setAttribute("total", totalQuestions);
        request.setAttribute("accuracy", accuracy);
        request.setAttribute("timeTaken", (timeSpent != null ? timeSpent : "0")); 
        request.setAttribute("reviewList", reviewList);
        request.setAttribute("tech", folderTech);
        
        request.getRequestDispatcher("result_summary.jsp").forward(request, response);
    }
}