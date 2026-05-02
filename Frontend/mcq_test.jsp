<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assessment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0d1117; color: #c9d1d9; font-family: 'Segoe UI', sans-serif; }
        .question-card { background: #161b22; border: 1px solid #30363d; border-radius: 12px; padding: 25px; margin-bottom: 20px; }
        .form-check-label { cursor: pointer; padding: 10px; width: 100%; border-radius: 8px; transition: 0.2s; }
        .form-check-label:hover { background-color: #21262d; }
    </style>
</head>
<body class="p-5">
    <div class="container" style="max-width: 800px;">
        <h2 class="mb-4 text-center fw-bold">Assessment in Progress</h2>
        
        <form action="evaluateTest" method="post">
            <c:forEach var="q" items="${currentQuestions}" varStatus="loop">
                <div class="question-card shadow-lg">
                    <h5>${loop.count}. ${q.questionText}</h5>
                    <div class="mt-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="ans_${q.questionId}" value="A" id="q${q.questionId}A" required>
                            <label class="form-check-label" for="q${q.questionId}A">A) ${q.optionA}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="ans_${q.questionId}" value="B" id="q${q.questionId}B">
                            <label class="form-check-label" for="q${q.questionId}B">B) ${q.optionB}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="ans_${q.questionId}" value="C" id="q${q.questionId}C">
                            <label class="form-check-label" for="q${q.questionId}C">C) ${q.optionC}</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="ans_${q.questionId}" value="D" id="q${q.questionId}D">
                            <label class="form-check-label" for="q${q.questionId}D">D) ${q.optionD}</label>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary btn-lg px-5">Submit Assessment</button>
            </div>
        </form>
    </div>
    
    <script>
    // Dynamically grab the duration from the assessment object passed by the Servlet.
    // If it fails to find it, it defaults to 30 minutes as a safety net.
    let durationInMinutes = <%= (request.getAttribute("assessment") != null) ? ((com.tap.model.Assessment)request.getAttribute("assessment")).getDurationMinutes() : 30 %>;
    
    let totalSeconds = durationInMinutes * 60;
    const timeDisplay = document.getElementById('timeDisplay');
    const timerDiv = document.getElementById('floating-timer');

    function updateTimer() {
        let m = Math.floor(totalSeconds / 60);
        let s = totalSeconds % 60;
        
        // Add leading zeros
        timeDisplay.textContent = (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);

        // Warning state: less than 5 minutes remaining (turns Red)
        if (totalSeconds <= 300 && totalSeconds > 0) {
            timerDiv.style.color = "#ff4757";
            timerDiv.style.borderColor = "#ff4757";
            timerDiv.style.boxShadow = "0 0 15px rgba(255, 71, 87, 0.6)";
        }

        // Time is up! Auto-submit
        if (totalSeconds <= 0) {
            clearInterval(timerInterval);
            timeDisplay.textContent = "00:00";
            alert("Time is up! Your assessment is being submitted automatically.");
            
            // This grabs the first <form> on your page and forces it to submit
            document.forms[0].submit(); 
        } else {
            totalSeconds--;
        }
    }

    // Start the countdown
    const timerInterval = setInterval(updateTimer, 1000);
    updateTimer();
</script>
</body>
</html>