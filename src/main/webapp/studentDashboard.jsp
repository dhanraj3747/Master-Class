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

    int totalAssignmentMarks = 0;
    int totalAssignmentPossible = 0;
    int overallAssignmentPercentage = 0;

    try {
        con = DBConnection.getConnection();
        
        ps = con.prepareStatement("SELECT * FROM student_data WHERE user_id=?", 
                          ResultSet.TYPE_SCROLL_INSENSITIVE, 
                          ResultSet.CONCUR_READ_ONLY);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        while(rs.next()){
            courseCount++;
            sumMarks += rs.getInt("marks");
            sumAttend += rs.getInt("attendance");
        }

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
    <title>Student Dashboard | Edutree-Stars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --sidebar-bg: rgba(255, 255, 255, 0.95);
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.1); /* Lighter glow */
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
            --red-danger: #ef4444;
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
            background-image: radial-gradient(circle at 0% 0%, rgba(0, 242, 254, 0.15), transparent 40%), 
                              radial-gradient(circle at 100% 100%, rgba(0, 242, 254, 0.15), transparent 40%);
            background-attachment: fixed; 
            color: var(--text-color); 
            transition: 0.3s; 
            margin: 0; 
        }

        .wrapper { display: flex; min-height: 100vh; }

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

        .sidebar-menu { list-style: none; padding: 0; margin-top: 40px; }
        
        .sidebar-menu-link { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
            padding: 14px 18px; 
            color: var(--text-muted); 
            text-decoration: none; 
            border-radius: 12px; 
            margin-bottom: 8px; 
            transition: 0.3s; 
            font-weight: 500;
            border: 1px solid transparent;
        }

        /* FIXED: No solid fill on hover, just a light border and glow */
        .sidebar-menu-link:hover, .sidebar-menu-link.active { 
            background: rgba(0, 242, 254, 0.08); 
            color: var(--cyan-secondary); 
            border: 1px solid rgba(0, 242, 254, 0.3);
            box-shadow: 0 4px 12px rgba(0, 242, 254, 0.1);
        }

        .main-content { margin-left: 280px; flex: 1; padding: 40px 50px; }
        
        .glass-card {
            background: var(--glass-bg); 
            backdrop-filter: blur(20px); 
            border: 1px solid var(--glass-border); 
            border-radius: 20px; 
            padding: 25px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            transition: 0.3s;
        }
        
        .glass-card:hover { transform: translateY(-5px); box-shadow: 0 20px 45px rgba(0, 242, 254, 0.15); }

        .stat-icon { 
            font-size: 2.5rem; 
            background: var(--cyan-gradient); 
            -webkit-background-clip: text; 
            -webkit-text-fill-color: transparent; 
        }

        .badge-count {
            position: absolute; top: -6px; right: -6px;
            background-color: var(--red-danger); color: white;
            font-size: 0.75rem; font-weight: 700;
            min-width: 22px; height: 22px; border-radius: 50%;
            display: none; align-items: center; justify-content: center;
            border: 2px solid #ffffff; z-index: 10;
        }

        .premium-circle-wrapper {
            position: relative; width: 174px; height: 174px; border-radius: 50%; margin: 0 auto;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.4), rgba(79, 172, 254, 0.4));
            padding: 3px;
        }

        .progress-circle {
            width: 100%; height: 100%; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            background: radial-gradient(closest-side, var(--glass-bg) 79%, transparent 80% 100%), 
                        conic-gradient(var(--cyan-secondary) <%= overallAssignmentPercentage %>%, rgba(0,0,0,0.05) 0);
        }
        .progress-circle::after { content: "<%= overallAssignmentPercentage %>%"; font-weight: 700; font-size: 28px; }

        /* --- THE FIXED LOGOUT BUTTON (Matching the Outlined Admin Style) --- */
        .logout-btn { 
            color: var(--red-danger); 
            border: 1.5px solid rgba(239, 68, 68, 0.3); 
            background: transparent;
            border-radius: 12px; 
            padding: 12px 18px; 
            width: 100%; 
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            text-decoration: none !important; 
            margin-top: 50px; 
            font-weight: 600;
            transition: 0.3s all ease;
        }
        
        /* FIXED: Hover is now transparent, NOT a solid red block */
        .logout-btn:hover { 
            background: rgba(239, 68, 68, 0.06); /* Very subtle transparent tint */
            color: var(--red-danger) !important; 
            border-color: var(--red-danger);
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.15);
            transform: translateY(-2px);
        }

    </style>
</head>
<body>

