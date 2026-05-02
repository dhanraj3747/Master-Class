<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Question" %>
<%@ page import="com.tap.model.Assessment" %>

<%
    // 1. Session Check
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Retrieve Data passed from LoadAssessmentServlet
    Assessment assessment = (Assessment) request.getAttribute("assessment");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    
    // Fallbacks just in case data is missing
    String title = (assessment != null) ? assessment.getTitle() : "Assessment";
    int durationMinutes = (assessment != null) ? assessment.getDurationMinutes() : 30; // Default 30 mins
    int assessmentId = (assessment != null) ? assessment.getAssessmentId() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Take Assessment | EduStream</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f6f8fa;
            color: #24292f;
            padding-bottom: 80px; /* Space for sticky footer */
        }

        /* --- Sticky Top Bar (Timer & Info) --- */
        .exam-header {
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid #d0d7de;
        }

        .timer-box {
            background-color: #f3f4f6;
            border: 2px solid #d0d7de;
            border-radius: 8px;
            padding: 8px 20px;
            font-family: monospace;
            font-size: 1.5rem;
            font-weight: 700;
            color: #24292f;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        /* When time is running out (< 5 mins) */
        .timer-warning {
            background-color: #ffebe9;
            border-color: #ff8182;
            color: #cf222e;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(207, 34, 46, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(207, 34, 46, 0); }
            100% { box-shadow: 0 0 0 0 rgba(207, 34, 46, 0); }
        }

        /* --- Question Cards --- */
        .question-card {
            background: #ffffff;
            border: 1px solid #d0d7de;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .question-number {
            font-size: 0.85rem;
            font-weight: 700;
            color: #57606a;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
            display: block;
        }

        .question-text {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: #1e293b;
        }

        /* --- Custom Radio Buttons --- */
        .option-wrapper {
            margin-bottom: 12px;
        }

        .custom-radio {
            display: none;
        }

        .option-label {
            display: block;
            padding: 15px 20px;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-weight: 500;
            color: #24292f;
            background-color: #ffffff;
        }

        .option-label:hover {
            background-color: #f3f4f6;
        }

        /* Selected State */
        .custom-radio:checked + .option-label {
            border-color: #0969da;
            background-color: #f0f7ff;
            color: #0969da;
            box-shadow: 0 0 0 2px rgba(9, 105, 218, 0.2);
        }

        /* --- Submit Button --- */
        .btn-submit-exam {
            background-color: #0969da;
            color: white;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            box-shadow: 0 4px 10px rgba(9, 105, 218, 0.2);
            transition: all 0.3s ease;
        }
        
        .btn-submit-exam:hover {
            background-color: #0550ae;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <!-- 1. STICKY HEADER WITH TIMER -->
    <div class="exam-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 fw-bold"><%= title %></h4>
                <small class="text-muted">Do not refresh the page or you will lose your progress.</small>
            </div>
            
            <!-- Timer Display -->
            <div class="timer-box" id="timerBox">
                <i class="fa-regular fa-clock"></i>
                <span id="timeDisplay">--:--</span>
            </div>
        </div>
    </div>

    <!-- 2. EXAM FORM -->
    <div class="container mt-5" style="max-width: 800px;">
        
        <!-- Important: Passes data to SubmitAssessmentServlet -->
        <form id="assessmentForm" action="SubmitAssessmentServlet" method="POST">
            <input type="hidden" id="timeSpent" name="timeSpent" value="0">
            <!-- Hidden inputs to pass crucial IDs to the backend -->
            <input type="hidden" name="assessmentId" value="<%= assessmentId %>">
            <input type="hidden" name="studentId" value="<%= session.getAttribute("userId") %>">

            <% 
                if (questions != null && !questions.isEmpty()) {
                    int qNum = 1;
                    for (Question q : questions) {
            %>
            
            <!-- Question Card -->
            <div class="question-card">
                <span class="question-number">Question <%= qNum %> of <%= questions.size() %></span>
                <p class="question-text"><%= q.getQuestionText() %></p>
                
                <!-- Options: Note the 'name' attribute matches the question ID -->
                <div class="option-wrapper">
                    <input type="radio" id="q<%= q.getQuestionId() %>_a" name="q_<%= q.getQuestionId() %>" value="A" class="custom-radio">
                    <label for="q<%= q.getQuestionId() %>_a" class="option-label">A. <%= q.getOptionA() %></label>
                </div>
                
                <div class="option-wrapper">
                    <input type="radio" id="q<%= q.getQuestionId() %>_b" name="q_<%= q.getQuestionId() %>" value="B" class="custom-radio">
                    <label for="q<%= q.getQuestionId() %>_b" class="option-label">B. <%= q.getOptionB() %></label>
                </div>
                
                <div class="option-wrapper">
                    <input type="radio" id="q<%= q.getQuestionId() %>_c" name="q_<%= q.getQuestionId() %>" value="C" class="custom-radio">
                    <label for="q<%= q.getQuestionId() %>_c" class="option-label">C. <%= q.getOptionC() %></label>
                </div>
                
                <div class="option-wrapper">
                    <input type="radio" id="q<%= q.getQuestionId() %>_d" name="q_<%= q.getQuestionId() %>" value="D" class="custom-radio">
                    <label for="q<%= q.getQuestionId() %>_d" class="option-label">D. <%= q.getOptionD() %></label>
                </div>
            </div>

            <% 
                    qNum++;
                    } 
                } else { 
            %>
                <div class="alert alert-warning text-center">
                    No questions found for this assessment.
                </div>
            <% } %>

            <!-- Submit Action -->
            <div class="text-center mt-5 mb-5">
                <button type="button" class="btn-submit-exam" onclick="confirmSubmission()">
                    <i class="fa-solid fa-paper-plane me-2"></i> Submit Assessment
                </button>
            </div>

        </form>
    </div>
   

    <!-- 3. TIMER AND AUTO-SUBMIT JAVASCRIPT -->
    <script>
        // Convert the duration from minutes to total seconds
        const initialSeconds = <%= durationMinutes %> * 60; 
        let totalSeconds = initialSeconds; 
        
        const timeDisplay = document.getElementById('timeDisplay');
        const timerBox = document.getElementById('timerBox');
        const assessmentForm = document.getElementById('assessmentForm');

        function updateTimer() {
            // Calculate minutes and seconds
            let minutes = Math.floor(totalSeconds / 60);
            let seconds = totalSeconds % 60;

            // Add leading zeros (e.g., 09:05)
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            // Update UI
            timeDisplay.textContent = minutes + ":" + seconds;

            // Warning state: less than 5 minutes remaining
            if (totalSeconds <= 300 && totalSeconds > 0) {
                timerBox.classList.add('timer-warning');
            }

            // Time's up! Force submit
            if (totalSeconds <= 0) {
                clearInterval(timerInterval);
                timeDisplay.textContent = "00:00";
                alert("Time is up! Your assessment is being submitted automatically.");
                
                // Set time spent (which is the maximum time in this case)
                document.getElementById('timeSpent').value = initialSeconds;
                
                assessmentForm.submit(); // Automatically submits the form
            } else {
                totalSeconds--;
            }
        }

        // Run the timer every 1000ms (1 second)
        const timerInterval = setInterval(updateTimer, 1000);
        
        // Initialize display immediately
        updateTimer();

        // Manual Submission Confirmation
        function confirmSubmission() {
            if(confirm("Are you sure you want to submit your assessment? You cannot change your answers after submitting.")) {
                // Calculate total seconds spent by subtracting remaining seconds from initial seconds
                document.getElementById('timeSpent').value = initialSeconds - totalSeconds;
                assessmentForm.submit();
            }
        }
    </script>
</body>
</html>