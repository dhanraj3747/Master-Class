package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.dao.AssessmentDAO;
import com.tap.model.Question;
import com.tap.model.QuestionResult;
import com.tap.model.StudentScore;

@WebServlet("/SubmitAssessmentServlet")
public class SubmitAssessmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        int assessmentId = Integer.parseInt(request.getParameter("assessmentId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int timeSpentSeconds = Integer.parseInt(request.getParameter("timeSpent"));
        
        AssessmentDAO dao = new AssessmentDAO();
        List<Question> questions = dao.getQuestionsByAssessmentId(assessmentId);
        
        int score = 0;
        List<QuestionResult> reviewList = new ArrayList<>();

        // Loop through all questions to check answers
        for (Question q : questions) {
            // Get the radio button value the student selected (e.g., "A", "B")
            String selectedVal = request.getParameter("q_" + q.getQuestionId());
            
            // Check if it matches the correct answer from the database
            // Note: Use getCorrectAnswer() or getCorrectOption() based on your Question model
            String correctVal = q.getCorrectOption(); // Or q.getCorrectAnswer()
            boolean isCorrect = selectedVal != null && selectedVal.equalsIgnoreCase(correctVal);
            
            if (isCorrect) {
                score++;
            }
            
            reviewList.add(new QuestionResult(q.getQuestionText(), selectedVal, correctVal, isCorrect));
        }

        // Save score to database
        StudentScore studentScore = new StudentScore();
        studentScore.setStudentId(studentId);
        studentScore.setAssessmentId(assessmentId);
        studentScore.setMarksScored(score);
        dao.saveStudentScore(studentScore);

        // Format the time taken (MM:SS)
        int minutes = timeSpentSeconds / 60;
        int seconds = timeSpentSeconds % 60;
        String formattedTime = String.format("%02d:%02d", minutes, seconds);

        // Pass everything to the Result JSP
        request.setAttribute("score", score);
        request.setAttribute("totalQuestions", questions.size());
        request.setAttribute("timeTaken", formattedTime);
        request.setAttribute("reviewList", reviewList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("result_summary.jsp");
        dispatcher.forward(request, response);
    }
}