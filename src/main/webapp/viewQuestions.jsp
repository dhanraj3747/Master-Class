<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.dao.QuestionDAO, com.tap.model.Question" %>
<%
    if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    String tech = request.getParameter("tech");
    QuestionDAO dao = new QuestionDAO();
    List<Question> questions = dao.getDynamicQuestions(tech, "Practice");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= tech %> Practice | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f4f7f9; font-family: 'Poppins', sans-serif; padding: 40px; }
        .header-bar { background: linear-gradient(135deg, #00f2fe, #4facfe); color: white; padding: 30px; border-radius: 20px; margin-bottom: 40px; }
        .study-card { background: white; border-radius: 16px; padding: 25px; margin-bottom: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border-left: 6px solid #00f2fe; }
        .correct { background: #dcfce7; color: #15803d; padding: 10px; border-radius: 8px; font-weight: 700; margin-top: 15px; display: inline-block; }
    </style>
</head>
<body>
    <div class="container" style="max-width: 900px;">
        <div class="header-bar d-flex justify-content-between align-items-center">
            <h2 class="m-0"><i class="fas fa-dumbbell me-2"></i> <%= tech %> Practice Bank</h2>
            <a href="myLearning.jsp" class="btn btn-light rounded-pill px-4">Back</a>
        </div>

        <% if(questions.isEmpty()) { %>
            <div class="alert alert-info">Admin hasn't uploaded Practice questions for <%= tech %> yet.</div>
        <% } else { 
            int qNum = 1;
            for(Question q : questions) { %>
            <div class="study-card">
                <h5 class="fw-bold"><%= qNum++ %>. <%= q.getQuestionText() %></h5>
                <div class="row mt-3">
                    <div class="col-6 mb-2">A) <%= q.getOptionA() %></div>
                    <div class="col-6 mb-2">B) <%= q.getOptionB() %></div>
                    <div class="col-6 mb-2">C) <%= q.getOptionC() %></div>
                    <div class="col-6 mb-2">D) <%= q.getOptionD() %></div>
                </div>
                <div class="correct"><i class="fas fa-check-circle me-1"></i> Correct Answer: <%= q.getCorrectOption() %></div>
            </div>
        <% } } %>
    </div>
</body>
</html>