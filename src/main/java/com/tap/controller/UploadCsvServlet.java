package com.tap.controller;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.tap.dao.QuestionDAO;
import com.tap.model.Question;

// VERY IMPORTANT: You must include @MultipartConfig to handle file uploads
@WebServlet("/UploadCsvServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class UploadCsvServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get the folder/category selected by the Admin in the UI dropdown
        String folderCategory = request.getParameter("category"); // e.g., "HTML", "Java"
        
        // 2. Get the uploaded CSV file
        Part filePart = request.getPart("csvFile"); 
        
        if (filePart == null || folderCategory == null || folderCategory.isEmpty()) {
            response.sendRedirect("questionportal.jsp?error=Missing file or category");
            return;
        }

        List<Question> questionList = new ArrayList<>();

        // 3. Read the file line by line
        try (InputStream fileContent = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent))) {
             
            String line;
            boolean isFirstLine = true;
            
            while ((line = reader.readLine()) != null) {
                // Skip the header row of the CSV
                if (isFirstLine) {
                    isFirstLine = false;
                    continue; 
                }

                // Assuming CSV format: QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer
                String[] data = line.split(",");
                
                // Ensure the row has the correct number of columns before adding
                if (data.length >= 6) {
                    Question q = new Question();
                    q.setFolderCategory(folderCategory); // Attach the folder assigned by admin
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
            e.printStackTrace();
            response.sendRedirect("questionportal.jsp?error=Failed to parse CSV");
            return;
        }

        // 4. Send the list to the DAO to be saved in the database
        QuestionDAO questionDAO = new QuestionDAO();
        boolean success = questionDAO.batchInsertQuestions(questionList); // You need to create this method in QuestionDAO

        if (success) {
            response.sendRedirect("questionportal.jsp?success=Questions uploaded successfully");
        } else {
            response.sendRedirect("questionportal.jsp?error=Database insertion failed");
        }
    }
}