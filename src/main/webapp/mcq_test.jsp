<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.dao.QuestionDAO, com.tap.model.Question" %>


<%! 
    // This helper function stops the browser from turning answers into invisible code
    public String safeText(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    // 1. Session Protection
    if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    
    String folder = request.getParameter("folder");
    String tech = (folder != null) ? folder.toUpperCase() : "GENERAL";
    
    // 2. Dynamic Timer Logic (In Seconds)
    int timeLimit = 1800; // Default 30 mins
    switch(tech) {
        case "JAVA":       timeLimit = 2000; break; // 40 Mins
        case "PYTHON":     timeLimit = 1800; break; // 30 Mins
        case "JAVASCRIPT": timeLimit = 1500; break; // 25 Mins
        case "HTML":       timeLimit = 900;  break; // 15 Mins
        case "CSS":        timeLimit = 900;  break; // 15 Mins
    }
    
    QuestionDAO dao = new QuestionDAO();
    List<Question> currentQuestions = dao.getDynamicQuestions(folder, "Assessment");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assessment: <%= tech %> | EduStream Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #0b1121; color: #f8fafc; font-family: 'Poppins', sans-serif; padding: 60px 20px; }
        .timer-box { position: fixed; top: 30px; right: 30px; background: rgba(0,242,254,0.1); border: 2px solid #00f2fe; padding: 12px 25px; border-radius: 50px; color: #00f2fe; font-weight: 700; z-index: 1000; box-shadow: 0 0 15px rgba(0,242,254,0.3); }
        .q-card { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 35px; margin-bottom: 30px; transition: 0.3s; }
        .q-card:hover { border-color: #00f2fe; background: rgba(255,255,255,0.07); }
        .form-check { background: rgba(255,255,255,0.03); padding: 15px 15px 15px 40px; border-radius: 12px; margin-bottom: 12px; border: 1px solid transparent; cursor: pointer; transition: 0.2s; }
        .form-check:hover { border-color: #00f2fe; background: rgba(0,242,254,0.05); }
        .btn-submit { background: linear-gradient(135deg, #00f2fe, #4facfe); border: none; color: white; font-weight: 700; padding: 18px 60px; border-radius: 15px; box-shadow: 0 10px 20px rgba(0,242,254,0.2); }
    </style>
</head>
<body>
    <div class="timer-box"><i class="fas fa-clock me-2"></i><span id="timeDisplay">--:--</span></div>
    
    <div class="container" style="max-width: 850px;">
        <div class="text-center mb-5">
            <h2 class="fw-bold m-0">Assessment: <span style="color: #00f2fe;"><%= tech %></span></h2>
            <p class="text-muted mt-2">Please do not refresh the page during the test.</p>
        </div>
        
        <form id="assessmentForm" action="SubmitAssessmentServlet" method="post">
            <input type="hidden" name="folder" value="<%= folder %>">
            <input type="hidden" name="timeSpent" id="timeSpentField" value="0">

            <% if(currentQuestions == null || currentQuestions.isEmpty()) { %>
                <div class="alert alert-warning text-center">No Assessment questions found for <%= tech %>.</div>
            <% } else { 
                int i = 1;
                for(Question q : currentQuestions) { %>
              
              
              
              <div class="q-card">
    <h4 class="mb-4 fw-bold"><%= i++ %>. <%= safeText(q.getQuestionText()) %></h4>
    
    <div class="form-check">
        <input class="form-check-input" type="radio" name="q_<%= q.getQuestionId() %>" value="<%= safeText(q.getOptionA()) %>" required>
        <label class="form-check-label w-100">A) <%= safeText(q.getOptionA()) %></label>
    </div>
    
    <div class="form-check">
        <input class="form-check-input" type="radio" name="q_<%= q.getQuestionId() %>" value="<%= safeText(q.getOptionB()) %>">
        <label class="form-check-label w-100">B) <%= safeText(q.getOptionB()) %></label>
    </div>
    
    <div class="form-check">
        <input class="form-check-input" type="radio" name="q_<%= q.getQuestionId() %>" value="<%= safeText(q.getOptionC()) %>">
        <label class="form-check-label w-100">C) <%= safeText(q.getOptionC()) %></label>
    </div>
    
    <div class="form-check">
        <input class="form-check-input" type="radio" name="q_<%= q.getQuestionId() %>" value="<%= safeText(q.getOptionD()) %>">
        <label class="form-check-label w-100">D) <%= safeText(q.getOptionD()) %></label>
    </div>
</div>
            <% } %>
            <div class="text-center mt-5 mb-5">
                <button type="submit" class="btn btn-submit">Finalize & Submit</button>
            </div>
            <% } %>
        </form>
    </div>

    <script>
        let secondsLeft = <%= timeLimit %>;
        const totalTime = <%= timeLimit %>;

        const countdown = setInterval(() => {
            secondsLeft--;
            let mins = Math.floor(secondsLeft / 60);
            let secs = secondsLeft % 60;
            
            document.getElementById('timeDisplay').innerText = (mins < 10 ? '0' : '') + mins + ":" + (secs < 10 ? '0' : '') + secs;
            document.getElementById('timeSpentField').value = totalTime - secondsLeft;

            if (secondsLeft <= 300) { // Warning at 5 mins
                document.querySelector('.timer-box').style.color = "#ff4d4d";
                document.querySelector('.timer-box').style.borderColor = "#ff4d4d";
            }

            if (secondsLeft <= 0) {
                clearInterval(countdown);
                alert("Session expired. Submitting your answers now.");
                document.getElementById('assessmentForm').submit();
            }
        }, 1000);
    </script>
</body>
</html>