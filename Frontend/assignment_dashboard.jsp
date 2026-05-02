<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignment Dashboard | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body { 
            /* Fresh, clean light background */
            background-color: #f4f7f6; 
            font-family: 'Poppins', 'Segoe UI', sans-serif; 
            color: #1e293b;
        }

        /* --- Header & Clock Styling --- */
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
            margin-bottom: 2rem;
        }

        .header-title {
            color: #0f172a;
            font-weight: 700;
            margin: 0;
        }

        .live-clock-pill {
            background: #ffffff;
            padding: 8px 18px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            font-size: 0.9rem;
            border: 1px solid rgba(14, 165, 233, 0.2);
            color: #475569;
        }

        .live-indicator {
            width: 8px;
            height: 8px;
            background-color: #0ea5e9; /* Cyan indicator */
            border-radius: 50%;
            box-shadow: 0 0 8px rgba(14, 165, 233, 0.6); /* Static premium glow */
        }

        /* --- Premium Static Card System --- */
        .card-premium-wrapper {
            position: relative;
            width: 100%;
            padding: 2px; /* Static border thickness */
            border-radius: 16px; 
            /* Elegant, fixed gradient border */
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.4), rgba(79, 172, 254, 0.15), rgba(0, 242, 254, 0.4));
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.04); 
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-premium-wrapper:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 242, 254, 0.15);
        }

        /* --- Inner Card Content --- */
        .inner-card {
            position: relative;
            background: #ffffff; /* Clean white interior */
            border-radius: 14px; /* Slightly smaller than wrapper to reveal gradient */
            padding: 30px 20px;
            height: 100%;
            z-index: 1; 
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .module-badge {
            background-color: rgba(14, 165, 233, 0.1);
            color: #0284c7;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 15px;
            border: 1px solid rgba(14, 165, 233, 0.2);
        }

        .assignment-title {
            font-weight: 700;
            color: #0f172a;
            font-size: 1.25rem;
            margin-bottom: 10px;
        }

        .assignment-meta {
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 25px;
        }

        /* --- Premium Static Button --- */
        .btn-start {
            /* Semi-transparent glassy cyan interior */
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.08), rgba(79, 172, 254, 0.12));
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(0, 242, 254, 0.3);
            color: #0284c7; /* Sharp sky blue text */
            border-radius: 8px;
            padding: 12px 20px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            display: block;
            text-align: center;
            text-decoration: none;
            text-transform: uppercase;
            box-shadow: 0 4px 10px rgba(0, 242, 254, 0.05);
        }

        /* Smooth fill on hover */
        .btn-start:hover {
            background: linear-gradient(135deg, #00f2fe, #4facfe);
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 8px 20px rgba(0, 242, 254, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="header-container">
            <h2 class="header-title">My Assignments</h2>
            <div class="live-clock-pill">
                <div class="live-indicator"></div>
                <span id="clock-display">Loading time...</span>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <c:forEach var="assign" items="${listAssignments}">
                <div class="col-md-4">
                    <div class="card-premium-wrapper h-100">
                        <div class="inner-card">
                            
                            <div>
                                <div class="module-badge">${assign.moduleName}</div>
                                <h4 class="assignment-title">${assign.title}</h4>
                                <div class="assignment-meta">
                                    <span class="formatted-date" data-date="${assign.dueDate}"></span>
                                </div>
                            </div>
                            
                            <div class="mt-auto">
                                <a href="assignments?action=view&id=${assign.assignmentId}" class="btn-start w-100">
                                    View & Submit
                                </a>
                            </div>

                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty listAssignments}">
                <div class="col-12 text-center mt-5">
                    <p class="fs-5" style="color: #64748b;">No assignments available at the moment.</p>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 1. Logic for the Live Ticking Clock
        function updateClock() {
            const now = new Date();
            const timeOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit' };
            const dateOptions = { weekday: 'short', month: 'short', day: 'numeric' };
            
            const timeString = now.toLocaleTimeString(undefined, timeOptions);
            const dateString = now.toLocaleDateString(undefined, dateOptions);
            
            document.getElementById('clock-display').innerText = dateString + ' | ' + timeString;
        }
        
        // Start the clock immediately, then update every 1 second
        updateClock();
        setInterval(updateClock, 1000);

        // 2. Logic to beautifully format the ugly SQL database dates
        document.querySelectorAll('.formatted-date').forEach(function(element) {
            let rawDate = element.getAttribute('data-date');
            
            // Safety check: if rawDate is empty or null, show a fallback
            if (!rawDate) {
                element.innerHTML = "<span>No due date set</span>";
                return;
            }

            // Remove the weird ".0" at the end of the SQL timestamp if it exists
            if(rawDate && rawDate.endsWith('.0')) {
                rawDate = rawDate.slice(0, -2);
            }
            
            // Convert to a proper JavaScript Date object
            // Replacing space with 'T' makes it compatible across all browsers (like Safari)
            let dateObj = new Date(rawDate.replace(' ', 'T'));
            
            // If the date is valid, format it nicely
            if (!isNaN(dateObj)) {
                let niceDate = dateObj.toLocaleString(undefined, { 
                    month: 'short', 
                    day: 'numeric', 
                    year: 'numeric', 
                    hour: '2-digit', 
                    minute: '2-digit' 
                });
                element.innerHTML = "<span>Due: <strong>" + niceDate + "</strong></span>";
            } else {
                element.innerHTML = "<span>" + rawDate + "</span>"; // Fallback to raw text
            }
        });
    </script>
</body>
</html>