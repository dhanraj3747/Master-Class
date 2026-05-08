<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.tap.dao.QuestionDAO, com.tap.model.Question" %>
<%
    if(session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp"); return;
    }
    QuestionDAO dao = new QuestionDAO();
    List<Question> allQuestions = dao.getAllQuestions();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Question Inventory | EduStream Pro</title>
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
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }

        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--bg-color); 
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            padding: 40px; 
        }

        .glass-panel { 
            background: var(--glass-bg); 
            backdrop-filter: blur(20px); 
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px; 
            padding: 40px; 
            border: 1px solid var(--glass-border); 
            box-shadow: 0 20px 50px rgba(0,0,0,0.08); 
        }

        /* --- Standardized Table Styling --- */
        .table { border-collapse: separate; border-spacing: 0 12px; }
        .table thead th { 
            background: var(--cyan-gradient); 
            color: white; 
            border: none; 
            padding: 15px;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
        }
        .table thead th:first-child { border-radius: 12px 0 0 12px; }
        .table thead th:last-child { border-radius: 0 12px 12px 0; }

        .table tbody tr { 
            background: white; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.03); 
            transition: 0.3s;
        }
        .table tbody tr:hover { transform: scale(1.01); box-shadow: 0 8px 20px var(--cyan-glow); }
        .table td { padding: 20px 15px; border: none; vertical-align: middle; }

        .badge-tech { background: var(--cyan-glow); color: var(--cyan-secondary); border: 1px solid var(--cyan-secondary); padding: 5px 12px; border-radius: 20px; font-weight: 600; }
        
        .btn-edit-cyan { 
            color: var(--cyan-secondary); 
            border: 2px solid var(--cyan-secondary); 
            width: 40px; height: 40px; 
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 10px; transition: 0.3s;
        }
        .btn-edit-cyan:hover { background: var(--cyan-gradient); color: white; border-color: transparent; }

        .btn-delete-red { 
            color: #ef4444; 
            border: 2px solid #ef4444; 
            width: 40px; height: 40px; 
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 10px; transition: 0.3s; margin-left: 8px;
        }
        .btn-delete-red:hover { background: #ef4444; color: white; }

        .btn-add-new {
            background: var(--cyan-gradient);
            color: white; border: none; padding: 12px 25px; border-radius: 12px;
            font-weight: 700; box-shadow: 0 8px 20px var(--cyan-glow);
        }
    </style>
</head>
<body>
    <div class="container-fluid glass-panel">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold m-0"><i class="fas fa-layer-group me-2" style="color: var(--cyan-secondary);"></i>Question Inventory</h2>
            <a href="questionportal.jsp" class="btn-add-new text-decoration-none">
                <i class="fas fa-plus-circle me-2"></i> Create Content
            </a>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th class="ps-4">Technology</th>
                    <th>Type</th>
                    <th>Question Description</th>
                    <th>Correct Key</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for(Question q : allQuestions) { %>
                <tr>
                    <td class="ps-4"><span class="badge-tech"><%= q.getFolderCategory() %></span></td>
                    <td><span class="text-muted small fw-bold"><%= q.getQuestionType() %></span></td>
                    <td style="max-width: 450px;" class="text-truncate fw-500"><%= q.getQuestionText() %></td>
                    <td class="fw-bold text-success"><%= q.getCorrectOption() %></td>
                    <td class="text-center">
                        <a href="editQuestion.jsp?id=<%= q.getQuestionId() %>" class="btn-edit-cyan"><i class="fas fa-pen"></i></a>
                        <a href="DeleteServlet?id=<%= q.getQuestionId() %>" class="btn-delete-red" onclick="return confirm('Remove this from database permanently?')"><i class="fas fa-trash-alt"></i></a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>