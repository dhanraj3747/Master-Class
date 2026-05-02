<%@ page import="java.sql.*,com.project.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
String role = (String) session.getAttribute("role");

if(role == null || !role.equals("admin")) {
    response.sendRedirect("login.jsp");
}

Connection con = DBConnection.getConnection();
Statement st = con.createStatement();
ResultSet rs = st.executeQuery(
"SELECT u.name, s.course, s.marks, s.attendance FROM users u JOIN student_data s ON u.id = s.user_id");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f7fe;
            min-height: 100vh;
            color: #333;
        }

        .main-container { display: flex; height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: #1e293b;
            color: white;
            padding: 30px 0;
            position: fixed;
            height: 100vh;
            z-index: 100;
        }

        .sidebar-header { padding: 0 25px 30px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-menu { list-style: none; padding: 20px 15px; }
        .sidebar-menu a {
            display: flex; align-items: center; gap: 12px; padding: 12px 15px;
            color: #94a3b8; text-decoration: none; border-radius: 8px; transition: 0.3s;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: #334155; color: white;
        }
        .sidebar-menu a.active { background: #4f46e5; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4); }

        /* Content Area */
        .main-content { margin-left: 260px; flex: 1; padding: 30px; overflow-y: auto; }

        .dashboard-header {
            background: white; padding: 20px 30px; border-radius: 16px;
            margin-bottom: 30px; display: flex; justify-content: space-between;
            align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }

        /* Stats Section */
        .stats-bar { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card {
            background: white; padding: 25px; border-radius: 16px; text-align: center;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border-bottom: 4px solid #4f46e5;
        }
        .stat-card h3 { font-size: 2rem; font-weight: 800; margin: 10px 0; color: #1e293b; }

        /* --- QUESTION BANK SECTION --- */
        .section-title { font-weight: 700; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        
        .qbank-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .qbank-card {
            background: white;
            padding: 20px;
            border-radius: 16px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            border: 1px solid transparent;
        }

        .qbank-card:hover {
            transform: translateY(-5px);
            border-color: #4f46e5;
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.2);
        }

        .qbank-card i { font-size: 2.5rem; margin-bottom: 15px; }
        .qbank-card h5 { font-weight: 700; margin-bottom: 5px; }
        .qbank-card p { font-size: 0.8rem; color: #64748b; margin: 0; }

        /* Colors for Icons */
        .icon-html { color: #e34f26; }
        .icon-css { color: #1572b6; }
        .icon-js { color: #f7df1e; }
        .icon-react { color: #61dafb; }
        .icon-java { color: #007396; }
        .icon-sql { color: #4479a1; }
        .icon-interview { color: #8b5cf6; }

        /* Student Cards */
        .cards-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .student-card {
            background: white; border-radius: 16px; padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border-left: 5px solid #4f46e5;
        }
        .marks-badge { background: #e0e7ff; color: #4338ca; padding: 5px 12px; border-radius: 20px; font-weight: 700; }
        
        .btn-view { background: #4f46e5; color: white; border: none; padding: 8px 16px; border-radius: 8px; text-decoration: none; }
        .btn-view:hover { background: #4338ca; color: white; }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; }
            .stats-bar { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h4><i class="fas fa-shield-alt"></i> Admin Panel</h4>
                <p class="small text-muted">Management System</p>
            </div>
            <ul class="sidebar-menu">
                <li><a href="" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="#"><i class="fas fa-users"></i> Students</a></li>
                <li><a href="#"><i class="fas fa-book-open"></i> Courses</a></li>
                <li><a href="questionportal.jsp"><i class="fas fa-question-circle"></i> Question Bank</a></li>
                
                <!-- NEW: LEADERBOARD LINK ADDED HERE -->
                <li><a href="LeaderboardServlet"><i class="fas fa-trophy"></i> Leaderboard</a></li>
                
                <li><a href="#" onclick="confirmLogout()" style="color: #ef4444;"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="dashboard-header">
                <h3>Welcome back, <strong>dhanraj3747</strong></h3>
                <div class="d-flex align-items-center gap-3">
                    <span class="badge bg-light text-dark p-2 border"><i class="far fa-clock"></i> <span id="currentTime"></span></span>
                </div>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-card">
                    <i class="fas fa-user-graduate text-primary mb-2"></i>
                    <p class="text-muted mb-0">Total Students</p>
                    <h3 id="totalStudents">0</h3>
                </div>
                <div class="stat-card">
                    <i class="fas fa-star text-warning mb-2"></i>
                    <p class="text-muted mb-0">Average Marks</p>
                    <h3 id="avgMarks">0</h3>
                </div>
                <div class="stat-card">
                    <i class="fas fa-check-double text-success mb-2"></i>
                    <p class="text-muted mb-0">Attendance Rate</p>
                    <h3 id="avgAttendance">0%</h3>
                </div>
            </div>

            <!-- QUESTION BANK SECTION -->
            <h4 class="section-title"><i class="fas fa-database text-primary"></i> Question Bank & Interview Prep</h4>
            <div class="qbank-grid">
                <!-- Each link leads to a generic questions.jsp where you can filter by tech -->
                <a href="viewQuestions.jsp?tech=html" class="qbank-card">
                    <i class="fab fa-html5 icon-html"></i>
                    <h5>HTML5</h5>
                    <p>50+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=css" class="qbank-card">
                    <i class="fab fa-css3-alt icon-css"></i>
                    <h5>CSS3</h5>
                    <p>40+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=js" class="qbank-card">
                    <i class="fab fa-js icon-js"></i>
                    <h5>JavaScript</h5>
                    <p>100+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=react" class="qbank-card">
                    <i class="fab fa-react icon-react"></i>
                    <h5>React JS</h5>
                    <p>30+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=java" class="qbank-card">
                    <i class="fab fa-java icon-java"></i>
                    <h5>Java Core</h5>
                    <p>80+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=sql" class="qbank-card">
                    <i class="fas fa-database icon-sql"></i>
                    <h5>SQL / MySQL</h5>
                    <p>60+ Questions</p>
                </a>
                <a href="viewQuestions.jsp?tech=interview" class="qbank-card" style="background: #f5f3ff;">
                    <i class="fas fa-user-tie icon-interview"></i>
                    <h5 style="color: #7c3aed;">Interview Prep</h5>
                    <p>HR & Tech rounds</p>
                </a>
            </div>

            <!-- Student List Section -->
            <h4 class="section-title"><i class="fas fa-user-friends text-primary"></i> Recent Students</h4>
            <div class="cards-container">
                <%
                int count = 0, tMarks = 0, tAttend = 0;
                while(rs.next()) {
                    count++;
                    String name = rs.getString("name");
                    int mark = rs.getInt("marks");
                    int attend = rs.getInt("attendance");
                    tMarks += mark; tAttend += attend;
                %>
                    <div class="student-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0"><strong><%= name %></strong></h5>
                            <span class="marks-badge"><%= mark %>/100</span>
                        </div>
                        <p class="text-muted small mb-2"><i class="fas fa-code"></i> Course: <%= rs.getString("course") %></p>
                        <div class="progress mb-3" style="height: 8px;">
                            <div class="progress-bar bg-success" style="width: <%= attend %>%"></div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <small>Attendance: <%= attend %>%</small>
                            <a href="studentDashboard.jsp" class="btn-view btn-sm">View Profile</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
     
    <script>
        function updateTime() {
            document.getElementById('currentTime').textContent = new Date().toLocaleTimeString();
        }
        setInterval(updateTime, 1000); updateTime();

        // Pass JSP data to JS for stats
        document.getElementById('totalStudents').textContent = "<%= count %>";
        document.getElementById('avgMarks').textContent = "<%= (count > 0) ? (tMarks/count) : 0 %>";
        document.getElementById('avgAttendance').textContent = "<%= (count > 0) ? (tAttend/count) : 0 %>%";

        function confirmLogout() {
            if(confirm("Are you sure you want to logout?")) window.location.href='logout.jsp';
        }
    </script>
    
</body>
</html>