<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Safely get the technology parameter
    String tech = request.getParameter("tech");
    if (tech == null || tech.isEmpty()) {
        tech = "General"; // Default fallback
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Setup Question Bank | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f4f7fe; height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', sans-serif; }
        .setup-card { background: white; padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); width: 100%; max-width: 450px; text-align: center; border: 1px solid #e2e8f0; }
        .icon-box { width: 80px; height: 80px; background: #eef2ff; color: #4f46e5; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 2rem; }
        .tech-label { color: #4f46e5; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem; }
        .btn-generate { background: #4f46e5; color: white; border: none; padding: 14px; width: 100%; border-radius: 12px; font-weight: 600; margin-top: 25px; transition: 0.3s; }
        .btn-generate:hover { background: #3730a3; transform: translateY(-2px); }
    </style>
</head>
<body>

    <div class="setup-card">
        <div class="icon-box"><i class="fas fa-layer-group"></i></div>
        <span class="tech-label"><%= tech %></span>
        <h2 class="fw-bold mt-2">Question Bank</h2>
        <p class="text-muted">Configure your practice session</p>

        <!-- Form sends data to viewQuestions.jsp -->
        <form action="viewQuestions.jsp" method="GET">
            <!-- CRITICAL: Ensure tech is passed forward -->
            <input type="hidden" name="tech" value="<%= tech %>">
            
            <div class="text-start mt-4">
                <label class="form-label fw-600">Number of Questions</label>
                <select name="count" class="form-select form-select-lg" style="border-radius: 10px;">
                    <option value="5" selected>Top 5 Questions</option>
                    <option value="10">Top 10 Questions</option>
                    <option value="15">Top 15 Questions</option>
                    <option value="20">All Available</option>
                </select>
            </div>

            <button type="submit" class="btn-generate">
                Start Session <i class="fas fa-play ms-2"></i>
            </button>
        </form>
        
        <a href="adminDashboard.jsp" class="d-block mt-4 text-muted text-decoration-none small">
            <i class="fas fa-chevron-left me-1"></i> Back to Dashboard
        </a>
    </div>

</body>
</html>