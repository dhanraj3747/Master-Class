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
    if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    String folder = request.getParameter("folder");
    String tech = (folder != null) ? folder.toUpperCase() : "GENERAL";

    // Dynamic Timer Durations
    int timeLimit = 1800; 
    switch(tech) {
        case "JAVA": timeLimit = 1800; break;
        case "HTML": timeLimit = 900; break;
        case "CSS":  timeLimit = 900; break;
    }

    QuestionDAO dao = new QuestionDAO();
    List<Question> questions = dao.getDynamicQuestions(folder, "Assignment");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assignment: <%= tech %> | EduStream Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-dark: #0b1121;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --glass-bg: rgba(255, 255, 255, 0.05);
            --cyan-glow: rgba(0, 242, 254, 0.15);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }
        body { 
            background: var(--bg-dark); color: #f8fafc; font-family: 'Poppins', sans-serif; 
            background-image: radial-gradient(circle at 10% 20%, var(--cyan-glow), transparent 40%),
                              radial-gradient(circle at 90% 80%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed; padding: 60px 20px;
        }
        .timer-box { 
            position: fixed; top: 30px; right: 30px; background: rgba(0,242,254,0.1); 
            border: 2px solid var(--cyan-primary); padding: 12px 25px; border-radius: 50px; 
            color: var(--cyan-primary); font-weight: 700; z-index: 1000; box-shadow: 0 0 20px var(--cyan-glow);
        }
        .container-box { max-width: 850px; margin: auto; }
        .q-card { 
            background: var(--glass-bg); backdrop-filter: blur(25px); 
            border: 1px solid rgba(255,255,255,0.1); border-radius: 24px; 
            padding: 40px; margin-bottom: 30px; transition: 0.3s;
        }
        .q-card:hover { border-color: var(--cyan-primary); box-shadow: 0 10px 40px rgba(0, 242, 254, 0.1); }
        .form-check { 
            background: rgba(255,255,255,0.03); padding: 18px 18px 18px 50px; border-radius: 15px; 
            margin-bottom: 12px; border: 1px solid transparent; cursor: pointer; transition: 0.2s;
        }
        .form-check:hover { background: rgba(0, 242, 254, 0.08); border-color: var(--cyan-primary); }
        .form-check-input:checked { background-color: var(--cyan-primary); border-color: var(--cyan-primary); }
        .btn-submit { 
            background: var(--cyan-gradient); border: none; color: white; 
            font-weight: 700; padding: 20px; border-radius: 15px; width: 100%; 
            box-shadow: 0 10px 25px var(--cyan-glow); transition: 0.3s;
        }
        .btn-submit:hover { transform: translateY(-3px); box-shadow: 0 15px 35px var(--cyan-glow); }
    </style>
</head>
<body>
    <div class="timer-box"><i class="fas fa-clock me-2"></i><span id="displayTime">--:--</span></div>

    <div class="container container-box">
        <div class="text-center mb-5">
            <h1 class="fw-bold m-0" style="letter-spacing: -1px;">Assignment: <span style="color: var(--cyan-primary);"><%= tech %></span></h1>
            <p class="text-muted mt-2 fw-bold text-uppercase" style="font-size: 0.75rem; letter-spacing: 2px;">Submit your solutions to unlock the next module</p>
        </div>
        
        <form id="assignmentForm" action="submitAssignment" method="POST">
            <input type="hidden" name="folder" value="<%= folder %>">
            <input type="hidden" name="assignmentId" value="1">
            <input type="hidden" name="timeSpent" id="timeSpentField" value="0">

            <% if(questions.isEmpty()) { %>
                <div class="alert alert-info text-center bg-transparent border-info text-info">Curriculum pending. No questions found for <%= tech %>.</div>
            <% } else { 
                int i = 1;
                for(Question q : questions) { %>
                
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
            
            
                <button type="submit" class="btn btn-submit mb-5">Finalize and Submit</button>
            <% } %>
        </form>
    </div>

    <script>
        let timeLeft = <%= timeLimit %>;
        const totalTime = <%= timeLimit %>;
        const timer = setInterval(() => {
            timeLeft--;
            if(timeLeft >= 0) {
                let m = Math.floor(timeLeft / 60); let s = timeLeft % 60;
                document.getElementById('displayTime').innerText = (m < 10 ? '0' : '') + m + ":" + (s < 10 ? '0' : '') + s;
                document.getElementById('timeSpentField').value = totalTime - timeLeft;
            }
            if (timeLeft <= 0) {
                clearInterval(timer);
                document.getElementById('assignmentForm').submit();
            }
        }, 1000);
    </script>
</body>
</html>