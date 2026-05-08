<%@ page import="java.sql.*,com.project.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // 1. Session & Role Protection
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Database Connection
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();
    
    ResultSet rs = st.executeQuery(
        "SELECT u.name, MAX(s.course) as course, AVG(s.marks) as marks, AVG(s.attendance) as attendance " +
        "FROM users u " +
        "JOIN student_data s ON u.id = s.user_id " +
        "WHERE u.role = 'student' " +
        "GROUP BY u.id, u.name"
    );
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Edutree-Stars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* =========================================================================
           ULTRA-PREMIUM CYAN PALETTE (Direct Reference from login.jsp)
           ========================================================================= */
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
            --sidebar-bg: rgba(255, 255, 255, 0.9);
        }

        [data-theme="dark"] {
            --bg-color: #0f172a; 
            --glass-bg: rgba(30, 41, 59, 0.8);
            --glass-border: rgba(255, 255, 255, 0.1);
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --sidebar-bg: rgba(15, 23, 42, 0.95);
        }

        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--bg-color); 
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color); 
            transition: 0.3s; 
        }

        .wrapper { display: flex; min-height: 100vh; }

        /* --- Sidebar Style --- */
        .sidebar { 
            width: 280px; 
            background: var(--sidebar-bg); 
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--glass-border);
            position: fixed; 
            height: 100vh; 
            padding: 30px 20px; 
            z-index: 1000; 
        }
        
        .sidebar-menu { list-style: none; padding: 0; margin-top: 30px; }
        .sidebar-menu-link { 
            display: flex; align-items: center; gap: 15px; padding: 12px 18px; 
            color: var(--text-muted); text-decoration: none; border-radius: 12px; 
            margin-bottom: 8px; transition: 0.3s; font-weight: 500;
        }
        
        .sidebar-menu-link:hover, .sidebar-menu-link.active { 
            background: var(--cyan-glow); 
            color: var(--cyan-secondary); 
            box-shadow: 0 4px 15px var(--cyan-glow);
        }

        .main-content { margin-left: 280px; flex: 1; padding: 40px; }

        /* --- Glass Cards (Matches Enterprise Card in Login) --- */
        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            padding: 25px;
            transition: all 0.3s ease;
        }
        
        .glass-card:hover { 
            transform: translateY(-5px);
            border-color: var(--cyan-secondary);
            box-shadow: 0 20px 45px var(--cyan-glow);
        }

        .stat-icon {
            font-size: 2rem;
            color: var(--cyan-secondary);
            filter: drop-shadow(0 0 8px var(--cyan-glow));
        }

        .premium-header {
            position: relative;
            font-weight: 700;
            padding-bottom: 12px;
            color: var(--text-color);
        }
        .premium-header::after {
            content: '';
            position: absolute;
            left: 0; bottom: 0;
            width: 60px; height: 4px;
            background: var(--cyan-gradient);
            border-radius: 10px;
        }

        .logout-btn { 
            color: #ef4444; border: 1px solid #ef4444; border-radius: 12px; 
            padding: 12px; width: 100%; display: block; text-align: center; 
            text-decoration: none; margin-top: 40px; transition: 0.3s; 
            font-weight: 600;
        }
        .logout-btn:hover { background: rgba(239, 68, 68, 0.05); }

        /* Updated Badge & Progress (Matches Button/Icon Glow in Login) */
        .badge-marks { 
            background: var(--cyan-gradient); 
            color: #ffffff; 
            padding: 6px 14px; 
            border-radius: 12px; 
            font-size: 0.85rem; 
            font-weight: 700;
            box-shadow: 0 5px 15px var(--cyan-glow);
        }

        .progress { background: rgba(0, 242, 254, 0.1); border-radius: 20px; height: 8px; }
        .progress-bar { 
            background: var(--cyan-gradient); 
            border-radius: 20px;
            box-shadow: 0 0 10px var(--cyan-glow);
        }
        
        .btn-detailed {
            background: var(--cyan-glow);
            color: var(--cyan-secondary);
            border: 1px solid var(--cyan-secondary);
            border-radius: 30px;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-detailed:hover {
            background: var(--cyan-gradient);
            color: white;
            box-shadow: 0 8px 20px var(--cyan-glow);
        }
    </style>
</head>
<body>

    <div class="wrapper">
        <nav class="sidebar">
            <div class="text-center mb-5">
                <h4 class="fw-bold" style="color: var(--text-color);">
                    <i class="fas fa-layer-group text-info me-2"></i> Edutree-Stars
                </h4>
            </div>
            <ul class="sidebar-menu">
                <li><a href="adminDashboard.jsp" class="sidebar-menu-link active"><i class="fas fa-home"></i> Dashboard</a></li>
                <li>
                    <a href="AnalyticsServlet" class="sidebar-menu-link">
                        <i class="fas fa-chart-line"></i> Student Analytics
                    </a>
                </li>
                <li><a href="trail.html" class="sidebar-menu-link"><i class="fas fa-book-open"></i> Courses</a></li>
                <li><a href="questionportal.jsp" class="sidebar-menu-link"><i class="fas fa-question-circle"></i> Question Bank</a></li>
                <li><a href="leaderboard.jsp" class="sidebar-menu-link"><i class="fas fa-certificate"></i> Leaderboard</a></li>
                <li><a href="#" onclick="confirmLogout()" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-5">
                <h2 class="fw-bold m-0">Admin Overview</h2>
                <div class="d-flex align-items-center gap-3">
                    <button id="theme-toggle" class="btn btn-outline-info btn-sm rounded-pill px-4">
                        <i class="fas fa-moon me-2"></i> Dark Mode
                    </button>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="glass-card text-center">
                        <div class="stat-icon mb-2"><i class="fas fa-user-graduate"></i></div>
                        <h3 id="totalStudents" class="fw-bold">0</h3>
                        <p class="text-muted small mb-0 text-uppercase fw-bold">Active record</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card text-center">
                        <div class="stat-icon mb-2"><i class="fas fa-chart-pie"></i></div>
                        <h3 id="avgMarks" class="fw-bold">0</h3>
                        <p class="text-muted small mb-0 text-uppercase fw-bold">Group Average</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card text-center">
                        <div class="stat-icon mb-2"><i class="fas fa-check-circle"></i></div>
                        <h3 id="avgAttendance" class="fw-bold">0%</h3>
                        <p class="text-muted small mb-0 text-uppercase fw-bold">Overall Attendance</p>
                    </div>
                </div>
            </div>

            <h4 class="premium-header mb-4">Real-Time Student Tracking</h4>
            <div class="row g-4">
                <%
                int count = 0, tMarks = 0, tAttend = 0;
                while(rs.next()) {
                    count++;
                    String name = rs.getString("name");
                    int mark = (int) rs.getDouble("marks"); 
                    int attend = (int) rs.getDouble("attendance"); 
                    tMarks += mark; tAttend += attend;
                %>
                    <div class="col-md-6 col-lg-4">
                        <div class="glass-card h-100">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <h5 class="fw-bold mb-0"><%= name %></h5>
                                <span class="badge-marks"><%= mark %> pts</span>
                            </div>
                            <p class="text-muted small mb-3">
                                <i class="fas fa-graduation-cap me-2 text-info"></i><%= rs.getString("course") %>
                            </p>
                            
                            <div class="mb-4">
                                <div class="d-flex justify-content-between small mb-1">
                                    <span class="fw-bold text-muted">Attendance Progress</span>
                                    <span class="fw-bold text-info"><%= attend %>%</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" style="width: <%= attend %>%"></div>
                                </div>
                            </div>
                            <a href="studentDashboard.jsp" class="btn btn-sm btn-detailed w-100">View Detailed Analytics</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
     
    <script>
        document.getElementById('totalStudents').textContent = "<%= count %>";
        document.getElementById('avgMarks').textContent = "<%= (count > 0) ? (tMarks/count) : 0 %>";
        document.getElementById('avgAttendance').textContent = "<%= (count > 0) ? (tAttend/count) : 0 %>%";

        function confirmLogout() {
            if(confirm("Are you sure you want to logout?")) window.location.href='logout.jsp';
        }

        const btn = document.getElementById('theme-toggle');
        btn.addEventListener('click', () => {
            const doc = document.documentElement;
            const theme = doc.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            doc.setAttribute('data-theme', theme);
            btn.innerHTML = theme === 'dark' ? '<i class="fas fa-sun me-2"></i> Light Mode' : '<i class="fas fa-moon me-2"></i> Dark Mode';
        });
    </script>
</body>
</html>