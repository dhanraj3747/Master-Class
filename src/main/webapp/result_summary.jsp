<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assessment Results | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f6f8fa; color: #24292f; }
        
        .hero-card {
            background: linear-gradient(135deg, #0969da, #0550ae);
            color: white;
            border-radius: 16px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(9, 105, 218, 0.2);
            margin-bottom: 40px;
        }

        .score-display { font-size: 4rem; font-weight: 800; line-height: 1; margin-bottom: 10px; }
        
        .stats-container {
            display: flex; justify-content: center; gap: 30px; margin-top: 20px;
            background: rgba(255,255,255,0.1); padding: 15px; border-radius: 12px;
        }

        .review-card {
            background: #ffffff; border-radius: 12px; padding: 25px; margin-bottom: 20px;
            border-left: 6px solid #d0d7de; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        .review-card.correct { border-left-color: #2da44e; }
        .review-card.wrong { border-left-color: #cf222e; }

        .status-badge {
            display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; margin-bottom: 15px;
        }
        .correct-badge { background: #dafbe1; color: #1a7f37; }
        .wrong-badge { background: #ffebe9; color: #cf222e; }

        .answer-box {
            background: #f6f8fa; padding: 12px; border-radius: 8px; margin-top: 15px; font-size: 0.9rem;
        }
    </style>
</head>
<body class="py-5">
    <div class="container" style="max-width: 800px;">
        
        <!-- Hero Section -->
        <div class="hero-card">
            <h2 class="fw-bold mb-4">Assessment Complete!</h2>
            <div class="score-display">${score} <span style="font-size: 2rem; color: rgba(255,255,255,0.7);">/ ${totalQuestions}</span></div>
            <p class="fs-5 fw-medium m-0">Total Score</p>
            
            <div class="stats-container">
                <div>
                    <i class="fa-regular fa-clock mb-1"></i> Time Taken
                    <div class="fw-bold fs-5">${timeTaken}</div>
                </div>
                <div>
                    <i class="fa-solid fa-bullseye mb-1"></i> Accuracy
                    <div class="fw-bold fs-5">
                        <c:choose>
                            <c:when test="${totalQuestions > 0}">${String.format("%.0f", (score * 100.0) / totalQuestions)}%</c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="fw-bold mb-4"><i class="fa-solid fa-list-check me-2 text-primary"></i>Detailed Review</h4>

        <!-- Loop through questions -->
        <c:forEach var="item" items="${reviewList}">
            <div class="review-card ${item.correct ? 'correct' : 'wrong'}">
                <span class="status-badge ${item.correct ? 'correct-badge' : 'wrong-badge'}">
                    <i class="fa-solid ${item.correct ? 'fa-check' : 'fa-xmark'} me-1"></i> 
                    ${item.correct ? 'Correct' : 'Incorrect'}
                </span>
                
                <h5 class="fw-semibold text-dark">${item.questionText}</h5>
                
                <div class="answer-box">
                    <div class="mb-2">
                        <span class="text-muted fw-semibold me-2">Your Answer:</span> 
                        <span class="${item.correct ? 'text-success fw-bold' : 'text-danger fw-bold'}">Option ${item.selectedOption}</span>
                    </div>
                    <c:if test="${!item.correct}">
                        <div>
                            <span class="text-muted fw-semibold me-2">Correct Answer:</span> 
                            <span class="text-success fw-bold">Option ${item.correctOption}</span>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>

        <div class="text-center mt-5">
            <a href="studentDashboard.jsp" class="btn btn-outline-secondary px-4 py-2 fw-semibold">
                <i class="fa-solid fa-arrow-left me-2"></i> Return to Dashboard
            </a>
        </div>

    </div>
</body>
</html>