<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.tap.dao.ProgressDAO" %>
<%
    // 1. Session Protection - Ensures user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Data Access Setup
    ProgressDAO dao = new ProgressDAO();
    String[] techs = {"JAVA", "HTML", "CSS", "JAVASCRIPT", "PYTHON"};
    String[] displayNames = {"Java Core", "HTML5 Layout", "CSS Styling", "JS Logic", "Python AI"};
    String[] descriptions = {
        "Learn Java syntax and variables by building an addition program.",
        "Master the layout of the web using semantic tags and structure.",
        "Design stunning, responsive interfaces with Flexbox and Grid.",
        "Add dynamic behavior to your sites using DOM and ES6 logic.",
        "Analyze data sets and automate tasks using Python libraries."
    };
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Learning Path | EduStream Pro</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.2);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            padding: 40px 20px;
        }

        .main-container { max-width: 1000px; margin: 0 auto; }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 35px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .glass-card:hover { transform: translateY(-5px); border-color: var(--cyan-secondary); }

        /* Progress Bar Styling */
        .progress-wrapper {
            height: 10px;
            background: rgba(0, 242, 254, 0.1);
            border-radius: 20px;
            margin: 20px 0;
            overflow: hidden;
        }

        .progress-bar-cyan {
            height: 100%;
            background: var(--cyan-gradient);
            transition: width 1s ease;
            box-shadow: 0 0 10px var(--cyan-glow);
        }

        .btn-custom {
            padding: 12px 22px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: none;
            text-decoration: none;
        }

        .btn-primary-cyan {
            background: var(--cyan-gradient);
            color: #ffffff !important;
            box-shadow: 0 8px 20px var(--cyan-glow);
        }

        .btn-outline-cyan {
            background: rgba(255, 255, 255, 0.7);
            border: 2px solid var(--cyan-secondary);
            color: var(--cyan-secondary) !important;
        }

        /* Logic: Grayed out state */
        .btn-locked {
            opacity: 0.35;
            cursor: not-allowed;
            background: #f1f5f9;
            border: 2px solid #cbd5e1;
            color: #94a3b8 !important;
            pointer-events: none;
        }

        .btn-reset {
            color: #ef4444;
            background: transparent;
            border: 1px solid #ef4444;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-reset:hover { background: #fef2f2; }

        .badge-cyan {
            background: var(--cyan-gradient);
            color: white;
            padding: 8px 16px;
            font-weight: 700;
            border-radius: 30px;
            box-shadow: 0 4px 10px var(--cyan-glow);
        }
    </style>
</head>
<body>

<div class="main-container">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h1 class="fw-bold m-0"><i class="fas fa-graduation-cap me-2" style="color: var(--cyan-secondary);"></i> My Learning Path</h1>
            <p class="text-muted mt-1">Enterprise Training Portal • User #<%= userId %></p>
        </div>
        <a href="studentDashboard.jsp" class="btn-custom btn-outline-cyan">
            <i class="fas fa-sign-out-alt"></i> Exit to Dashboard
        </a>
    </div>

    <% 
        for(int i=0; i < techs.length; i++) { 
            String currentTech = techs[i];
            int[] status = dao.getModuleStatus(userId, currentTech);
            
            // Formula: Course Read (50%) + Assessment (25%) + Assignment (25%) = 100%
            int totalProg = (status[0] * 50) + (status[1] * 25) + (status[2] * 25);
            boolean isUnlocked = (status[0] == 1); // Unlocked if course is taken
    %>
    <div class="glass-card">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h3 class="fw-bold mb-1"><%= displayNames[i] %></h3>
                <p class="text-muted mb-0"><%= descriptions[i] %></p>
            </div>
            <div class="text-end">
                <span class="badge-cyan">
                    <%= totalProg %>% Completed
                </span>
                
                <div class="mt-3">
                    <form action="UpdateProgressServlet" method="POST">
                        <input type="hidden" name="percentage" value="0">
                        <input type="hidden" name="module" value="<%= currentTech %>">
                        <button type="submit" class="btn-reset">
                            <i class="fas fa-sync-alt me-1"></i> Reset Progress
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="progress-wrapper">
            <div class="progress-bar-cyan" style="width: <%= totalProg %>%;"></div>
        </div>

        <div class="d-flex gap-3 flex-wrap">
            
            <form action="UpdateProgressServlet" method="POST">
                <input type="hidden" name="percentage" value="50">
                <input type="hidden" name="module" value="<%= currentTech %>">
                <button type="submit" class="btn-custom btn-primary-cyan">
                    <i class="fas fa-play-circle"></i> Take Course
                </button>
            </form>
            
            <a href="mcq_test.jsp?folder=<%= currentTech %>" 
               class="btn-custom <%= isUnlocked ? "btn-outline-cyan" : "btn-locked" %>">
                <i class="fas fa-vial"></i> Assessment
            </a>
            
            <a href="assignment_upload.jsp?folder=<%= currentTech %>" 
               class="btn-custom <%= isUnlocked ? "btn-outline-cyan" : "btn-locked" %>">
                <i class="fas fa-tasks"></i> Assignment
            </a>

            <a href="viewQuestions.jsp?tech=<%= currentTech %>" class="btn-custom btn-outline-cyan">
                <i class="fas fa-dumbbell"></i> Practice Mode
            </a>
        </div>
    </div>
    <% } %>
</div>

</body>
</html>