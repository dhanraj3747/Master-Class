package com.tap.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.tap.dao.QuestionDAO;
import com.tap.dao.NotificationDAO;
import com.tap.model.Question;

@WebServlet("/UploadCsvServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 100)
public class UploadCsvServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Retrieve parameters from questionportal.jsp
        String folderCategory = request.getParameter("category"); 
        String questionType = request.getParameter("questionType"); 
        Part filePart = request.getPart("csvFile"); 
        
        if (filePart == null || folderCategory == null || questionType == null) {
            response.sendRedirect("questionportal.jsp?error=Missing parameters");
            return;
        }
        
        // GRAB THE EXACT CSV FILE NAME dynamically for the notification
        String actualFileName = filePart.getSubmittedFileName();

        List<Question> questionList = new ArrayList<>();

        // 2. Parse the CSV file content
        try (InputStream fileContent = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent))) {
             
            String line;
            boolean isFirstLine = true;
            while ((line = reader.readLine()) != null) {
                if (isFirstLine) { isFirstLine = false; continue; }
                String[] data = line.split(",");
                if (data.length >= 6) {
                    Question q = new Question();
                    q.setFolderCategory(folderCategory); 
                    q.setQuestionType(questionType); 
                    q.setQuestionText(data[0].trim());
                    q.setOptionA(data[1].trim());
                    q.setOptionB(data[2].trim());
                    q.setOptionC(data[3].trim());
                    q.setOptionD(data[4].trim());
                    q.setCorrectOption(data[5].trim());
                    questionList.add(q);
                }
            }
        } catch (Exception e) {
            response.sendRedirect("questionportal.jsp?error=CSV Parse Error");
            return;
        }

        // 3. Database Insertions
        QuestionDAO qDAO = new QuestionDAO();
        boolean success = qDAO.batchInsertQuestions(questionList); 
        
        if (success) {
            // 4. TRIGGER NOTIFICATION (UPDATED TO NEW DYNAMIC SYSTEM)
            try {
                NotificationDAO nDAO = new NotificationDAO();
                // Send the exact details to all 6 students
                nDAO.sendNotificationToAll(actualFileName, questionType, folderCategory);
                System.out.println("Notification sent to Student Dashboard for: " + actualFileName);
            } catch (Exception e) {
                System.err.println("Notification Error: " + e.getMessage());
            }
            
            // 5. Final Redirect to Admin Dashboard
            response.sendRedirect("questionportal.jsp?success=Upload Successful and Students Notified!");
        } else {
            response.sendRedirect("questionportal.jsp?error=Database Insert Failed");
        }
    }
}