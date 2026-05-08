<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tap.dao.QuestionDAO, com.tap.model.Question" %>
<%
    // 1. Security Check
    if(session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp"); 
        return;
    }
    
    // 2. Fetch Question Data
    String idStr = request.getParameter("id");
    if(idStr == null) {
        response.sendRedirect("adminViewQuestions.jsp");
        return;
    }
    int id = Integer.parseInt(idStr);
    Question q = new QuestionDAO().getQuestionById(id);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Question | EduStream Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root { 
            --cyan-primary: #00f2fe; 
            --cyan-secondary: #4facfe; 
            --cyan-glow: rgba(0, 242, 254, 0.15); 
        }
        body { 
            font-family: 'Poppins', sans-serif; 
            background: #f4f7f9; 
            padding: 60px 20px; 
            background-image: radial-gradient(circle at 10% 20%, var(--cyan-glow), transparent 30%); 
        }
        .edit-card { 
            max-width: 650px; 
            margin: auto; 
            background: rgba(255,255,255,0.85); 
            backdrop-filter: blur(20px); 
            border: 1px solid rgba(255,255,255,0.6); 
            border-radius: 24px; 
            padding: 40px; 
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.05); 
        }
        .form-control, .form-select { 
            border-radius: 12px; 
            padding: 12px; 
            margin-bottom: 15px; 
            border: 1px solid #d0d7de; 
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: var(--cyan-secondary);
            box-shadow: 0 0 0 4px var(--cyan-glow);
        }
        .btn-update { 
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary)); 
            border: none; 
            color: white; 
            font-weight: 700; 
            padding: 14px; 
            border-radius: 12px; 
            width: 100%; 
            box-shadow: 0 10px 20px var(--cyan-glow); 
            margin-top: 20px;
            transition: 0.3s;
        }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 15px 30px var(--cyan-glow); }
        .label-style { font-size: 0.8rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px; display: block; }
    </style>
</head>
<body>
    <div class="edit-card">
        <h3 class="fw-bold mb-4"><i class="fas fa-edit me-2 text-info"></i>Edit <%= q.getFolderCategory() %> Question</h3>
        
        <form action="UpdateQuestionServlet" method="POST">
            <input type="hidden" name="id" value="<%= q.getQuestionId() %>">
            
            <label class="label-style">Question Description</label>
            <textarea name="text" class="form-control" rows="3" required><%= q.getQuestionText() %></textarea>
            
            <div class="row">
                <div class="col-6">
                    <label class="label-style">Option A</label>
                    <input type="text" name="optA" class="form-control" value="<%= q.getOptionA() %>" required>
                </div>
                <div class="col-6">
                    <label class="label-style">Option B</label>
                    <input type="text" name="optB" class="form-control" value="<%= q.getOptionB() %>" required>
                </div>
                <div class="col-6">
                    <label class="label-style">Option C</label>
                    <input type="text" name="optC" class="form-control" value="<%= q.getOptionC() %>" required>
                </div>
                <div class="col-6">
                    <label class="label-style">Option D</label>
                    <input type="text" name="optD" class="form-control" value="<%= q.getOptionD() %>" required>
                </div>
            </div>
            
            <label class="label-style">Correct Answer Key</label>
            <select name="correct" class="form-select">
                <option value="A" <%= q.getCorrectOption().equals("A") ? "selected" : "" %>>A</option>
                <option value="B" <%= q.getCorrectOption().equals("B") ? "selected" : "" %>>B</option>
                <option value="C" <%= q.getCorrectOption().equals("C") ? "selected" : "" %>>C</option>
                <option value="D" <%= q.getCorrectOption().equals("D") ? "selected" : "" %>>D</option>
            </select>
            
            <button type="submit" class="btn-update">Update Database Record</button>
            
            <div class="text-center mt-3">
                <a href="adminViewQuestions.jsp" class="text-muted small text-decoration-none">
                    <i class="fas fa-arrow-left me-1"></i> Cancel and Return
                </a>
            </div>
        </form>
    </div>
</body>
</html>