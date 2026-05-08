<%@ page import="java.sql.*,com.project.DBConnection" %>
<%
    // Session Protection: Only students
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("student")) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Question Bank | Edutree-Stars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Utilizing your existing Premium Glassy Cyan Theme */
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
        }

        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--bg-color); 
            background-image: radial-gradient(circle at 15% 50%, var(--cyan-glow), transparent 25%), 
                              radial-gradient(circle at 85% 30%, var(--cyan-glow), transparent 25%);
            background-attachment: fixed;
            color: var(--text-color); 
        }

        /* --- View-Only Card Styling --- */
        .folder-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 30px 20px;
            text-align: center;
            text-decoration: none;
            color: var(--text-color);
            display: block;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
        }

        .folder-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px var(--cyan-glow);
            border-color: rgba(0, 242, 254, 0.4);
            color: var(--text-color);
        }

        .folder-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            background: -webkit-linear-gradient(var(--cyan-primary), var(--cyan-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .folder-title {
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 5px;
        }

        .folder-subtitle {
            font-size: 0.85rem;
            color: #64748b;
        }

        /* Standardized Header */
        .premium-header {
            position: relative;
            display: inline-block;
            padding-bottom: 8px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 40px;
        }
        .premium-header::after {
            content: ''; position: absolute; left: 0; bottom: 0; width: 60px; height: 4px;
            background: linear-gradient(90deg, var(--cyan-primary), var(--cyan-secondary));
            border-radius: 4px; box-shadow: 0 0 10px var(--cyan-glow);
        }
    </style>
</head>
<body class="p-5">

    <div class="container">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="premium-header m-0">Question Bank Library</h2>
            <a href="studentDashboard.jsp" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>
        
        <p class="text-muted mb-5 fs-5">Select a module below to view practice questions and study materials.</p>

        <div class="row g-4">
            <!-- Notice these point to viewQuestions.jsp which you already have in your Eclipse project! -->
            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=JavaScript" class="folder-card">
                    <i class="fab fa-js folder-icon"></i>
                    <div class="folder-title">JavaScript</div>
                    <div class="folder-subtitle">Core Concepts & ES6</div>
                </a>
            </div>
            
            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=React" class="folder-card">
                    <i class="fab fa-react folder-icon"></i>
                    <div class="folder-title">React JS</div>
                    <div class="folder-subtitle">Components & Hooks</div>
                </a>
            </div>

            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=Java" class="folder-card">
                    <i class="fab fa-java folder-icon"></i>
                    <div class="folder-title">Java Core</div>
                    <div class="folder-subtitle">OOPs & Collections</div>
                </a>
            </div>

            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=HTML" class="folder-card">
                    <i class="fab fa-html5 folder-icon"></i>
                    <div class="folder-title">HTML5</div>
                    <div class="folder-subtitle">Structure & Semantics</div>
                </a>
            </div>

            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=CSS" class="folder-card">
                    <i class="fab fa-css3-alt folder-icon"></i>
                    <div class="folder-title">CSS3</div>
                    <div class="folder-subtitle">Styling & Layouts</div>
                </a>
            </div>

            <div class="col-md-4 col-sm-6">
                <a href="viewQuestions.jsp?tech=SQL" class="folder-card">
                    <i class="fas fa-database folder-icon"></i>
                    <div class="folder-title">SQL / MySQL</div>
                    <div class="folder-subtitle">Queries & Schemas</div>
                </a>
            </div>
        </div>
    </div>

</body>
</html>