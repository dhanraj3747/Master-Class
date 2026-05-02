<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.dao.QuestionDAO" %>
<%@ page import="com.tap.model.Question" %>
<%
    // 1. Session Protection
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Grab the technology name from the URL (e.g., "JavaScript" or "SQL")
    String techCategory = request.getParameter("tech");
    List<Question> questions = null;

    // 3. Fetch from the database using our new DAO method
    if(techCategory != null && !techCategory.isEmpty()) {
        QuestionDAO dao = new QuestionDAO();
        questions = dao.getQuestionsByCategory(techCategory);
    } else {
        techCategory = "Unknown Module";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= techCategory %> Practice | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f9;
            color: #1e293b;
            padding-bottom: 50px;
        }
        .header-bar {
            background: linear-gradient(135deg, #0969da, #0550ae);
            color: white;
            padding: 30px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(9, 105, 218, 0.2);
        }
        .study-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 5px solid #00f2fe;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }
        .question-text {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .option-text {
            background: #f8fafc;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 10px;
            font-size: 0.95rem;
            border: 1px solid #e2e8f0;
        }
        .correct-answer-box {
            background: #dafbe1;
            color: #1a7f37;
            border: 1px solid #4ac26b;
            padding: 12px 20px;
            border-radius: 8px;
            font-weight: 600;
            margin-top: 20px;
            display: inline-block;
        }
    </style>
</head>
<body>

    <!-- Header -->
    <div class="header-bar">
        <div class="container d-flex justify-content-between align-items-center">
            <h2 class="fw-bold m-0"><i class="fas fa-book-open me-2"></i> <%= techCategory %> Practice Bank</h2>
            <a href="studentQuestionBank.jsp" class="btn btn-light fw-bold rounded-pill">
                <i class="fas fa-arrow-left me-1"></i> Back
            </a>
        </div>
    </div>

    <!-- Questions Container -->
    <div class="container" style="max-width: 800px;">
        <% 
            if (questions != null && !questions.isEmpty()) {
                int qNum = 1;
                for (Question q : questions) {
        %>
            <div class="study-card">
                <div class="question-text">
                    <span class="text-muted fs-6 me-2">Q<%= qNum %>.</span> <%= q.getQuestionText() %>
                </div>
                
                <div class="option-text"><strong>A:</strong> <%= q.getOptionA() %></div>
                <div class="option-text"><strong>B:</strong> <%= q.getOptionB() %></div>
                <div class="option-text"><strong>C:</strong> <%= q.getOptionC() %></div>
                <div class="option-text"><strong>D:</strong> <%= q.getOptionD() %></div>
                
                <div class="correct-answer-box">
                    <i class="fas fa-check-circle me-1"></i> Correct Answer: <%= q.getCorrectOption() %>
                </div>
            </div>
        <% 
                qNum++;
                } 
            } else { 
        %>
            <div class="alert alert-warning text-center fs-5 py-4 shadow-sm">
                <i class="fas fa-info-circle me-2"></i> No practice questions have been uploaded for <strong><%= techCategory %></strong> yet. Check back later!
            </div>
        <% } %>
    </div>

</body>
</html>