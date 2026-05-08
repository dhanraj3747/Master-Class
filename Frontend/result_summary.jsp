<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.tap.model.QuestionResult" %>


<%! 
    public String safeText(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assessment Summary | EduStream Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --cyan-primary: #00f2fe; --cyan-secondary: #4facfe;
            --glass-bg: rgba(255, 255, 255, 0.05); --glass-border: rgba(255, 255, 255, 0.1);
        }
        body { 
            font-family: 'Poppins', sans-serif; background: #0b1121; color: #f8fafc;
            background-image: radial-gradient(circle at 0% 0%, rgba(0,242,254,0.15), transparent 40%);
            padding: 60px 20px; min-height: 100vh;
        }
        .result-container {
            max-width: 850px; margin: auto; background: var(--glass-bg);
            backdrop-filter: blur(20px); border: 1px solid var(--glass-border);
            border-radius: 32px; padding: 50px; box-shadow: 0 25px 50px rgba(0,0,0,0.4);
        }
        .score-circle {
            width: 200px; height: 200px; border-radius: 50%;
            border: 10px solid var(--cyan-primary); margin: 30px auto;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            box-shadow: 0 0 40px rgba(0,242,254,0.3); background: rgba(0,242,254,0.05);
        }
        .score-val { font-size: 4rem; font-weight: 800; line-height: 1; color: #fff; }
        .stat-box { background: rgba(255,255,255,0.03); padding: 25px; border-radius: 20px; border: 1px solid var(--glass-border); }
        
        .review-item {
            background: rgba(255,255,255,0.03); border-radius: 18px; padding: 25px;
            margin-bottom: 20px; border-left: 6px solid #64748b; text-align: left;
        }
        .is-correct { border-left-color: #10b981; background: rgba(16, 185, 129, 0.05); }
        .is-wrong { border-left-color: #ef4444; background: rgba(239, 68, 68, 0.05); }
        
        .btn-dash {
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary));
            color: white; border: none; padding: 16px 50px; border-radius: 50px;
            font-weight: 700; text-decoration: none; display: inline-block; transition: 0.3s;
        }
        .btn-dash:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(0,242,254,0.4); color: white; }
    </style>
</head>
<body>

    <div class="result-container text-center">
        <h1 class="fw-extrabold mb-2">Assessment Complete</h1>
        <p class="text-muted">Domain: <span class="text-info fw-bold"><%= request.getAttribute("tech") %></span></p>

        <div class="score-circle">
            <div class="score-val"><%= request.getAttribute("score") %></div>
            <div class="small fw-bold opacity-50">SCORE</div>
        </div>

        <div class="row g-4 mt-3">
            <div class="col-md-6">
                <div class="stat-box">
                    <p class="small text-muted mb-1 fw-bold text-uppercase">Accuracy</p>
                    <h2 class="fw-bold m-0" style="color: var(--cyan-primary);"><%= request.getAttribute("accuracy") %>%</h2>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-box">
                    <p class="small text-muted mb-1 fw-bold text-uppercase">Total Time</p>
                    <h2 class="fw-bold m-0" style="color: var(--cyan-primary);"><%= request.getAttribute("timeTaken") %>s</h2>
                </div>
            </div>
        </div>

        <hr class="my-5 opacity-10">

        <h3 class="text-start mb-4 fw-bold"><i class="fas fa-list-ul me-2" style="color: var(--cyan-secondary);"></i> Performance Review</h3>

        <% 
            List<QuestionResult> results = (List<QuestionResult>) request.getAttribute("reviewList");
            if(results != null) {
                for(QuestionResult res : results) {
        %>
            <div class="review-item <%= res.isCorrect() ? "is-correct" : "is-wrong" %>">
                <p class="fw-bold mb-3" style="font-size: 1.1rem;"><%= res.getQuestionText() %></p>
                
                
                
                
                <div class="row">
    <div class="col-6">
        <span class="small text-muted d-block mb-1">Your Selection</span>
        <span class="<%= res.isCorrect() ? "text-success" : "text-danger" %> fw-bold">
            <i class="fas <%= res.isCorrect() ? "fa-check-circle" : "fa-times-circle" %> me-1"></i>
            <%= safeText(res.getUserAnswer()) %>
        </span>
    </div>
    <div class="col-6 border-start border-white border-opacity-10">
        <span class="small text-muted d-block mb-1">Correct Answer</span>
        <span class="text-success fw-bold"><%= safeText(res.getCorrectAnswer()) %></span>
    </div>
</div>
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
               
        <%      }
            } 
        %>

        <div class="mt-5">
            <a href="studentDashboard.jsp" class="btn-dash">Return to Dashboard</a>
        </div>
    </div>

</body>
</html>