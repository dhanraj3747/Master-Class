<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${assignment.title} | Submission</title>
    <style>
        /* Import a premium, modern geometric font */
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

        body { 
            font-family: 'Inter', system-ui, -apple-system, sans-serif; 
            background-color: #f3f4f6; /* Soft, pleasant gray background */
            color: #1f2937; 
            margin: 0; 
            padding: 40px 20px; 
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }
        .container { 
            max-width: 800px; 
            margin: auto; 
            background-color: #ffffff; 
            padding: 40px 50px; 
            border-radius: 16px; 
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.025); 
            border: 1px solid #ffffff; 
        }
        h2 { 
            margin-top: 0; 
            color: #111827; 
            font-weight: 600;
            font-size: 28px;
            letter-spacing: -0.025em;
        }
        .details { 
            background-color: #f8fafc; 
            padding: 16px 20px; 
            border-radius: 8px; 
            margin-bottom: 32px; 
            border: 1px solid #e2e8f0;
            color: #475569;
            font-size: 15px;
            display: flex;
            justify-content: space-between; /* Spreads Module and Score beautifully */
        }
        .question-box { 
            background: #ffffff; 
            padding: 24px; 
            border-radius: 12px; 
            margin-bottom: 24px; 
            border: 1px solid #e5e7eb; 
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
            transition: border-color 0.2s ease;
        }
        .question-box:hover {
            border-color: #cbd5e1;
        }
        h4 {
            margin-top: 0;
            margin-bottom: 16px;
            color: #1f2937;
            font-size: 16px;
            font-weight: 600;
        }
        label { 
            display: flex; 
            align-items: center;
            padding: 12px 16px; 
            background: #f9fafb; 
            margin-top: 10px; 
            border-radius: 8px; 
            cursor: pointer; 
            border: 1px solid #e5e7eb;
            transition: all 0.2s ease;
            font-size: 15px;
            color: #374151;
        }
        label:hover { 
            background: #f3f4f6; 
            border-color: #d1d5db;
        }
        /* Modern trick: Highlights the whole row when the radio is checked */
        label:has(input:checked) {
            background: #eff6ff;
            border-color: #3b82f6;
            color: #1d4ed8;
            font-weight: 500;
        }
        input[type="radio"] {
            margin-right: 12px;
            accent-color: #3b82f6; /* Modern blue standard */
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        .btn-submit { 
            background-color: #2563eb; 
            color: white; 
            padding: 14px 24px; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: 500;
            width: 100%;
            transition: background-color 0.2s ease, transform 0.1s ease;
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
            margin-top: 10px;
        }
        .btn-submit:hover { 
            background-color: #1d4ed8; 
        }
        .btn-submit:active {
            transform: translateY(1px); /* Satisfying click effect */
        }
        .btn-back { 
            color: #6b7280; 
            text-decoration: none; 
            display: inline-block; 
            margin-bottom: 24px; 
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        .btn-back:hover { 
            color: #111827; 
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="assignments" class="btn-back">← Back to Assignments</a>
        <h2>${assignment.title}</h2>
        <div class="details">
            <span><strong>Module:</strong> ${assignment.moduleName}</span>
            <span><strong>Max Score:</strong> ${assignment.maxScore}</span>
        </div>

        <form action="submitAssignment" method="post">
            <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">
            
            <c:forEach var="q" items="${questions}" varStatus="status">
                <div class="question-box">
                    <h4>${status.count}. ${q.questionText}</h4>
                    <label><input type="radio" name="q_${q.questionId}" value="A" required> ${q.optionA}</label>
                    <label><input type="radio" name="q_${q.questionId}" value="B"> ${q.optionB}</label>
                    <label><input type="radio" name="q_${q.questionId}" value="C"> ${q.optionC}</label>
                    <label><input type="radio" name="q_${q.questionId}" value="D"> ${q.optionD}</label>
                </div>
            </c:forEach>
            
            <button type="submit" class="btn-submit">Submit Assignment Answers</button>
        </form>
    </div>
</body>
</html>