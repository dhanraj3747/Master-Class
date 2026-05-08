<%@ page import="java.util.*, com.tap.model.LeaderboardUser, com.tap.dao.LeaderboardDAO" %>
<%
    LeaderboardDAO dao = new LeaderboardDAO();
    List<LeaderboardUser> rankings = dao.getTopRankings();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Global Leaderboard | EduStream Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #f4f7f9;
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
            --glass-bg: rgba(255, 255, 255, 0.9);
        }
        body { background: var(--bg-color); font-family: 'Poppins', sans-serif; padding: 50px; }
        .leaderboard-card {
            background: var(--glass-bg);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: auto;
        }
        .rank-item {
            display: flex;
            align-items: center;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 16px;
            background: white;
            transition: 0.3s;
            border: 1px solid rgba(0,0,0,0.03);
        }
        .rank-item:hover { transform: scale(1.02); box-shadow: 0 10px 30px rgba(0, 242, 254, 0.1); }
        .rank-number { width: 50px; font-weight: 800; font-size: 1.2rem; }
        .rank-1 { border-left: 5px solid #FFD700; } /* Gold */
        .rank-2 { border-left: 5px solid #C0C0C0; } /* Silver */
        .rank-3 { border-left: 5px solid #CD7F32; } /* Bronze */
        .score-pill {
            margin-left: auto;
            background: var(--cyan-gradient);
            color: white;
            padding: 8px 20px;
            border-radius: 30px;
            font-weight: 700;
        }
    </style>
</head>
<body>

<div class="leaderboard-card">
    <div class="text-center mb-5">
        <h1 class="fw-bold"><i class="fas fa-trophy text-warning me-2"></i> Performance Leaderboard</h1>
        <p class="text-muted">Rankings based on 5-Course completion (Max 500 XP)</p>
    </div>

    <% for (LeaderboardUser user : rankings) { %>
        <div class="rank-item rank-<%= user.getRank() %>">
            <div class="rank-number">
                <% if(user.getRank() == 1) { %><i class="fas fa-crown text-warning"></i><% } 
                   else { %> #<%= user.getRank() %> <% } %>
            </div>
            <div class="ms-3">
                <h5 class="fw-bold mb-0"><%= user.getName() %></h5>
            </div>
            <div class="score-pill">
                <%= user.getScore() %> XP
            </div>
        </div>
    <% } %>
    
    <div class="text-center mt-4">
        <button onclick="history.back()" class="btn btn-outline-info rounded-pill px-4">Back to Dashboard</button>
    </div>
</div>

</body>
</html>