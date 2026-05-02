<%@ page import="com.tap.dao.AssessmentDAO, com.tap.model.Assessment, java.util.List" %>
<%
    // Verify admin role to show the creation button
    String currentRole = (String) session.getAttribute("role");
    boolean isAdmin = currentRole != null && currentRole.equals("admin");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Assessment Dashboard | EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { 
            background-color: #f6f8fa; 
            font-family: 'Poppins', 'Segoe UI', sans-serif; 
        }

        /* --- Premium Static Card System --- */
        .card-premium-wrapper {
            position: relative;
            width: 100%;
            padding: 2px;
            border-radius: 16px; 
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.4), rgba(139, 92, 246, 0.2), rgba(6, 182, 212, 0.4));
            box-shadow: 0 10px 25px rgba(0,0,0,0.05); 
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-premium-wrapper:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(6, 182, 212, 0.15);
        }

        .inner-card {
            position: relative;
            background: #ffffff;
            border-radius: 14px; 
            padding: 30px 20px;
            height: 100%;
            z-index: 1; 
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .assessment-title {
            font-weight: 700;
            color: #1e293b;
            font-size: 1.25rem;
            margin-bottom: 10px;
        }

        .assessment-meta {
            color: #64748b;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 25px;
            line-height: 1.8;
        }

        /* --- Premium Static Button --- */
        .btn-start {
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.1), rgba(79, 172, 254, 0.15));
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(0, 242, 254, 0.3);
            color: #0284c7; 
            border-radius: 8px;
            padding: 12px 20px;
            font-weight: 600;
            letter-spacing: 0.3px;
            transition: all 0.3s ease;
            display: block;
            text-decoration: none;
            box-shadow: 0 4px 10px rgba(0, 242, 254, 0.05);
            text-align: center;
        }

        .btn-start:hover {
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.9), rgba(79, 172, 254, 0.9));
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 8px 20px rgba(0, 242, 254, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body class="p-5">
    <div class="container">
        
        <!-- Header with conditional Admin "Create" button -->
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="fw-bold m-0" style="color: #0f172a;">Available Assessments</h2>
            
            <% if(isAdmin) { %>
                <button type="button" class="btn btn-primary px-4 py-2" data-bs-toggle="modal" data-bs-target="#createAssessmentModal">
                    <i class="fas fa-plus me-2"></i> Create Assessment
                </button>
            <% } %>
        </div>
        
        <div class="row g-4"> 
            <% 
                AssessmentDAO dao = new AssessmentDAO();
                List<Assessment> assessments = dao.getAllAssessments();
                if(assessments != null && !assessments.isEmpty()) {
                    for(Assessment a : assessments) {
            %>
            <div class="col-md-4">
                <div class="card-premium-wrapper h-100">
                    <div class="inner-card text-center">
                        <div>
                            <h4 class="assessment-title"><%= a.getTitle() %></h4>
                            <p class="assessment-meta">
                                <i class="fas fa-layer-group me-1"></i> <%= a.getModuleName() %> Module <br>
                                <i class="fas fa-question-circle me-1"></i> <%= a.getTotalQuestions() %> Questions <br>
                                <!-- NEW: Displaying the Timer limit on the card -->
                               <i class="fas fa-clock me-1 text-danger"></i> <%= a.getDurationMinutes() %> Mins Limit
                            </p>
                        </div>
                        
                        <div class="mt-auto">
                            <a href="LoadAssessmentServlet?id=<%= a.getAssessmentId() %>" class="btn-start w-100">
    Start Assessment
    
    
    
</a>

<!-- Displaying the dynamic Timer limit on the card -->

                        </div>
                        
                    </div>
                </div>
            </div>
            <% 
                    }
                } else { 
            %>
                <div class="col-12 text-center">
                    <p class="text-muted fs-5">No assessments available at the moment.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- NEW: CREATE ASSESSMENT MODAL (Admin Only) -->
    <% if(isAdmin) { %>
    <div class="modal fade" id="createAssessmentModal" tabindex="-1" aria-labelledby="createAssessmentModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-light">
            <h5 class="modal-title fw-bold" id="createAssessmentModalLabel">Create New Assessment</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="CreateAssessmentServlet" method="POST">
              <div class="modal-body">
                  <div class="mb-3">
                      <label class="form-label fw-semibold">Assessment Title</label>
                      <input type="text" name="title" class="form-control" placeholder="e.g. Core Java Final Quiz" required>
                  </div>
                  <div class="mb-3">
                      <label class="form-label fw-semibold">Module Name / Folder</label>
                      <input type="text" name="moduleName" class="form-control" placeholder="e.g. Java" required>
                  </div>
                  <div class="row">
                      <div class="col-md-6 mb-3">
                          <label class="form-label fw-semibold">Total Questions</label>
                          <input type="number" name="totalQuestions" class="form-control" min="1" required>
                      </div>
                      <div class="col-md-6 mb-3">
                          <label class="form-label fw-semibold text-danger">Time Limit (Minutes)</label>
                          <select name="durationMinutes" class="form-select" required>
                              <option value="15">15 Minutes</option>
                              <option value="30" selected>30 Minutes</option>
                              <option value="45">45 Minutes</option>
                              <option value="60">60 Minutes</option>
                              <option value="90">90 Minutes</option>
                          </select>
                      </div>
                  </div>
              </div>
              <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Assessment</button>
              </div>
          </form>
        </div>
      </div>
    </div>
    <% } %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    


<!-- TIMER LOGIC -->

</body>
</html>