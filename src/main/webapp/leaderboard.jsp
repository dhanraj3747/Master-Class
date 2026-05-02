<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard | EduStream Professional</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* =========================================================================
           PREMIUM ENTERPRISE / GITHUB-STYLE THEME
           ========================================================================= */
        :root {
            --bg-body: #f6f8fa;
            --bg-surface: #ffffff;
            --text-primary: #24292f;
            --text-secondary: #57606a;
            --border-color: #d0d7de;
            --accent-blue: #0969da;
            --gold: #e3b341;
            --silver: #a8a8a8;
            --bronze: #b08d57;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-primary);
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        /* --- Main Card --- */
        .leaderboard-card {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            width: 100%;
            max-width: 700px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04), 0 1px 3px rgba(0, 0, 0, 0.02);
            overflow: hidden;
        }

        /* --- Header --- */
        .leaderboard-header {
            padding: 30px;
            border-bottom: 1px solid var(--border-color);
            background-color: #ffffff;
            text-align: center;
        }

        .trophy-icon {
            font-size: 2.5rem;
            color: var(--gold);
            margin-bottom: 12px;
        }

        .page-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 5px;
            letter-spacing: -0.5px;
        }

        .page-subtitle {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin: 0;
        }

        /* --- Table Styling --- */
        .table-responsive {
            padding: 0 15px;
        }

        .table {
            margin-bottom: 0;
            vertical-align: middle;
        }

        .table thead th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 20px;
            font-weight: 600;
            background-color: #fbfbfc;
        }

        .table tbody td {
            padding: 16px 20px;
            font-size: 0.95rem;
            font-weight: 500;
            border-bottom: 1px solid #f0f2f5;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .table tbody tr:hover {
            background-color: #f9fbfc;
        }

        /* --- Rank Badges --- */
        .rank-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-weight: 700;
            font-size: 0.9rem;
            background-color: #f3f4f6;
            color: var(--text-secondary);
        }

        /* Top 3 Highlighting */
        .rank-1 .rank-badge { background-color: rgba(227, 179, 65, 0.15); color: var(--gold); }
        .rank-2 .rank-badge { background-color: rgba(168, 168, 168, 0.15); color: var(--silver); }
        .rank-3 .rank-badge { background-color: rgba(176, 141, 87, 0.15); color: var(--bronze); }

        .score-cell {
            font-family: 'Inter', monospace;
            font-weight: 600;
            color: var(--accent-blue);
        }

        /* --- Footer Actions --- */
        .card-footer-actions {
            padding: 20px;
            background-color: #fbfbfc;
            border-top: 1px solid var(--border-color);
            text-align: center;
        }

        .btn-outline-custom {
            display: inline-block;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--text-primary);
            background-color: var(--bg-body);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-outline-custom:hover {
            background-color: #ebecf0;
            color: var(--text-primary);
        }
    </style>
</head>
<body>

    <div class="leaderboard-card">
        
        <div class="leaderboard-header">
            <i class="fa-solid fa-trophy trophy-icon"></i>
            <h2 class="page-title">Global Leaderboard</h2>
            <p class="page-subtitle">Top performing students based on total assessment scores.</p>
        </div>

        <div class="table-responsive">
            <table class="table table-borderless">
                <thead>
                    <tr>
                        <th style="width: 15%;">Rank</th>
                        <th style="width: 60%;">Student Name</th>
                        <th style="width: 25%; text-align: right;">Total Score</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <!-- Loop through the 'topStudents' list passed from LeaderboardServlet -->
                    <c:forEach var="student" items="${topStudents}">
                        <tr class="rank-${student.rank}">
                            <td>
                                <div class="rank-badge">
                                    <c:choose>
                                        <c:when test="${student.rank == 1}"><i class="fa-solid fa-medal"></i></c:when>
                                        <c:when test="${student.rank == 2}"><i class="fa-solid fa-medal"></i></c:when>
                                        <c:when test="${student.rank == 3}"><i class="fa-solid fa-medal"></i></c:when>
                                        <c:otherwise>${student.rank}</c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td>
                                <div class="fw-semibold text-capitalize">${student.studentName}</div>
                            </td>
                            <td class="text-end score-cell">
                                ${student.totalScore} pts
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <!-- Fallback if no data is found -->
                    <c:if test="${empty topStudents}">
                        <tr>
                            <td colspan="3" class="text-center text-muted py-4">
                                No assessment data available yet.
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>
        </div>

        <div class="card-footer-actions">
            <!-- Ensure this points back to the correct Admin or Student Dashboard -->
            <a href="studentDashboard.jsp" class="btn-outline-custom">
                <i class="fa-solid fa-arrow-left me-2"></i> Return to Dashboard
            </a>
        </div>

    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>