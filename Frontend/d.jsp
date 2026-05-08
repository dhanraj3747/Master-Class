<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. Session Protection - Safety first!
    Integer userId = (Integer) session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Data Retrieval from AnalyticsServlet
    // We use safe defaults (0) if the data is missing to prevent NullPointerExceptions
    Integer java = (Integer) request.getAttribute("javaProg");
    Integer html = (Integer) request.getAttribute("htmlProg");
    Integer css = (Integer) request.getAttribute("cssProg");
    Integer js = (Integer) request.getAttribute("jsProg");
    Integer py = (Integer) request.getAttribute("pythonProg");
    Integer avg = (Integer) request.getAttribute("avgProg");
    
    java = (java != null) ? java : 0;
    html = (html != null) ? html : 0;
    css = (css != null) ? css : 0;
    js = (js != null) ? js : 0;
    py = (py != null) ? py : 0;
    avg = (avg != null) ? avg : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Analytics Dashboard | EduStream Pro</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.8);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 10% 20%, var(--cyan-glow), transparent 30%), 
                              radial-gradient(circle at 90% 80%, var(--cyan-glow), transparent 30%);
            background-attachment: fixed;
            color: var(--text-color);
            margin: 0; display: flex; min-height: 100vh;
        }

        /* --- Standard Sidebar --- */
        .sidebar {
            width: 260px; background: var(--glass-bg); backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border); padding: 40px 20px;
            display: flex; flex-direction: column; position: sticky; top: 0; height: 100vh;
        }

        .logo { font-size: 20px; font-weight: 800; display: flex; align-items: center; gap: 10px; margin-bottom: 50px; }
        .logo i { color: var(--cyan-secondary); }

        .nav-links { list-style: none; padding: 0; }
        .nav-links li { margin-bottom: 15px; }
        .nav-links a { 
            text-decoration: none; color: #64748b; font-weight: 500; font-size: 14px;
            display: flex; align-items: center; gap: 12px; padding: 12px 20px; border-radius: 12px;
            transition: 0.3s;
        }
        .nav-links a:hover, .nav-links a.active { 
            background: var(--cyan-glow); color: var(--cyan-secondary); border: 1px solid rgba(0, 242, 254, 0.2); 
        }

        /* --- Main Content --- */
        .main-content { flex: 1; padding: 50px; overflow-y: auto; }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .header-section h2 { font-weight: 800; font-size: 28px; margin: 0; }

        /* KPI Cards Grid */
        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .glass-card { 
            background: var(--glass-bg); backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border); border-radius: 20px; padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); transition: 0.3s;
        }
        .glass-card:hover { transform: translateY(-5px); border-color: var(--cyan-secondary); }

        .kpi-title { font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 10px; }
        .kpi-value { font-size: 28px; font-weight: 800; color: var(--text-color); margin-bottom: 10px; }

        /* Progress Bar (Within KPI) */
        .progress-track { height: 8px; background: rgba(0,0,0,0.05); border-radius: 10px; overflow: hidden; }
        .progress-fill { height: 100%; background: var(--cyan-gradient); border-radius: 10px; transition: width 1s ease; }

        /* Charts Section */
        .charts-row { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 30px; }
        .chart-box { padding: 30px; }
        .chart-box h4 { font-weight: 700; margin-bottom: 25px; font-size: 18px; }

        .btn-action { 
            background: var(--cyan-gradient); color: white; border: none; padding: 12px 25px; 
            border-radius: 12px; font-weight: 700; text-decoration: none; display: inline-flex;
            align-items: center; gap: 10px; box-shadow: 0 8px 15px var(--cyan-glow);
        }

        .logout-btn { 
            margin-top: auto; border: 1px solid #ef4444; color: #ef4444; 
            text-align: center; padding: 12px; border-radius: 12px; text-decoration: none; font-weight: 600;
        }
        .logout-btn:hover { background: rgba(239, 68, 68, 0.05); }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <i class="fas fa-layer-group"></i> EduStream Pro
        </div>
        <ul class="nav-links">
            <li><a href="#" class="active"><i class="fas fa-chart-pie"></i> Dashboard</a></li>
            <li><a href="myLearning.jsp"><i class="fas fa-graduation-cap"></i> My Courses</a></li>
            <li><a href="#"><i class="fas fa-award"></i> Certificates</a></li>
            <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
        </ul>
        <a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
    </aside>

    <main class="main-content">
        <div class="header-section">
            <div>
                <h2>Learning Analytics</h2>
                <p class="text-muted">Real-time performance metrics for Student ID #<%= userId %></p>
            </div>
            <a href="myLearning.jsp" class="btn-action">
                <i class="fas fa-rocket"></i> Resume Learning
            </a>
        </div>

        <div class="kpi-grid">
            <div class="glass-card">
                <div class="kpi-title">Overall Completion</div>
                <div class="kpi-value"><%= avg %>%</div>
                <div class="progress-track">
                    <div class="progress-fill" style="width: <%= avg %>%;"></div>
                </div>
            </div>
            <div class="glass-card">
                <div class="kpi-title">Active Modules</div>
                <div class="kpi-value">05</div>
                <p class="small text-success m-0 fw-bold"><i class="fas fa-check-double"></i> All Synced</p>
            </div>
            <div class="glass-card">
                <div class="kpi-title">Mastery Level</div>
                <div class="kpi-value"><%= (avg >= 80) ? "Expert" : (avg >= 50 ? "Proficient" : "Beginner") %></div>
                <p class="small text-muted m-0">Based on quiz scores</p>
            </div>
            <div class="glass-card">
                <div class="kpi-title">Certificates</div>
                <div class="kpi-value"><%= (avg == 100) ? "01" : "00" %></div>
                <p class="small text-muted m-0">Unlocked at 100%</p>
            </div>
        </div>

        <div class="charts-row">
            <div class="glass-card chart-box">
                <h4>Course Completion Breakdown</h4>
                <canvas id="barChart" height="110"></canvas>
            </div>
            <div class="glass-card chart-box">
                <h4>Skill Radar</h4>
                <canvas id="radarChart"></canvas>
            </div>
        </div>

        <div class="glass-card">
            <h4 class="fw-bold mb-3">Database Connection Status</h4>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 12px; height: 12px; background: #10B981; border-radius: 50%; box-shadow: 0 0 10px rgba(16, 185, 129, 0.5);"></div>
                <span class="fw-600">Connected to `student_module_progress`</span>
                <span class="text-muted ms-auto small">Last synced: Just now</span>
            </div>
        </div>
    </main>

    <script>
        window.eduData = {
            java: <%= java %>,
            html: <%= html %>,
            css: <%= css %>,
            js: <%= js %>,
            python: <%= py %>
        };
    </script>
    
    <script src="d.js"></script>

</body>
</html>