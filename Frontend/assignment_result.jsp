<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assignment Result | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; padding: 40px 0; }
        .result-card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .score-circle { width: 120px; height: 120px; background: #a855f7; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 36px; font-weight: bold; margin: 0 auto 20px; }
        .review-box { border-radius: 12px; padding: 20px; margin-bottom: 15px; border-left: 5px solid; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .review-correct { border-left-color: #10b981; }
        .review-incorrect { border-left-color: #ef4444; }
    </style>
</head>
<body>
    <div class="container" style="max-width: 800px;">
        
        <div class="result-card text-center">
            <h2 class="fw-bold mb-4">Assignment Graded!</h2>
            <div class="score-circle">
                ${finalScore } / ${totalQuestions}
            </div>
            <p class="text-muted fs-5 mb-4">Your assignment has been submitted and recorded successfully.</p>
            <a href="studentDashboard.jsp" class="btn btn-dark px-4 py-2 rounded-pill fw-bold">Return to Dashboard</a>
        </div>

        <h4 class="fw-bold mb-3">Performance Review</h4>
        
        <c:forEach var="q" items="${questionsList}" varStatus="status">
            <c:set var="userAns" value="${userAnswers[q.questionId]}" />
            <c:set var="isCorrect" value="${userAns == q.correctOption}" />
            
            <div class="review-box ${isCorrect ? 'review-correct' : 'review-incorrect'}">
                <h6 class="fw-bold mb-3">Q${status.count}. ${q.questionText}</h6>
                
                <c:choose>
                    <c:when test="${isCorrect}">
                        <div class="text-success fw-bold">
                            <i class="fas fa-check-circle me-1"></i> Your Answer: ${userAns}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-danger fw-bold mb-1">
                            <i class="fas fa-times-circle me-1"></i> Your Answer: ${userAns}
                        </div>
                        <div class="text-success fw-bold">
                            <i class="fas fa-check-circle me-1"></i> Correct Answer: ${q.correctOption}
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>

    </div>
</body>
</html>