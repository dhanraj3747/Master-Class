<%@ page import="java.sql.*,com.project.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
String role = (String) session.getAttribute("role");

if(role == null || !role.equals("student")) {
    response.sendRedirect("login.jsp");
    return;
}

String studentName = (String) session.getAttribute("studentName");
int userId = (int) session.getAttribute("userId");

Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM student_data WHERE user_id=?");

ps.setInt(1, userId);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Learning Management System</title>

    <!-- Bootstrap 5.3 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
            gap: 0;
        }

        /* ======================== SIDEBAR ======================== */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1a1f35 0%, #252d48 100%);
            color: white;
            padding: 30px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 3px;
        }

        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.4);
        }

        .sidebar-header {
            padding: 0 25px 30px 25px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 25px;
        }

        .sidebar-header h4 {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: 0.5px;
        }

        .sidebar-header p {
            font-size: 0.85rem;
            opacity: 0.7;
            margin: 0;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 15px;
        }

        .sidebar-menu-item {
            margin-bottom: 10px;
        }

        .sidebar-menu-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 15px;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            font-size: 0.95rem;
            position: relative;
        }

        .sidebar-menu-link i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }

        .sidebar-menu-link:hover {
            background: rgba(102, 126, 234, 0.15);
            color: white;
            padding-left: 20px;
        }

        .sidebar-menu-link.active {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .sidebar-menu-link.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: white;
            border-radius: 0 2px 2px 0;
        }

        .sidebar-footer {
            margin-top: auto;
            padding: 20px 15px 0 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-footer .logout-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 15px;
            color: rgba(255, 99, 71, 0.8);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar-footer .logout-link:hover {
            background: rgba(255, 99, 71, 0.15);
            color: #FF6347;
            padding-left: 20px;
        }

        /* ======================== MAIN CONTENT ======================== */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 40px 30px;
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
            background: rgba(0, 0, 0, 0.15);
            border-radius: 4px;
        }

        .main-content::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }

        /* ======================== HEADER ======================== */
        .dashboard-header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 35px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dashboard-header h1 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            color: #1a1f35;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .dashboard-header h1 i {
            color: #667eea;
        }

        .header-info {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .info-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .info-badge i {
            font-size: 1.1rem;
        }

        .user-info {
            text-align: right;
        }

        .user-info .user-name {
            font-weight: 700;
            color: #1a1f35;
            font-size: 1rem;
            margin: 0;
        }

        .user-info .user-role {
            font-size: 0.85rem;
            color: #667eea;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin: 0;
        }

        /* ======================== STATS SECTION ======================== */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(102, 126, 234, 0.2);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1f35;
            margin: 10px 0;
        }

        .stat-label {
            font-size: 0.85rem;
            color: #7f8c9a;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ======================== COURSES SECTION ======================== */
        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1f35;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: #667eea;
            font-size: 1.6rem;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        /* ======================== COURSE CARD ======================== */
        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeInUp 0.6s ease;
            position: relative;
        }

        .course-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            z-index: 1;
        }

        .course-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.25);
        }

        .course-header {
            padding: 25px;
            background: linear-gradient(135deg, #f5f7fa 0%, #eeeff5 100%);
            border-bottom: 2px solid #e8ecf1;
        }

        .course-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a1f35;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .course-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .course-subtitle {
            font-size: 0.8rem;
            color: #667eea;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin: 0;
        }

        .course-body {
            padding: 25px;
        }

        .course-stat {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            padding-bottom: 18px;
            border-bottom: 1px solid #f0f3f9;
        }

        .course-stat:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .stat-name {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            color: #7f8c9a;
            font-size: 0.95rem;
        }

        .stat-name i {
            color: #667eea;
            font-size: 1rem;
        }

        .stat-display {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ======================== BADGES ======================== */
        .badge-marks {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-attendance {
            background: linear-gradient(135deg, #5ee7df 0%, #4facfe 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-grade {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(245, 87, 108, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* ======================== PROGRESS BAR ======================== */
        .progress-wrapper {
            margin-top: 20px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .progress-bar-custom {
            height: 8px;
            background: #e8ecf1;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            transition: width 0.6s ease;
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.4);
        }

        /* ======================== EMPTY STATE ======================== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c9a;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .empty-state i {
            font-size: 4rem;
            color: #d4dae6;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #1a1f35;
            font-weight: 700;
            margin: 15px 0;
        }

        /* ======================== MODAL ======================== */
        .modal-custom {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .modal-custom-content {
            background-color: white;
            margin: 10% auto;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 450px;
            text-align: center;
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-custom-content h2 {
            color: #1a1f35;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .modal-custom-content p {
            color: #7f8c9a;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .modal-buttons button {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .btn-confirm {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-width: 130px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-cancel {
            background: #e8ecf1;
            color: #667eea;
            min-width: 130px;
            border: 2px solid #667eea;
        }

        .btn-cancel:hover {
            background: #667eea;
            color: white;
        }

        /* ======================== TOOLTIP ======================== */
        .tooltip-custom {
            position: relative;
            display: inline-block;
            cursor: help;
        }

        .tooltip-custom .tooltiptext {
            visibility: hidden;
            background-color: #1a1f35;
            color: white;
            text-align: center;
            border-radius: 8px;
            padding: 10px 15px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            white-space: nowrap;
            font-size: 0.8rem;
            opacity: 0;
            transition: opacity 0.3s;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            font-weight: 500;
        }

        .tooltip-custom:hover .tooltiptext {
            visibility: visible;
            opacity: 1;
        }

        /* ======================== RESPONSIVE ======================== */
        @media (max-width: 992px) {
            .sidebar {
                width: 250px;
            }

            .main-content {
                margin-left: 250px;
                padding: 30px 20px;
            }

            .dashboard-header {
                padding: 20px;
                flex-direction: column;
                align-items: flex-start;
            }

            .dashboard-header h1 {
                font-size: 1.6rem;
            }

            .courses-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 240px;
            }

            .main-content {
                margin-left: 240px;
                padding: 20px;
            }

            .dashboard-header {
                padding: 15px;
            }

            .dashboard-header h1 {
                font-size: 1.3rem;
            }

            .courses-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .header-info {
                width: 100%;
            }

            .user-info {
                text-align: left;
            }
        }

        @media (max-width: 576px) {
            .wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px 0;
            }

            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .dashboard-header {
                padding: 15px;
                flex-direction: column;
            }

            .dashboard-header h1 {
                font-size: 1.2rem;
            }

            .course-card {
                margin-bottom: 15px;
            }

            .section-title {
                font-size: 1.2rem;
            }
        }

        /* ======================== ANIMATIONS ======================== */
        @keyframes shimmer {
            0% {
                background-position: -1000px 0;
            }
            100% {
                background-position: 1000px 0;
            }
        }

        .loading {
            animation: shimmer 2s infinite;
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 1000px 100%;
        }

        /* ======================== SCROLLBAR STYLES ======================== */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <!-- SIDEBAR -->
        <aside class="sidebar p-4">
            <div class="sidebar-header">
                <h4><i class="fas fa-graduation-cap"></i> Student Panel</h4>
                <p>Learning Dashboard</p>
            </div>

            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="#" class="sidebar-menu-link active" onclick="setActive(event)">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="trail.html" class="sidebar-menu-link" >
                        <i class="fas fa-book"></i>
                        <span>My Courses</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="#" class="sidebar-menu-link" onclick="setActive(event)">
                        <i class="fas fa-chart-bar"></i>
                        <span>Performance</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="#" class="sidebar-menu-link" onclick="setActive(event)">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <a href="#" class="logout-link" onclick="confirmLogout()">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- HEADER -->
            <div class="dashboard-header">
                <div>
                    <h1><i class="fas fa-chart-line"></i> My Dashboard</h1>
                </div>
                <div class="header-info">
                    <div class="info-badge">
                        <i class="fas fa-clock"></i>
                        <span id="currentTime"></span>
                    </div>
                    <div class="user-info">
                        <p class="user-name"><%= studentName != null ? studentName : "Student" %></p>
                        <p class="user-role">Student</p>
                    </div>
                </div>
            </div>

            <!-- STATS SECTION -->
            <div class="stats-container">
                <div class="stat-card">
                    <i class="fas fa-book stat-icon"></i>
                    <div class="stat-value" id="totalCourses">0</div>
                    <div class="stat-label">Total Courses</div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-star stat-icon"></i>
                    <div class="stat-value" id="avgMarks">0</div>
                    <div class="stat-label">Average Marks</div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-check-circle stat-icon"></i>
                    <div class="stat-value" id="avgAttendance">0%</div>
                    <div class="stat-label">Average Attendance</div>
                </div>
            </div>

            <!-- COURSES SECTION -->
            <a href="ai.html"><h2 class="section-title"><i class="fas fa-book-open"></i> My Courses</h2></a>

            <div class="courses-grid" id="coursesGrid">
                <%
                java.util.List<String> courses = new java.util.ArrayList<>();
                java.util.List<Integer> marksList = new java.util.ArrayList<>();
                java.util.List<Integer> attendanceList = new java.util.ArrayList<>();

                while(rs.next()) {
                    courses.add(rs.getString("course"));
                    marksList.add(rs.getInt("marks"));
                    attendanceList.add(rs.getInt("attendance"));
                }

                if(courses.isEmpty()) {
                %>
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <i class="fas fa-inbox"></i>
                        <h3>No Courses Yet</h3>
                        <p>You haven't enrolled in any courses. Contact your administrator to get started.</p>
                    </div>
                <%
                } else {
                    for(int i = 0; i < courses.size(); i++) {
                        String course = courses.get(i);
                        int marks = marksList.get(i);
                        int attendance = attendanceList.get(i);
                        
                        // Calculate grade
                        String grade = "F";
                        if(marks >= 90) grade = "A+";
                        else if(marks >= 80) grade = "A";
                        else if(marks >= 70) grade = "B";
                        else if(marks >= 60) grade = "C";
                        else if(marks >= 50) grade = "D";
                %>
                    <div class="course-card fade-in">
                        <div class="course-header">
                            <div class="course-title">
                                <div class="course-icon">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                                <div>
                                    <h5 style="margin: 0;"><%= course %></h5>
                                </div>
                            </div>
                            <p class="course-subtitle">Course ID: #<%= (i+1) %></p>
                        </div>

                        <div class="course-body">
                            <!-- Marks -->
                            <div class="course-stat">
                                <div class="stat-name">
                                    <i class="fas fa-pencil-alt"></i>
                                    <span>Marks Obtained</span>
                                </div>
                                <div class="stat-display">
                                    <span class="badge-marks">
                                        <i class="fas fa-star"></i>
                                        <%= marks %>/100
                                    </span>
                                </div>
                            </div>

                            <!-- Attendance -->
                            <div class="course-stat">
                                <div class="stat-name">
                                    <i class="fas fa-calendar-check"></i>
                                    <span>Attendance</span>
                                </div>
                                <div class="stat-display">
                                    <span class="badge-attendance">
                                        <i class="fas fa-check"></i>
                                        <%= attendance %>%
                                    </span>
                                </div>
                            </div>

                            <!-- Grade -->
                            <div class="course-stat">
                                <div class="stat-name">
                                    <i class="fas fa-medal"></i>
                                    <span>Grade</span>
                                </div>
                                <div class="stat-display">
                                    <span class="badge-grade">
                                        <i class="fas fa-award"></i>
                                        <%= grade %>
                                    </span>
                                </div>
                            </div>

                            <!-- Progress Bar -->
                            <div class="progress-wrapper">
                                <div class="progress-label">
                                    <span>Performance</span>
                                    <span id="marks-<%= i %>"><%= marks %>%</span>
                                </div>
                                <div class="progress-bar-custom">
                                    <div class="progress-fill" style="width: <%= marks %>%;" id="progress-<%= i %>"></div>
                                </div>
                            </div>

                            <!-- Attendance Progress Bar -->
                            <div class="progress-wrapper">
                                <div class="progress-label">
                                    <span>Attendance Status</span>
                                    <span id="attendance-<%= i %>"><%= attendance %>%</span>
                                </div>
                                <div class="progress-bar-custom">
                                    <div class="progress-fill" style="width: <%= attendance %>%; background: linear-gradient(90deg, #5ee7df 0%, #4facfe 100%);" id="attendance-progress-<%= i %>"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                <%
                    }
                }

                ps.close();
                con.close();
                %>
            </div>
        </main>
    </div>

    <!-- LOGOUT MODAL -->
    <div id="logoutModal" class="modal-custom">
        <div class="modal-custom-content">
            <h2><i class="fas fa-exclamation-circle" style="color: #f5576c;"></i> Confirm Logout</h2>
            <p>Are you sure you want to logout? You'll need to login again to access your dashboard.</p>
            <div class="modal-buttons">
                <button class="btn-confirm" onclick="performLogout()">
                    <i class="fas fa-sign-out-alt"></i> Yes, Logout
                </button>
                <button class="btn-cancel" onclick="closeLogoutModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        // ======================== TIME UPDATE ========================
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

        // ======================== CALCULATE STATS ========================
        function calculateStats() {
            const coursesGrid = document.getElementById('coursesGrid');
            const cards = coursesGrid.querySelectorAll('.course-card');
            
            let totalCourses = cards.length;
            let totalMarks = 0;
            let totalAttendance = 0;

            cards.forEach(card => {
                const marksBadge = card.querySelector('.badge-marks');
                const attendanceBadge = card.querySelector('.badge-attendance');
                
                if(marksBadge) {
                    const marks = parseInt(marksBadge.textContent);
                    totalMarks += marks;
                }
                
                if(attendanceBadge) {
                    const attendance = parseInt(attendanceBadge.textContent);
                    totalAttendance += attendance;
                }
            });

            document.getElementById('totalCourses').textContent = totalCourses;
            document.getElementById('avgMarks').textContent = totalCourses > 0 ? Math.round(totalMarks / totalCourses) : 0;
            document.getElementById('avgAttendance').textContent = totalCourses > 0 ? Math.round(totalAttendance / totalCourses) : 0;
        }

        // ======================== SIDEBAR ACTIVE STATE ========================
        function setActive(event) {
            event.preventDefault();
            document.querySelectorAll('.sidebar-menu-link').forEach(a => a.classList.remove('active'));
            event.target.closest('a').classList.add('active');
        }

        // ======================== LOGOUT FUNCTIONS ========================
        function confirmLogout() {
            document.getElementById('logoutModal').style.display = 'block';
        }

        function closeLogoutModal() {
            document.getElementById('logoutModal').style.display = 'none';
        }

        function performLogout() {
            window.location.href = 'logout.jsp';
        }

        // ======================== MODAL CLICK OUTSIDE ========================
        window.onclick = function(event) {
            const modal = document.getElementById('logoutModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }

        // ======================== KEYBOARD ESCAPE ========================
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeLogoutModal();
            }
        });

        // ======================== INITIALIZE ========================
        document.addEventListener('DOMContentLoaded', function() {
            calculateStats();
            updateTime();
            
            // Add animation to cards
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.1) + 's';
            });
        });

        // ======================== SMOOTH SCROLL ========================
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if(target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // ======================== COURSE CARD INTERACTIVITY ========================
        const courseCards = document.querySelectorAll('.course-card');
        courseCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.cursor = 'pointer';
            });
        });

        // ======================== RESPONSIVE SIDEBAR ========================
        function checkResponsive() {
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');
            
            if(window.innerWidth <= 576) {
                sidebar.style.marginBottom = '20px';
            }
        }

        window.addEventListener('resize', checkResponsive);
        checkResponsive();

        // ======================== PREVENT ANIMATIONS ON SCROLL ========================
        let ticking = false;

        window.addEventListener('scroll', function() {
            if (!ticking) {
                window.requestAnimationFrame(function() {
                    ticking = false;
                });
                ticking = true;
            }
        });
    </script>
</body>
</html>