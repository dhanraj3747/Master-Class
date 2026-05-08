<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security Check: Only allow 'admin' to see this page
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Question Portal | Edutree-Stars</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* =========================================================================
           ULTRA PREMIUM CYAN GLASSY THEME (Matched to Login.jsp)
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
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            padding: 40px 20px;
            min-height: 100vh;
        }

        .container-card {
            max-width: 700px;
            margin: 0 auto;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.08);
        }

        .brand-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-header i {
            font-size: 2.5rem;
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--cyan-secondary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* --- Form Elements --- */
        .form-label { font-size: 0.85rem; font-weight: 600; margin-bottom: 8px; color: var(--text-color); }
        
        .form-control, .premium-select {
            background: #ffffff;
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .form-control:focus, .premium-select:focus {
            border-color: var(--cyan-secondary);
            box-shadow: 0 0 0 4px var(--cyan-glow);
            outline: none;
        }

        /* --- Buttons --- */
        .btn-cyan {
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary));
            border: none;
            color: white;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 700;
            transition: 0.3s;
            width: 100%;
        }

        .btn-cyan:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px var(--cyan-glow);
        }

        .btn-outline-cyan {
            background: transparent;
            border: 2px solid var(--cyan-secondary);
            color: var(--cyan-secondary);
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
            width: 100%;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-outline-cyan:hover {
            background: var(--cyan-glow);
            color: var(--cyan-secondary);
        }

        .alert { border-radius: 12px; font-weight: 500; font-size: 0.9rem; }
    </style>
</head>
<body>

    <div class="container-card">
        <div class="brand-header">
            <i class="fa-solid fa-database"></i>
            <h2 class="fw-bold m-0">Question Bank Manager</h2>
            <p class="text-muted">Enterprise Content Portal</p>
        </div>

        <% 
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if(error != null) { 
        %>
            <div class="alert alert-danger py-2 px-3 mb-4"><i class="fas fa-times-circle me-2"></i><%= error %></div>
        <% } else if(success != null) { %>
            <div class="alert alert-success py-2 px-3 mb-4"><i class="fas fa-check-circle me-2"></i><%= success %></div>
        <% } %>

        <form id="bulkForm" action="UploadCsvServlet" method="POST" enctype="multipart/form-data">
            <div class="section-title"><i class="fas fa-file-csv"></i> 1. Bulk Upload (CSV)</div>
            
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label">Category Type</label>
                    <select id="bulk-type" name="questionType" class="form-select premium-select" required>
                        <option value="" disabled selected>Select type...</option>
                        <option value="Assessment">Assessment</option>
                        <option value="Assignment">Assignment</option>
                        <option value="Practice">Practice</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Target Folder</label>
                    <select name="category" class="form-select premium-select" required>
                        <option value="" disabled selected>Select technology...</option>
                        <option value="JAVA">Java Core</option>
                        <option value="HTML">HTML5</option>
                        <option value="CSS">CSS3</option>
                        <option value="JAVASCRIPT">JavaScript</option>
                        <option value="PYTHON">Python</option>
                    </select>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Choose CSV File</label>
                <input type="file" name="csvFile" class="form-control" accept=".csv" required>
            </div>

            <button type="submit" class="btn-cyan mb-4">
                <i class="fas fa-cloud-upload-alt me-2"></i> Process Bulk Upload
            </button>
        </form>

        <hr style="opacity: 0.1; margin: 30px 0;">

        <form id="manualForm" action="ManageQuestionServlet" method="POST">
            <div class="section-title"><i class="fas fa-pen-to-square"></i> 2. Create Single Question</div>
            
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <select id="manual-type" name="questionType" class="form-select premium-select" required>
                        <option value="" disabled selected>Select Type...</option>
                        <option value="Assessment">Assessment</option>
                        <option value="Assignment">Assignment</option>
                        <option value="Practice">Practice</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <select name="category" class="form-select premium-select" required>
                        <option value="" disabled selected>Select Folder...</option>
                        <option value="JAVA">Java Core</option>
                        <option value="HTML">HTML5</option>
                        <option value="CSS">CSS3</option>
                        <option value="JAVASCRIPT">JavaScript</option>
                        <option value="PYTHON">Python</option>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <input type="text" name="questionText" class="form-control" placeholder="Enter full question text..." required>
            </div>
            
            <div class="row g-2 mb-3">
                <div class="col-6"><input type="text" name="optionA" class="form-control" placeholder="Option A" required></div>
                <div class="col-6"><input type="text" name="optionB" class="form-control" placeholder="Option B" required></div>
                <div class="col-6"><input type="text" name="optionC" class="form-control" placeholder="Option C" required></div>
                <div class="col-6"><input type="text" name="optionD" class="form-control" placeholder="Option D" required></div>
            </div>

            <div class="mb-4">
                <select name="correctOption" class="form-select premium-select" required>
                    <option value="" disabled selected>Select Correct Answer...</option>
                    <option value="A">A</option><option value="B">B</option>
                    <option value="C">C</option><option value="D">D</option>
                </select>
            </div>

            <button type="submit" class="btn-cyan">
                <i class="fas fa-save me-2"></i> Save Single Question
            </button>
        </form>

        <hr style="opacity: 0.1; margin: 30px 0;">

        <div class="section-title"><i class="fas fa-list-check"></i> 3. Inventory Management</div>
        <div class="row g-3">
            <div class="col-12">
                <a href="adminViewQuestions.jsp" class="btn-outline-cyan">
                    <i class="fas fa-eye me-2"></i> View & Edit All Questions
                </a>
            </div>
            <div class="col-12 text-center mt-3">
                <a href="adminDashboard.jsp" class="text-decoration-none text-muted small fw-bold">
                    <i class="fas fa-arrow-left me-1"></i> Return to Main Dashboard
                </a>
            </div>
        </div>
    </div>

    <script>
        // 1. Bulk Upload Confirmation
        document.getElementById("bulkForm").addEventListener("submit", function(e) {
            const type = document.getElementById("bulk-type").value;
            const message = "Are you sure you want to create this " + type + " via bulk upload?";
            if(!confirm(message)) {
                e.preventDefault();
            }
        });

        // 2. Manual Creation Confirmation
        document.getElementById("manualForm").addEventListener("submit", function(e) {
            const type = document.getElementById("manual-type").value;
            const message = "Are you sure you want to create this " + type + " manually?";
            if(!confirm(message)) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>