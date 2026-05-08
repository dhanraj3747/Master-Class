package com.tap.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.tap.dao.QuestionDAO;
import com.tap.model.Question;

@WebServlet("/UpdateQuestionServlet")
public class UpdateQuestionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            Question q = new Question();
            q.setQuestionId(Integer.parseInt(request.getParameter("id")));
            q.setQuestionText(request.getParameter("text"));
            q.setOptionA(request.getParameter("optA"));
            q.setOptionB(request.getParameter("optB"));
            q.setOptionC(request.getParameter("optC")); // Added C
            q.setOptionD(request.getParameter("optD")); // Added D
            q.setCorrectOption(request.getParameter("correct"));

            QuestionDAO dao = new QuestionDAO();
            if(dao.updateQuestion(q)) {
                // Redirect back to the inventory with a success toast
                response.sendRedirect("adminViewQuestions.jsp?success=Question Updated Successfully");
            } else {
                response.sendRedirect("adminViewQuestions.jsp?error=Database Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminViewQuestions.jsp?error=Server Error: " + e.getMessage());
        }
    }
}