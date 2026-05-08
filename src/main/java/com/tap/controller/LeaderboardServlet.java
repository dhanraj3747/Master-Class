package com.tap.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.dao.LeaderboardDAO;
import com.tap.model.LeaderboardUser;

@WebServlet("/LeaderboardServlet")
public class LeaderboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Instantiate the DAO
        LeaderboardDAO leaderboardDAO = new LeaderboardDAO();
        
        // 2. THE FIX: Changed getTopStudents() to getTopRankings()
        // Make sure this matches the method name inside your LeaderboardDAO.java
        List<LeaderboardUser> topStudents = leaderboardDAO.getTopRankings();
        
        // 3. Attach the list to the request object
        request.setAttribute("topStudents", topStudents);
        
        // 4. Forward the request to your leaderboard.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("leaderboard.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}