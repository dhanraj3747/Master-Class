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
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .main-container {
            display: flex;
            height: 100vh;
            gap: 0;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 15px rgba(0, 0, 0, 0.2);
            z-index: 100;
            transition: all 0.3s ease;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }

        .sidebar-header {
            padding: 0 25px 30px 25px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .sidebar-header h4 {
            font-weight: 700;
            font-size: 1.8rem;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.85rem;
            opacity: 0.8;
            margin: 0;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 15px;
        }

        .sidebar-menu li {
            margin-bottom: 8px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding-left: 20px;
        }

        .sidebar-menu a.active {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .sidebar-menu i {
            font-size: 1.1rem;
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background: #f5f7fa;
        }

        .main-content::-webkit-scrollbar {
            width: 8px;
        }

        .main-content::-webkit-scrollbar-track {
            background: transparent;
        }

        .main-content::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        .main-content::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }

        /* Header */
        .dashboard-header {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .dashboard-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dashboard-header .header-info {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .info-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        /* Cards Grid */
        .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .student-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 4px solid #667eea;
            position: relative;
            overflow: hidden;
        }

        .student-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        }

        .student-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(102, 126, 234, 0.3);
            border-left-color: #764ba2;
        }

        .student-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .student-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .student-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
        }

        .student-course {
            font-size: 0.85rem;
            color: #667eea;
            font-weight: 600;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-divider {
            height: 1px;
            background: #e0e6f2;
            margin: 15px 0;
        }

        .stat-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f3f9;
        }

        .stat-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #7f8c9a;
            font-weight: 500;
        }

        .stat-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .marks-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .attendance-badge {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .card-footer {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            justify-content: flex-end;
        }

        .btn-sm-custom {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .btn-view {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-view:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-edit {
            background: #e8f0fe;
            color: #667eea;
            border: 1px solid #667eea;
        }

        .btn-edit:hover {
            background: #667eea;
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c9a;
        }

        .empty-state i {
            font-size: 3rem;
            color: #d4dae6;
            margin-bottom: 15px;
        }

        /* Stats Bar */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            text-align: center;
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: 700;
            margin: 10px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-card p {
            color: #7f8c9a;
            margin: 0;
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .dashboard-header h1 {
                font-size: 1.5rem;
            }

            .cards-container {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .sidebar-menu a {
                display: inline-block;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 15px;
            }

            .dashboard-header {
                padding: 15px;
                margin-bottom: 20px;
            }

            .dashboard-header h1 {
                font-size: 1.3rem;
            }

            .stat-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
        }

        /* Animations */
        .fade-in {
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }

        /* Loading Spinner */
        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Logout Confirmation */
        .modal-custom {
            display: none;
            position: fixed;
            z-index: 200;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.3s ease;
        }

        .modal-custom-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            text-align: center;
        }

        .modal-custom-content h2 {
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .modal-custom-content p {
            color: #7f8c9a;
            margin-bottom: 25px;
        }

        .modal-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .modal-buttons button {
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .modal-buttons .btn-confirm {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .modal-buttons .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(102, 126, 234, 0.4);
        }

        .modal-buttons .btn-cancel {
            background: #e8f0fe;
            color: #667eea;
            border: 1px solid #667eea;
        }

        .modal-buttons .btn-cancel:hover {
            background: #667eea;
            color: white;
        }

        /* Tooltip */
        .tooltip-custom {
            position: relative;
            display: inline-block;
            cursor: help;
        }

        .tooltip-custom .tooltiptext {
            visibility: hidden;
            background-color: #2c3e50;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 8px 12px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            white-space: nowrap;
            font-size: 0.8rem;
            opacity: 0;
            transition: opacity 0.3s;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .tooltip-custom:hover .tooltiptext {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h4><i class="fas fa-cube"></i> Admin Panel</h4>
                <p>Welcome back!</p>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="#" class="active" onclick="setActive(event)">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="#" onclick="setActive(event)">
                        <i class="fas fa-users"></i>
                        <span>Students</span>
                    </a>
                </li>
                <li>
                    <a href="#" onclick="setActive(event)">
                        <i class="fas fa-book"></i>
                        <span>Courses</span>
                    </a>
                </li>
                <li>
                    <a href="#" onclick="setActive(event)">
                        <i class="fas fa-chart-bar"></i>
                        <span>Reports</span>
                    </a>
                </li>
                <li>
                    <a href="#" onclick="setActive(event)">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </li>
                <li style="margin-top: 30px; border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 20px;">
                    <a href="#" style="color: #f5576c;" onclick="confirmLogout()">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div>
                    <h1><i class="fas fa-tachometer-alt"></i> Dashboard</h1>
                </div>
                <div class="header-info">
                    <div class="info-badge">
                        <i class="fas fa-clock"></i>
                        <span id="currentTime"></span>
                    </div>
                    <div class="tooltip-custom">
                        <span style="color: #667eea; font-weight: 600; cursor: help;">
                            <i class="fas fa-user-circle"></i> dhanraj3747
                        </span>
                        <span class="tooltiptext">Admin User</span>
                    </div>
                </div>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-card">
                    <i class="fas fa-users" style="color: #667eea; font-size: 1.8rem; margin-bottom: 10px;"></i>
                    <h3 id="totalStudents">0</h3>
                    <p>Total Students</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-star" style="color: #f093fb; font-size: 1.8rem; margin-bottom: 10px;"></i>
                    <h3 id="avgMarks">0</h3>
                    <p>Average Marks</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-check-circle" style="color: #5ee7df; font-size: 1.8rem; margin-bottom: 10px;"></i>
                    <h3 id="avgAttendance">0%</h3>
                    <p>Average Attendance</p>
                </div>
            </div>

            <!-- Students Cards -->
            <div class="cards-container" id="cardsContainer">
                <%
                java.util.List<String> names = new java.util.ArrayList<>();
                java.util.List<String> courses = new java.util.ArrayList<>();
                java.util.List<Integer> marks = new java.util.ArrayList<>();
                java.util.List<Integer> attendance = new java.util.ArrayList<>();

                while(rs.next()) {
                    names.add(rs.getString("name"));
                    courses.add(rs.getString("course"));
                    marks.add(rs.getInt("marks"));
                    attendance.add(rs.getInt("attendance"));
                }

                if(names.isEmpty()) {
                %>
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <i class="fas fa-inbox"></i>
                        <h3>No Students Found</h3>
                        <p>Start adding students to your system</p>
                    </div>
                <%
                } else {
                    for(int i = 0; i < names.size(); i++) {
                        String name = names.get(i);
                        String course = courses.get(i);
                        int mark = marks.get(i);
                        int attend = attendance.get(i);
                %>
                    <div class="student-card fade-in">
                        <div class="student-card-header">
                            <div class="student-avatar"><%= name.charAt(0) %></div>
                            <div>
                                <p class="student-name"><%= name %></p>
                                <p class="student-course"><%= course %></p>
                                
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <div class="stat-row">
                            <span class="stat-label"><i class="fas fa-pen"></i> Marks Obtained</span>
                            <span class="marks-badge"><%= mark %>/100</span>
                        </div>

                        <div class="stat-row">
                            <span class="stat-label"><i class="fas fa-calendar-check"></i> Attendance</span>
                            <span class="attendance-badge"><%= attend %>%</span>
                        </div>

                        <div class="card-footer">
                            <button class="btn-sm-custom btn-edit" onclick="editStudent('<%= name %>')">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn-sm-custom btn-view" >
                              
                                <a href="studentDashboard.jsp"><i class="fas fa-eye"></i> View</a>
                            </button>
                        </div>
                    </div>
                <%
                    }
                }

                st.close();
                con.close();
                %>
            </div>
        </main>
    </div>

    <!-- Logout Modal -->
    <div id="logoutModal" class="modal-custom">
        <div class="modal-custom-content">
            <h2><i class="fas fa-exclamation-circle"></i> Confirm Logout</h2>
            <p>Are you sure you want to logout? You'll need to login again to access the dashboard.</p>
            <div class="modal-buttons">
                <button class="btn-confirm" onclick="performLogout()">Yes, Logout</button>
                <button class="btn-cancel" onclick="closeLogoutModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('en-US', { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit',
                hour12: true 
            });
            document.getElementById('currentTime').textContent = timeString;
        }

        setInterval(updateTime, 1000);
        updateTime();

        // Calculate and display statistics
        function calculateStats() {
            const cards = document.querySelectorAll('.student-card');
            let totalStudents = cards.length;
            let totalMarks = 0;
            let totalAttendance = 0;

            cards.forEach(card => {
                const marksBadge = card.querySelector('.marks-badge');
                const attendanceBadge = card.querySelector('.attendance-badge');
                
                if(marksBadge) {
                    const marks = parseInt(marksBadge.textContent);
                    totalMarks += marks;
                }
                
                if(attendanceBadge) {
                    const attendance = parseInt(attendanceBadge.textContent);
                    totalAttendance += attendance;
                }
            });

            document.getElementById('totalStudents').textContent = totalStudents;
            document.getElementById('avgMarks').textContent = totalStudents > 0 ? Math.round(totalMarks / totalStudents) : 0;
            document.getElementById('avgAttendance').textContent = totalStudents > 0 ? Math.round(totalAttendance / totalStudents) : 0;
        }

        // Set active menu item
        function setActive(event) {
            event.preventDefault();
            document.querySelectorAll('.sidebar-menu a').forEach(a => a.classList.remove('active'));
            event.target.closest('a').classList.add('active');
        }

        // Logout confirmation
        function confirmLogout() {
            document.getElementById('logoutModal').style.display = 'block';
        }

        function closeLogoutModal() {
            document.getElementById('logoutModal').style.display = 'none';
        }

        function performLogout() {
            window.location.href = 'logout.jsp';
        }

        // Student actions
        function viewStudent(name) {
            alert('Viewing student: ' + name);
            // Add navigation logic here
        }

        function editStudent(name) {
            alert('Editing student: ' + name);
            // Add edit logic here
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('logoutModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }

        // Initialize stats on page load
        document.addEventListener('DOMContentLoaded', function() {
            calculateStats();
            updateTime();
        });

        // Add smooth scroll behavior
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if(target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });
    </script>
</body>
</html>