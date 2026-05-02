<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Security Check: Only allow 'admin' to see this page
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("admin")) {
        response.sendRedirect("studentDashboard.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Question Bank | EduStream Professional</title>
    
    <!-- Bootstrap 5 for layout utilities -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
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
            --btn-primary-bg: #0969da; 
            --btn-primary-hover: #0550ae;
            --focus-ring: rgba(9, 105, 218, 0.3);
            --danger-text: #cf222e;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-primary);
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* --- Main Card Container --- */
        .admin-card {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            width: 100%;
            max-width: 450px;
            padding: 32px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04), 0 1px 3px rgba(0, 0, 0, 0.02);
        }

        .brand-icon {
            color: var(--text-primary);
            font-size: 2rem;
            margin-bottom: 16px;
            display: inline-block;
        }

        .page-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .page-subtitle {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 24px;
        }

        /* --- Form Elements --- */
        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: block;
        }

        .premium-select, .premium-file {
            width: 100%;
            padding: 8px 12px;
            font-size: 0.9rem;
            color: var(--text-primary);
            background-color: var(--bg-body);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .premium-select {
            appearance: none;
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2357606a' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
        }

        .premium-select:hover, .premium-file:hover {
            background-color: #f3f4f6;
        }

        .premium-select:focus, .premium-file:focus {
            outline: none;
            border-color: var(--btn-primary-bg);
            box-shadow: 0 0 0 3px var(--focus-ring);
            background-color: var(--bg-surface);
        }

        /* --- Premium Button --- */
        .btn-primary-custom {
            width: 100%;
            background-color: var(--btn-primary-bg);
            color: #ffffff;
            border: 1px solid rgba(27, 31, 36, 0.15);
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-top: 24px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 1px 0 rgba(27, 31, 36, 0.1);
        }

        .btn-primary-custom:hover {
            background-color: var(--btn-primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-primary-custom:active {
            transform: translateY(0);
            box-shadow: none;
        }

        /* --- Secondary Links --- */
        .action-footer {
            margin-top: 24px;
            text-align: center;
            font-size: 0.85rem;
        }

        .link-cancel {
            color: var(--text-secondary);
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .link-cancel:hover {
            color: var(--danger-text);
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="admin-card">
        
        <div class="brand-icon">
            <i class="fa-solid fa-cloud-arrow-up"></i>
        </div>
        
        <h2 class="page-title">Upload Question Bank</h2>
        <p class="page-subtitle">Upload a CSV file to populate the question bank.</p>
        
        <!-- Alerts for Success/Error -->
        <% 
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if(error != null) { 
        %>
            <div class="alert alert-danger py-2 px-3 text-sm" role="alert"><%= error %></div>
        <% } else if(success != null) { %>
            <div class="alert alert-success py-2 px-3 text-sm" role="alert"><%= success %></div>
        <% } %>

        <!-- MODIFIED: Submits to UploadCsvServlet with multipart/form-data -->
        <form action="UploadCsvServlet" method="POST" enctype="multipart/form-data">
            
            <div class="mb-3">
                <label class="form-label" for="tech-select">Folder Category</label>
                <!-- MODIFIED: Name updated to match UploadCsvServlet expectations -->
                <select id="tech-select" name="category" class="premium-select" required>
                    <option value="" disabled selected hidden>Select folder...</option>
                    <option value="HTML">HTML5</option>
                    <option value="CSS">CSS3</option>
                    <option value="JavaScript">JavaScript</option>
                    <option value="React">React JS</option>
                    <option value="Java">Java Core</option>
                    <option value="SQL">SQL / MySQL</option>
                </select>
            </div>

            <!-- NEW: File Input for CSV -->
            <div class="mb-3">
                <label class="form-label" for="csv-file">CSV File</label>
                <input type="file" id="csv-file" name="csvFile" class="premium-file" accept=".csv" required>
                <div class="form-text" style="font-size: 0.75rem; color: var(--text-secondary); margin-top: 5px;">
                    Format: QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer
                </div>
            </div>

            <button type="submit" class="btn-primary-custom">
                <i class="fa-solid fa-upload"></i> Upload CSV
            </button>
            
            <div class="action-footer">
                <a href="adminDashboard.jsp" class="link-cancel">
                    Return to Dashboard
                </a>
            </div>

        </form>
    </div>

</body>
</html>