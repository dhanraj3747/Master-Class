package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.dao.NotificationDAO;
import com.tap.dao.QuestionDAO;
import com.tap.model.Question;

@WebServlet("/ManageQuestionServlet")
public class ManageQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Extract parameters
        String questionType = request.getParameter("questionType");
        String category = request.getParameter("category");
        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");

        // Basic validation
        if (questionType == null || category == null || questionText == null || questionText.trim().isEmpty()) {
            response.sendRedirect("questionportal.jsp?error=Missing required fields");
            return;
        }

        // 2. Populate model
        Question q = new Question();
        q.setQuestionType(questionType);
        q.setFolderCategory(category);
        q.setQuestionText(questionText.trim());
        q.setOptionA(optionA.trim());
        q.setOptionB(optionB.trim());
        q.setOptionC(optionC.trim());
        q.setOptionD(optionD.trim());
        q.setCorrectOption(correctOption.trim());

        // 3. Save to Database
        List<Question> singleQuestionList = new ArrayList<>();
        singleQuestionList.add(q);

        QuestionDAO questionDAO = new QuestionDAO();
        boolean success = questionDAO.batchInsertQuestions(singleQuestionList);

        if (success) {
            
            // Trigger Notification with Complete Information
            try {
                NotificationDAO notifDao = new NotificationDAO();
                // We pass "1 New Question Added manually" as the file name detail so the UI handles it cleanly.
                notifDao.sendNotificationToAll("1 New Question Added manually", questionType, category);
            } catch (Exception e) {
                System.out.println("Notification Error: " + e.getMessage());
            }
            
            // Redirect back to the portal with a success message for the user
            response.sendRedirect("questionportal.jsp?success=Question saved successfully!");
        } else {
            response.sendRedirect("questionportal.jsp?error=Database Error: Could not save question.");
        }
    }
}