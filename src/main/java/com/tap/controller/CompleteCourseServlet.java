package com.tap.controller;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CompleteCourseServlet")
public class CompleteCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tech = request.getParameter("tech");
        if(tech != null) {
            // Set the flag for 50%
            request.getSession().setAttribute(tech.toLowerCase() + "_read", true);
        }
        response.sendRedirect("myLearning.jsp");
    }
}