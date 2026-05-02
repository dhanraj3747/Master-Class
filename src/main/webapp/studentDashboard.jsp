<%@ page import="java.sql.*,com.project.DBConnection" %>
<%
    // 1. Session Protection
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("student")) {
        response.sendRedirect("login.jsp");
        return; 
    }

    String studentName = (String) session.getAttribute("studentName");
    if(studentName == null) studentName = "Student"; 
    
    Integer userId = (Integer) session.getAttribute("userId");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int courseCount = 0;
    int sumMarks = 0;
    int sumAttend = 0;

    // Variables for the Global Assignment Circle
    int totalAssignmentMarks = 0;
    int totalAssignmentPossible = 0;
    int overallAssignmentPercentage = 0;

    try {
        con = DBConnection.getConnection();
        
        // Fetch Course Data
        ps = con.prepareStatement("SELECT * FROM student_data WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        // Calculate Global Assignment Aggregation
        String aggQuery = "SELECT SUM(s.marks_awarded) as total_earned, " +
                         "SUM((SELECT COUNT(*) FROM assignment_questions aq WHERE aq.assignment_id = s.assignment_id)) as total_possible " +
                         "FROM student_submissions s WHERE s.student_id = ?";
        
        PreparedStatement psAgg = con.prepareStatement(aggQuery);
        psAgg.setInt(1, userId);
        ResultSet rsAgg = psAgg.executeQuery();
        
        if(rsAgg.next()) {
            totalAssignmentMarks = rsAgg.getInt("total_earned");
            totalAssignmentPossible = rsAgg.getInt("total_possible");
            if(totalAssignmentPossible > 0) {
                overallAssignmentPercentage = (totalAssignmentMarks * 100) / totalAssignmentPossible;
            }
        }
        rsAgg.close();
        psAgg.close();
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* =========================================================================
           ULTRA PREMIUM GLASSY CYAN THEME (MINIMALIST & INDUSTRY STANDARD)
           ========================================================================= */
        :root {
            /* Calm, clean minimalist white base */
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --sidebar-bg: rgba(255, 255, 255, 0.85);
            /* Premium Cyan Accents */
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
        }

        [data-theme="dark"] {
            /* Sleek, deep slate for dark mode */
            --bg-color: #0b1121; 
            --glass-bg: rgba(15, 23, 42, 0.7);
            --glass-border: rgba(0, 242, 254, 0.15);
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --sidebar-bg: rgba(11, 17, 33, 0.85);
            --cyan-glow: rgba(0, 242, 254, 0.25);
        }

        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--bg-color); 
            /* Subtle radial gradient for depth */
            background-image: radial-gradient(circle at 15% 50%, var(--cyan-glow), transparent 25%), 
                              radial-gradient(circle at 85% 30%, var(--cyan-glow), transparent 25%);
            background-attachment: fixed;
            color: var(--text-color); 
            transition: 0.3s; 
            margin: 0; 
        }

        .wrapper { display: flex; min-height: 100vh; }

        /* --- Glassmorphism Sidebar --- */
        .sidebar { 
            width: 260px; 
            background: var(--sidebar-bg); 
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border);
            color: var(--text-color); 
            position: fixed; 
            height: 100vh; 
            padding: 30px 20px; 
            z-index: 1000; 
            box-shadow: 4px 0 24px rgba(0,0,0,0.02);
        }
        
        .sidebar-menu { list-style: none; padding: 0; margin-top: 40px; }
        .sidebar-menu-link { 
            display: flex; align-items: center; gap: 15px; padding: 14px 18px; 
            color: var(--text-muted); text-decoration: none; border-radius: 12px; 
            margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500;
        }
        
        .sidebar-menu-link:hover, .sidebar-menu-link.active { 
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.1), rgba(79, 172, 254, 0.15)); 
            color: var(--cyan-secondary); 
            box-shadow: 0 4px 15px var(--cyan-glow); 
            border: 1px solid rgba(0, 242, 254, 0.2);
        }

        /* --- Main Content Area --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px 50px; }

        /* --- Reusable Glass Card Utility --- */
        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            padding: 25px;
        }
        
        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px var(--cyan-glow);
            border-color: rgba(0, 242, 254, 0.3);
        }

        /* KPI Stat Cards */
        .stat-card { text-align: center; }
        .stat-icon {
            font-size: 2.5rem;
            background: -webkit-linear-gradient(var(--cyan-primary), var(--cyan-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            display: inline-block;
        }

        /* Enrolled Courses */
        .course-card { padding: 25px; margin-bottom: 20px; overflow: hidden; }
        
        .badge-marks { 
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary)); 
            color: #ffffff; padding: 6px 14px; border-radius: 20px; font-weight: 600; 
            box-shadow: 0 4px 12px var(--cyan-glow);
        }

        .progress-cyan {
            background: linear-gradient(90deg, var(--cyan-primary), var(--cyan-secondary));
            box-shadow: 0 0 10px var(--cyan-glow);
        }

        /* --- Premium Performance Circle (Static, Elegant) --- */
        .premium-circle-wrapper {
            position: relative;
            width: 174px; 
            height: 174px;
            border-radius: 50%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.4), rgba(79, 172, 254, 0.4));
            padding: 3px; /* Creates the static gradient border */
            box-shadow: 0 10px 30px var(--cyan-glow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .premium-circle-wrapper:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(0, 242, 254, 0.3);
        }

        .progress-circle {
            width: 100%; 
            height: 100%;
            /* Inner data ring */
            background: radial-gradient(closest-side, var(--glass-bg) 79%, transparent 80% 100%),
                        conic-gradient(var(--cyan-secondary) <%= overallAssignmentPercentage %>%, rgba(0,0,0,0.05) 0);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            position: relative;
        }
        
        [data-theme="dark"] .progress-circle {
            background: radial-gradient(closest-side, var(--glass-bg) 79%, transparent 80% 100%),
                        conic-gradient(var(--cyan-secondary) <%= overallAssignmentPercentage %>%, rgba(255,255,255,0.05) 0);
        }

        .progress-circle::after {
            content: "<%= overallAssignmentPercentage %>%";
            font-weight: 700; font-size: 28px; color: var(--text-color);
        }

        /* =========================================================================
           CYAN GLASSY STYLING FOR HEADERS AND EMPTY STATES
           ========================================================================= */

        /* 1. Stunning Cyan Glowing Header */
        .premium-header {
            position: relative;
            display: inline-block;
            padding-bottom: 8px;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: var(--text-color);
        }
        .premium-header::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, var(--cyan-primary), var(--cyan-secondary));
            border-radius: 4px;
            box-shadow: 0 0 10px var(--cyan-glow);
        }

        /* 2. Premium Static Gradient Wrappers */
        .progress-premium-wrapper, .empty-premium-wrapper {
            position: relative;
            width: 100%;
            padding: 2px; /* Controls border thickness */
            border-radius: 16px; 
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.3), rgba(79, 172, 254, 0.1)); 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03); 
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
        }

        .progress-premium-wrapper:hover, .empty-premium-wrapper:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px var(--cyan-glow);
        }

        /* 3. Inner Glass Masks */
        .progress-inner-card, .empty-inner-glass {
            position: relative;
            background: var(--glass-bg); 
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 14px; /* Slightly smaller than outer wrapper to show border */
            z-index: 1; 
        }

        .progress-inner-card {
            padding: 25px;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .empty-inner-glass {
            padding: 40px 20px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        /* Badges & Icons */
        .badge-cyan-glass {
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.15), rgba(79, 172, 254, 0.25));
            backdrop-filter: blur(5px);
            border: 1px solid rgba(0, 242, 254, 0.4);
            color: var(--cyan-secondary);
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
        }

        .empty-icon {
            font-size: 3rem;
            background: -webkit-linear-gradient(var(--cyan-primary), var(--cyan-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            filter: drop-shadow(0 4px 8px var(--cyan-glow));
        }

        .empty-text {
            color: var(--text-color);
            font-size: 1.15rem;
            font-weight: 600;
            margin: 0;
        }

        /* Misc */
        .btn-theme { border-color: var(--cyan-secondary); color: var(--cyan-secondary); }
        .btn-theme:hover { background: var(--cyan-secondary); color: white; border-color: var(--cyan-secondary); }
        .logout-btn { color: #ef4444; border: 1px solid #ef4444; border-radius: 12px; padding: 12px; width: 100%; display: block; text-align: center; text-decoration: none; margin-top: 50px; font-weight: 500; transition: 0.3s; }
        .logout-btn:hover { background: #fef2f2; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); }
        [data-theme="dark"] .logout-btn:hover { background: rgba(239, 68, 68, 0.1); }
    </style>
</head>
<body>

<div class="wrapper">
    <nav class="sidebar">
        <div class="text-center mb-4">
            <h4 class="fw-bold" style="color: var(--text-color);"><i class="fas fa-graduation-cap me-2" style="color: var(--cyan-primary);"></i> EduStream</h4>
            <small class="text-muted">Student Panel</small>
        </div>
        <ul class="sidebar-menu">
            <li><a href="studentDashboard.jsp" class="sidebar-menu-link active"><i class="fas fa-th-large"></i> Dashboard</a></li>
            <li><a href="trail.html" class="sidebar-menu-link"><i class="fas fa-book"></i> My Courses</a></li>
            <li><a href="assessment_dashboard.jsp" class="sidebar-menu-link"><i class="fas fa-file-alt"></i> Assessment</a></li>
            <li><a href="assignments" class="sidebar-menu-link"><i class="fas fa-tasks"></i> Assignment</a></li>
           <li><a href="studentQuestionBank.jsp" class="sidebar-menu-link"><i class="fas fa-question-circle"></i> Question Bank</a></li>
            
            <!-- NEW: Added Leaderboard Link for Students to check their rank -->
            <li><a href="LeaderboardServlet" class="sidebar-menu-link"><i class="fas fa-trophy"></i> Leaderboard</a></li>
            
            <li><a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold m-0">Welcome, <%= studentName %>!</h2>
            <button id="theme-toggle" class="btn btn-theme btn-sm px-3 rounded-pill"><i class="fas fa-moon me-1"></i> Mode</button>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="glass-card stat-card">
                    <i class="fas fa-book stat-icon"></i>
                    <h3 id="stat-courses" class="fw-bold">0</h3>
                    <p class="text-muted mb-0">Total Courses</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card stat-card">
                    <i class="fas fa-star stat-icon"></i>
                    <h3 id="stat-marks" class="fw-bold">0</h3>
                    <p class="text-muted mb-0">Average Marks</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card stat-card">
                    <i class="fas fa-calendar-check stat-icon"></i>
                    <h3 id="stat-attend" class="fw-bold">0%</h3>
                    <p class="text-muted mb-0">Attendance Rate</p>
                </div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-12">
                <div class="glass-card text-center py-5">
                    <h4 class="premium-header mb-4">Overall Assignment Performance</h4>
                    
                    <div class="premium-circle-wrapper mt-3">
                        <div class="progress-circle"></div>
                    </div>

                    <p class="mt-4 text-muted fs-5">
                        You have earned <strong style="color: var(--text-color);"><%= totalAssignmentMarks %></strong> out of 
                        <strong style="color: var(--text-color);"><%= totalAssignmentPossible %></strong> total points.
                    </p>
                </div>
            </div>
        </div>

        <h4 class="mb-4 premium-header">My Enrolled Courses</h4>
        <div class="row mb-5">
            <% 
                while(rs.next()) { 
                    courseCount++;
                    int marks = rs.getInt("marks");
                    int attend = rs.getInt("attendance");
                    sumMarks += marks;
                    sumAttend += attend;
            %>
            <div class="col-md-6">
                <div class="glass-card course-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0"><%= rs.getString("course") %></h5>
                        <span class="badge-marks"><%= marks %>/100</span>
                    </div>
                    <div class="progress mb-3" style="height: 10px; background-color: var(--glass-border); border-radius: 10px;">
                        <div class="progress-bar progress-cyan" style="width: <%= attend %>%; border-radius: 10px;"></div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small class="text-muted">COURSE ID: #<%= rs.getInt("id") %></small>
                        <small class="fw-bold">Attendance: <%= attend %>%</small>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <h4 class="mb-4 mt-5 premium-header">My Assessment Progress</h4>
        <div class="row mb-5">
            <%
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                
                String latestScoreQuery = "SELECT a.assessment_id, a.title, a.total_questions, s.marks_scored " +
                                          "FROM student_scores s " +
                                          "JOIN assessments a ON s.assessment_id = a.assessment_id " +
                                          "WHERE s.student_id = ? " +
                                          "AND s.attempt_date = (SELECT MAX(attempt_date) FROM student_scores s2 WHERE s2.student_id = s.student_id AND s2.assessment_id = s.assessment_id) " +
                                          "ORDER BY s.attempt_date DESC";
                                          
                ps = con.prepareStatement(latestScoreQuery);
                ps.setInt(1, userId);
                rs = ps.executeQuery();
                
                boolean hasAssessments = false;
                while(rs.next()) {
                    hasAssessments = true;
                    int astId = rs.getInt("assessment_id");
                    String testTitle = rs.getString("title");
                    int marks = rs.getInt("marks_scored");
                    int total = rs.getInt("total_questions");
                    int percentage = (total > 0) ? (marks * 100 / total) : 0;
            %>
            <div class="col-md-6">
                <div class="progress-premium-wrapper">
                    <div class="progress-inner-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0"><%= testTitle %></h5>
                            <div class="d-flex align-items-center gap-3">
                                <span class="badge-cyan-glass"><%= marks %> / <%= total %></span>
                            </div>
                        </div>
                        <div class="progress mb-3" style="height: 10px; background-color: var(--glass-border); border-radius: 10px;">
                            <div class="progress-bar progress-cyan" role="progressbar" style="width: <%= percentage %>%; border-radius: 10px;"></div>
                        </div>
                        <small class="text-muted fw-medium">Status: Latest Attempt Recorded</small>
                    </div>
                </div>
            </div>
            <%  } 
                if(!hasAssessments) { 
            %>
                <div class="col-12">
                    <div class="empty-premium-wrapper">
                        <div class="empty-inner-glass">
                            <i class="fas fa-file-alt empty-icon"></i>
                            <p class="empty-text">No assessments taken yet. Visit the Assessment panel to start.</p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <h4 class="mb-4 mt-5 premium-header">My Assignment Progress</h4>
        <div class="row">
            <%
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                
                String assignQuery = "SELECT a.assignment_id, a.title, s.marks_awarded, " +
                                     "(SELECT COUNT(*) FROM assignment_questions aq WHERE aq.assignment_id = a.assignment_id) as total_questions " +
                                     "FROM student_submissions s " +
                                     "JOIN assignments a ON s.assignment_id = a.assignment_id " +
                                     "WHERE s.student_id = ? " +
                                     "ORDER BY s.marks_awarded DESC"; 
                                           
                ps = con.prepareStatement(assignQuery);
                ps.setInt(1, userId);
                rs = ps.executeQuery();
                
                boolean hasAssignments = false;
                java.util.HashSet<Integer> seenAssignments = new java.util.HashSet<>();
                
                while(rs.next()) {
                    int assignId = rs.getInt("assignment_id");
                    if(seenAssignments.contains(assignId)) { continue; }
                    seenAssignments.add(assignId);
                    
                    hasAssignments = true;
                    String assignmentTitle = rs.getString("title");
                    int aMarks = rs.getInt("marks_awarded");
                    int aTotal = rs.getInt("total_questions");
                    if (aTotal == 0) aTotal = 5; 
                    int aPercentage = (aTotal > 0) ? (aMarks * 100 / aTotal) : 0;
            %>
            <div class="col-md-6">
                <div class="progress-premium-wrapper">
                    <div class="progress-inner-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0"><%= assignmentTitle %></h5>
                            <div class="d-flex align-items-center gap-3">
                                <span class="badge-cyan-glass"><%= aMarks %> / <%= aTotal %></span>
                            </div>
                        </div>
                        <div class="progress mb-3" style="height: 10px; background-color: var(--glass-border); border-radius: 10px;">
                            <div class="progress-bar progress-cyan" role="progressbar" style="width: <%= aPercentage %>%; border-radius: 10px;"></div>
                        </div>
                        <small class="text-muted fw-medium">Status: Evaluated</small>
                    </div>
                </div>
            </div>
            <%  } 
                if(!hasAssignments) { 
            %>
                <div class="col-12">
                    <div class="empty-premium-wrapper">
                        <div class="empty-inner-glass">
                            <i class="fas fa-tasks empty-icon"></i>
                            <p class="empty-text">No assignments completed yet. Visit the Assignment panel to start.</p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </main>
</div>

<script>
    document.getElementById('stat-courses').innerText = "<%= courseCount %>";
    document.getElementById('stat-marks').innerText = "<%= courseCount > 0 ? (sumMarks/courseCount) : 0 %>";
    document.getElementById('stat-attend').innerText = "<%= courseCount > 0 ? (sumAttend/courseCount) : 0 %>%";

    const btn = document.getElementById('theme-toggle');
    btn.addEventListener('click', () => {
        const doc = document.documentElement;
        const theme = doc.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        doc.setAttribute('data-theme', theme);
        
        // Toggle icon visual
        const icon = btn.querySelector('i');
        if(theme === 'dark') {
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        } else {
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
        }
    });
</script>
</body>
</html>
<%
    } catch(Exception e) { e.printStackTrace(); }
    finally {
        if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close();
    }
%>