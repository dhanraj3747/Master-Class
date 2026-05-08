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

@WebServlet("/SubmitAssessmentServlet")
public class SubmitAssessmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // 1. Session Protection: Ensure user is logged in
        Integer studentId = (Integer) session.getAttribute("userId");
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Extract Request Parameters
        String folderTech = request.getParameter("folder"); // e.g., "JAVA", "HTML"
        String timeSpent = request.getParameter("timeSpent"); 
        
        if (folderTech == null || folderTech.trim().isEmpty()) {
            folderTech = "GENERAL"; 
        }

        // 3. Dynamic Question Retrieval
        QuestionDAO qDao = new QuestionDAO();
        List<Question> questions = qDao.getDynamicQuestions(folderTech, "Assessment");
        
        int score = 0;
        List<QuestionResult> reviewList = new ArrayList<>();

        // 4. THE INDESTRUCTIBLE SCORING ENGINE
        if (questions != null && !questions.isEmpty()) {
            for (Question q : questions) {
                String selectedVal = request.getParameter("q_" + q.getQuestionId());
                String correctVal = q.getCorrectOption();
                boolean isCorrect = false;

                // "Nuclear" String Comparison (Ignores extra spaces and case sensitivity)
                if (selectedVal != null && correctVal != null) {
                    String cleanSelected = selectedVal.replaceAll("\\s+", "").toLowerCase();
                    String cleanCorrect = correctVal.replaceAll("\\s+", "").toLowerCase();

                    if (cleanSelected.equals(cleanCorrect)) {
                        score++;
                        isCorrect = true;
                    }
                }
                
                // Add to review list for the student to see what they got right/wrong
                reviewList.add(new QuestionResult(
                    q.getQuestionText(), 
                    (selectedVal != null ? selectedVal : "Skipped"), 
                    correctVal, 
                    isCorrect
                ));
            }
        }

        // 5. DATABASE UPDATES
        int totalQuestions = (questions != null) ? questions.size() : 0;
        String techKey = folderTech.toUpperCase().trim();

        // THE FIX: Directing the score to the ASSESSMENT-specific method
        // This prevents the score from accidentally being added to assignments
        qDao.saveAssessmentScore(studentId, techKey, score);

        // B. Update the Progress Dashboard (Triggers the 25% progress jump)
        ProgressDAO progressDao = new ProgressDAO();
        progressDao.updateProgress(studentId, techKey, "assessment_done", 1);

        // 6. UI Calculations
        int accuracy = (totalQuestions > 0) ? (int)(((double) score / totalQuestions) * 100) : 0;

        // 7. Forward data to result_summary.jsp
        request.setAttribute("score", score);
        request.setAttribute("total", totalQuestions);
        request.setAttribute("accuracy", accuracy);
        request.setAttribute("timeTaken", (timeSpent != null ? timeSpent : "0")); 
        request.setAttribute("reviewList", reviewList);
        request.setAttribute("tech", folderTech);
        
        request.getRequestDispatcher("result_summary.jsp").forward(request, response);
    }
}