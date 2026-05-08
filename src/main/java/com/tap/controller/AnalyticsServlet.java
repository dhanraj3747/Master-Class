package com.tap.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.dao.AdminAnalyticsDAO;
import com.tap.model.StudentProgressSummary;

@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Protect the route - Only Admins should see the aggregate view
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch data for ALL students dynamically
        AdminAnalyticsDAO adminDao = new AdminAnalyticsDAO();
        List<StudentProgressSummary> allStudentsData = adminDao.getAllStudentProgress();

        // Pass the list to the JSP
        request.setAttribute("studentAnalyticsList", allStudentsData);

        // Forward to the new Admin UI page
        request.getRequestDispatcher("adminStudentAnalytics.jsp").forward(request, response);
    }
}