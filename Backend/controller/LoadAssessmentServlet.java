package com.tap.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.dao.AssessmentDAO;
import com.tap.model.Assessment;
import com.tap.model.Question;

@WebServlet("/LoadAssessmentServlet")
public class LoadAssessmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get the ID of the assessment clicked on the dashboard
        String idParam = request.getParameter("id");
        
        if(idParam != null && !idParam.isEmpty()) {
            int assessmentId = Integer.parseInt(idParam);
            
            AssessmentDAO dao = new AssessmentDAO();
            
            // 2. Fetch the specific Assessment (for Title and dynamic Timer)
            Assessment assessment = dao.getAssessmentById(assessmentId);
            
            // 3. Fetch the Questions for this assessment
            List<Question> questions = dao.getQuestionsByAssessmentId(assessmentId);
            
            // 4. Attach them to the request
            request.setAttribute("assessment", assessment);
            request.setAttribute("questions", questions);
            
            // 5. Forward everything to takeAssessment.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("takeAssessment.jsp");
            dispatcher.forward(request, response);
            
        } else {
            // If no ID is passed, send them back to the dashboard
            response.sendRedirect("assessment_dashboard.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}