<div class="wrapper">
    <nav class="sidebar">
        <div class="text-center mb-4">
            <h4 class="fw-bold"><i class="fas fa-layer-group me-2" style="color: var(--cyan-primary);"></i> Edutree-Stars</h4>
        </div>
        <ul class="sidebar-menu">
            <li><a href="studentDashboard.jsp" class="sidebar-menu-link active"><i class="fas fa-th-large"></i> Dashboard</a></li>
            <li><a href="myLearning.jsp" class="sidebar-menu-link"><i class="fas fa-book"></i> My Learning</a></li>
            <li><a href="trail.html" class="sidebar-menu-link"><i class="fas fa-file-alt"></i> Courses</a></li>
            <li><a href="leaderboard.jsp" class="sidebar-menu-link"><i class="fas fa-trophy"></i> Leaderboard</a></li>
            <li><a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
        </ul>
    </nav>

    <main class="content main-content">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold m-0">Welcome back, <%= studentName %>!</h2>
            
            <div class="header-actions d-flex gap-3">
                <div class="dropdown">
                    <div class="icon-box" id="notifBell" data-bs-toggle="dropdown" aria-expanded="false" style="width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; cursor: pointer; position: relative; border: 1px solid var(--glass-border); background: var(--glass-bg);">
                        <i class="far fa-bell"></i>
                        <span class="badge-count" id="notifBadge">0</span>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end glass-card notif-dropdown shadow-lg">
                        <li class="p-3 border-bottom"><h6 class="m-0 fw-bold">Live Updates (Last 5m)</h6></li>
                        <div id="notifContainer">
                            <li><a class="dropdown-item text-muted text-center py-4">No active updates</a></li>
                        </div>
                    </ul>
                </div>
                <button id="theme-toggle" class="btn border-info text-info rounded-pill px-4"><i class="fas fa-moon me-2"></i> Mode</button>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="glass-card text-center">
                    <i class="fas fa-book stat-icon mb-2"></i>
                    <h3 class="fw-bold"><%= courseCount %></h3>
                    <p class="text-muted mb-0">Enrolled Courses</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card text-center">
                    <i class="fas fa-star stat-icon mb-2"></i>
                    <h3 class="fw-bold"><%= courseCount > 0 ? (sumMarks/courseCount) : 0 %></h3>
                    <p class="text-muted mb-0">Average Marks</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card text-center">
                    <i class="fas fa-calendar-check stat-icon mb-2"></i>
                    <h3 class="fw-bold"><%= courseCount > 0 ? (sumAttend/courseCount) : 0 %>%</h3>
                    <p class="text-muted mb-0">Attendance Rate</p>
                </div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-12">
                <div class="glass-card text-center py-5">
                    <h4 class="fw-bold mb-4">Overall Assignment Performance</h4>
                    <div class="premium-circle-wrapper mt-3"><div class="progress-circle"></div></div>
                    <p class="mt-4 text-muted">You earned <strong><%= totalAssignmentMarks %></strong> of <strong><%= totalAssignmentPossible %></strong> points.</p>
                </div>
            </div>
        </div>
        
        <h4 class="mb-4 fw-bold">My Active Learning</h4>
        <div class="row">
            <% rs.beforeFirst(); 
               while(rs.next()) { %>
            <div class="col-md-6 mb-4">
                <div class="glass-card">
                    <div class="d-flex justify-content-between mb-3">
                        <h5 class="fw-bold m-0"><%= rs.getString("course") %></h5>
                        <span class="badge bg-info rounded-pill px-3 py-2"><%= rs.getInt("marks") %> / 100</span>
                    </div>
                    <div class="progress" style="height: 10px; border-radius: 10px; background: rgba(0,0,0,0.05);">
                        <div class="progress-bar" style="width: <%= rs.getInt("attendance") %>%; background: var(--cyan-gradient); border-radius: 10px;"></div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let seenNotificationIds = new Set();

    function fetchUpdates() {
        fetch('NotificationServlet')
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('notifContainer');
                const badge = document.getElementById('notifBadge');
                
                if(data && data.length > 0) {
                    const now = new Date().getTime();
                    const activeNotifs = data.filter(note => (now - note.timestamp) <= 300000);
                    
                    container.innerHTML = '';
                    
                    if (activeNotifs.length > 0) {
                        badge.style.display = 'flex';
                        badge.innerText = activeNotifs.length;

                        activeNotifs.forEach(note => {
                            let icon = note.type.includes("CSV") ? "fa-file-csv" : "fa-plus-circle";
                            let color = note.type.includes("CSV") ? "text-success" : "text-primary";
                            
                            if (!seenNotificationIds.has(note.id)) {
                                seenNotificationIds.add(note.id);
                                showPopup(`New \${note.type} in \${note.folder}`);
                            }

                            container.innerHTML += `
                                <li class="notif-item p-3">
                                    <div class="d-flex align-items-start gap-3">
                                        <div style="background: rgba(0,0,0,0.03); padding: 8px; border-radius: 10px;">
                                            <i class="fas \${icon} \${color} fa-lg"></i>
                                        </div>
                                        <div style="flex: 1;">
                                            <div class="small fw-bold">\${note.type}</div>
                                            <div class="text-muted" style="font-size: 0.8rem;">
                                                Tech: <span class="badge bg-info text-dark" style="font-size: 0.65rem;">\${note.folder}</span><br>
                                                \${note.fileName}
                                            </div>
                                            <div class="text-muted mt-1" style="font-size: 0.65rem;">
                                                <i class="fas fa-clock me-1"></i> Disappears soon
                                            </div>
                                        </div>
                                    </div>
                                </li>`;
                        });
                    } else {
                        badge.style.display = 'none';
                        container.innerHTML = '<li><a class="dropdown-item text-muted text-center py-4">No active updates</a></li>';
                    }
                }
            })
            .catch(err => console.error("Notif Error:", err));
    }

    function showPopup(msg) {
        document.getElementById('toastMessage').innerHTML = `<i class="fas fa-bell me-2"></i> \${msg}`;
        const toast = new bootstrap.Toast(document.getElementById('uploadToast'), { delay: 6000 });
        toast.show();
    }

    document.getElementById('theme-toggle').addEventListener('click', () => {
        const doc = document.documentElement;
        const theme = doc.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        doc.setAttribute('data-theme', theme);
        document.getElementById('theme-toggle').innerHTML = theme === 'dark' ? '<i class="fas fa-sun me-2"></i> Mode' : '<i class="fas fa-moon me-2"></i> Mode';
    });

    fetchUpdates();
    setInterval(fetchUpdates, 5000);
</script>
</body>
</html>
<%
    } catch(Exception e) { e.printStackTrace(); }
    finally { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); }
%>