package com.tap.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.tap.dao.QuestionDAO;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        QuestionDAO dao = new QuestionDAO();
        
        if(dao.deleteQuestion(id)) {
            response.sendRedirect("adminViewQuestions.jsp?success=Deleted");
        } else {
            response.sendRedirect("adminViewQuestions.jsp?error=Failed");
        }
    }
}