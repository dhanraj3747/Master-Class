<%@ page import="java.sql.*,com.project.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String tech = request.getParameter("tech");
    if (tech == null) tech = "HTML"; 

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        // FIXED: Changed variable name 'sql' to 'query' to match line 17
        String query = "SELECT * FROM questions_bank WHERE LOWER(technology) = LOWER(?)";
        ps = con.prepareStatement(query);
        ps.setString(1, tech);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= tech %> Interview Questions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f4f7fe; font-family: 'Segoe UI', sans-serif; }
        .hero-section { background: linear-gradient(135deg, #1e293b 0%, #334155 100%); color: white; padding: 60px 0; border-radius: 0 0 50px 50px; margin-bottom: 40px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .q-card { border: none; border-radius: 15px; margin-bottom: 20px; transition: 0.3s; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .q-card:hover { transform: translateY(-5px); box-shadow: 0 12px 20px rgba(0,0,0,0.1); }
        .accordion-button { font-weight: 600; color: #1e293b; }
        .accordion-button:not(.collapsed) { background: #eef2ff; color: #4f46e5; }
        .difficulty-badge { font-size: 0.7rem; padding: 4px 12px; border-radius: 20px; float: right; margin-top: 5px; }
        .bg-easy { background: #dcfce7 !important; color: #15803d !important; }
        .bg-medium { background: #fef9c3 !important; color: #854d0e !important; }
        .bg-hard { background: #fee2e2 !important; color: #b91c1c !important; }
    </style>
</head>
<body>

    <div class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold"><%= tech.toUpperCase() %> Question Bank</h1>
            <p class="lead opacity-75">Prepare for your next technical interview</p>
            <a href="studentDashboard.jsp" class="btn btn-outline-light btn-sm mt-3"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="accordion" id="qAccordion">
                    <% 
                        int i = 0;
                        boolean hasData = false;
                        while(rs.next()) { 
                            hasData = true;
                            i++;
                            // Handle null difficulty gracefully
                            String diff = rs.getString("difficulty");
                            if(diff == null) diff = "Medium";
                    %>
                    <div class="accordion-item q-card">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=i%>">
                                <span class="me-3 text-primary">#<%=i%></span> <%= rs.getString("question") %>
                                <span class="difficulty-badge bg-<%= diff.toLowerCase() %> ms-auto"><%= diff %></span>
                            </button>
                        </h2>
                        <div id="collapse<%=i%>" class="accordion-collapse collapse" data-bs-parent="#qAccordion">
                            <div class="accordion-body bg-white border-top">
                                <strong class="text-dark"><i class="fas fa-lightbulb text-warning me-2"></i>Answer:</strong>
                                <p class="mt-2 text-muted" style="line-height: 1.6;"><%= rs.getString("answer") %></p>
                            </div>
                        </div>
                    </div>
                    <% } 
                       if(!hasData) { %>
                        <div class="text-center p-5">
                            <i class="fas fa-search fa-3x text-muted mb-3"></i>
                            <h3>No questions found for <%= tech %></h3>
                            <p>Try checking your database for exact technology names.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
    } catch(Exception e) { 
        out.println("<div class='container mt-5'><div class='alert alert-danger'>Error: " + e.getMessage() + "</div></div>");
        e.printStackTrace(); 
    } finally { 
        if(rs != null) rs.close(); 
        if(ps != null) ps.close(); 
        if(con != null) con.close(); 
    }
%>