package com.tap.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.tap.dao.NotificationDAO;
import com.tap.model.Notification;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            return; // Stop if not logged in
        }

        Integer studentId = (Integer) session.getAttribute("userId");
        NotificationDAO dao = new NotificationDAO();
        List<Notification> unreadList = dao.getUnreadNotifications(studentId);

        // Build a raw JSON array string to avoid needing extra library dependencies
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < unreadList.size(); i++) {
            Notification n = unreadList.get(i);
            json.append("{")
                .append("\"id\":").append(n.getId()).append(",")
                .append("\"fileName\":\"").append(n.getFileName()).append("\",")
                .append("\"type\":\"").append(n.getUploadType()).append("\",")
                .append("\"folder\":\"").append(n.getTopicFolder()).append("\",")
                .append("\"timestamp\":").append(n.getCreatedAt().getTime()) // Send time in milliseconds
                .append("}");
            if (i < unreadList.size() - 1) json.append(",");
        }
        json.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}