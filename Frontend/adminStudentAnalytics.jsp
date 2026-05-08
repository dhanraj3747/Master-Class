<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tap.model.StudentProgressSummary" %>
<%
    // 1. Session & Role Protection
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Retrieve the List from Servlet
    List<StudentProgressSummary> studentDataList = (List<StudentProgressSummary>) request.getAttribute("studentAnalyticsList");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cohort Analytics | EduStream Pro</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>

    <style>
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.3);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            padding: 40px 20px;
        }

        .main-container { max-width: 1300px; margin: 0 auto; }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(25px);
            border: 1px solid var(--glass-border);
            border-radius: 28px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }
        
        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 50px var(--cyan-glow);
            border-color: var(--cyan-secondary);
        }

        .premium-header {
            font-weight: 800;
            background: var(--cyan-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        .module-label { font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; }
        .progress { height: 7px; border-radius: 10px; background-color: rgba(0, 0, 0, 0.05); margin-bottom: 8px; }
        .progress-bar { background: var(--cyan-gradient); box-shadow: 0 0 12px var(--cyan-glow); border-radius: 10px; }
        
        .score-box { background: rgba(255,255,255,0.5); padding: 8px 12px; border-radius: 12px; border: 1px solid var(--glass-border); }
        .score-val { color: var(--text-color); font-weight: 700; font-size: 0.85rem; }

        .btn-premium {
            padding: 12px 28px;
            border-radius: 50px;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            border: none;
            background: var(--cyan-gradient);
            color: white !important;
            box-shadow: 0 10px 20px var(--cyan-glow);
        }

        .btn-outline-cyan {
            border: 2px solid var(--cyan-secondary);
            color: var(--cyan-secondary) !important;
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
        }

        .download-single {
            position: absolute;
            top: 25px;
            right: 25px;
            color: var(--cyan-secondary);
            cursor: pointer;
            font-size: 1.2rem;
            transition: 0.3s;
        }
    </style>
</head>
<body>

<div class="main-container">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h1 class="premium-header m-0">Cohort Performance</h1>
            <p class="text-muted mt-2">Analytical PDF reports for your student batch.</p>
        </div>
        <div class="d-flex gap-3">
            <button onclick="exportFullReport()" class="btn-premium">
                <i class="fas fa-file-pdf"></i> Export Full PDF
            </button>
            <a href="adminDashboard.jsp" class="btn-outline-cyan text-decoration-none">
                <i class="fas fa-arrow-left me-2"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="row g-4">
        <% 
        if (studentDataList != null && !studentDataList.isEmpty()) {
            int count = 0;
            for (StudentProgressSummary student : studentDataList) { 
                count++;
                Map<String, Integer> progMap = student.getCourseWiseProgress();
                Map<String, Integer> assessMap = student.getAssessmentScores();
                Map<String, Integer> assignMap = student.getAssignmentScores();
        %>
            <div class="col-xl-4 col-md-6">
                <div class="glass-card" id="card-<%= count %>">
                    <div class="download-single" onclick="exportStudent('<%= student.getStudentName() %>', <%= count %>)">
                        <i class="fas fa-file-pdf"></i>
                    </div>

                    <h4 class="fw-bold mb-4">
                        <i class="fas fa-user-circle text-info me-2"></i> 
                        <%= student.getStudentName() %>
                    </h4>
                    
                    <% 
                        String[] techs = {"JAVA", "HTML", "CSS", "JAVASCRIPT", "PYTHON"};
                        for(String t : techs) {
                            int p = progMap.getOrDefault(t, 0);
                            int aScore = assessMap.getOrDefault(t, 0);
                            int sScore = assignMap.getOrDefault(t, 0);
                    %>
                        <div class="mb-4 student-module" data-tech="<%= t %>" data-prog="<%= p %>" data-quiz="<%= aScore %>" data-task="<%= sScore %>">
                            <div class="d-flex justify-content-between mb-1">
                                <span class="module-label"><%= t %></span>
                                <span class="small fw-bold"><%= p %>%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" style="width: <%= p %>%"></div>
                            </div>
                            <div class="d-flex justify-content-between score-box">
                                <div class="score-val"><span class="text-muted small">Quiz:</span> <%= aScore %> pts</div>
                                <div class="score-val"><span class="text-muted small">Task:</span> <%= sScore %> pts</div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% 
            } 
        } 
        %>
    </div>
</div>

<script>
    const { jsPDF } = window.jspdf;

    function exportFullReport() {
        const doc = new jsPDF();
        doc.setFont("helvetica", "bold");
        doc.setTextColor(79, 172, 254); // Cyan Secondary
        doc.text("EduStream Pro - Cohort Performance Report", 14, 20);
        
        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.setFont("helvetica", "normal");
        doc.text("Generated on: " + new Date().toLocaleString(), 14, 28);

        const tableData = [];
        <% 
        if (studentDataList != null) {
            for (StudentProgressSummary s : studentDataList) {
                String n = s.getStudentName();
                Map<String, Integer> pm = s.getCourseWiseProgress();
                Map<String, Integer> am = s.getAssessmentScores();
                Map<String, Integer> sm = s.getAssignmentScores();
                for(String t : new String[]{"JAVA", "HTML", "CSS", "JAVASCRIPT", "PYTHON"}) {
        %>
        tableData.push(["<%= n %>", "<%= t %>", "<%= pm.getOrDefault(t,0) %>%", "<%= am.getOrDefault(t,0) %> pts", "<%= sm.getOrDefault(t,0) %> pts"]);
        <% 
                }
            }
        } 
        %>

        doc.autoTable({
            startY: 35,
            head: [['Student Name', 'Technology', 'Progress', 'Quiz Score', 'Task Score']],
            body: tableData,
            headStyles: { fillColor: [0, 242, 254] },
            alternateRowStyles: { fillColor: [244, 247, 249] }
        });

        doc.save("EduStream_Cohort_Report.pdf");
    }

    function exportStudent(name, cardIndex) {
        const doc = new jsPDF();
        const card = document.getElementById('card-' + cardIndex);
        
        doc.setFont("helvetica", "bold");
        doc.setTextColor(79, 172, 254);
        doc.text("Student Performance Report: " + name, 14, 20);

        const studentData = [];
        const modules = card.querySelectorAll('.student-module');
        modules.forEach(m => {
            studentData.push([
                m.getAttribute('data-tech'),
                m.getAttribute('data-prog') + "%",
                m.getAttribute('data-quiz') + " pts",
                m.getAttribute('data-task') + " pts"
            ]);
        });

        doc.autoTable({
            startY: 30,
            head: [['Technology', 'Progress', 'Quiz Score', 'Task Score']],
            body: studentData,
            headStyles: { fillColor: [0, 242, 254] }
        });

        doc.save(name + "_Report.pdf");
    }
</script>
</body>
</html>