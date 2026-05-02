<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | EduStream Professional</title>

    <!-- Google Fonts: Inter is the industry standard for UI -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --brand-primary: #0066ff; /* Clean Blue */
            --bg-body: #f8fafc;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --card-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-main);
            margin: 0;
        }

        /* --- Minimalist Card Container --- */
        .auth-card {
            width: 100%;
            max-width: 420px;
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .brand-logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--brand-primary);
            letter-spacing: -0.5px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .auth-title {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #0f172a;
        }

        .auth-subtitle {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-bottom: 32px;
        }

        /* --- Premium Input Styling --- */
        .form-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #475569;
            margin-bottom: 6px;
        }

        .input-group-text {
            background-color: transparent;
            border-right: none;
            color: var(--text-muted);
        }

        .form-control {
            border: 1px solid #e2e8f0;
            padding: 12px 16px;
            font-size: 0.95rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(0, 102, 255, 0.1);
            outline: none;
        }

        /* --- GitHub-style Primary Button --- */
        .btn-auth {
            background-color: var(--brand-primary);
            border: none;
            color: white;
            padding: 12px;
            font-weight: 600;
            font-size: 0.95rem;
            border-radius: 8px;
            width: 100%;
            transition: transform 0.1s ease, background-color 0.2s ease;
        }

        .btn-auth:hover {
            background-color: #0052cc;
            transform: translateY(-1px);
        }

        .btn-auth:active {
            transform: translateY(0);
        }

        /* --- Error Handling --- */
        .error-banner {
            background-color: #fef2f2;
            border: 1px solid #fee2e2;
            color: #b91c1c;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .footer-links {
            margin-top: 24px;
            text-align: center;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .footer-links a {
            color: var(--brand-primary);
            text-decoration: none;
            font-weight: 500;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="auth-card">
    <!-- Header Section -->
    <div class="brand-logo">
        <i class="bi bi-mortardboard-fill"></i> EduStream
    </div>
    
    <h1 class="auth-title">Welcome back</h1>
    <p class="auth-subtitle">Please enter your details to sign in.</p>

    <!-- Error Alert from Servlet -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="error-banner">
            <i class="bi bi-exclamation-circle-fill"></i>
            Invalid email or password. Please try again.
        </div>
    <%
        }
    %>

    <form action="login" method="post">
        <!-- Email Field -->
        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <input type="email" class="form-control" id="email" name="email" 
                   placeholder="name@company.com" required autocomplete="email">
        </div>

        <!-- Password Field -->
        <div class="mb-4">
            <div class="d-flex justify-content-between">
                <label for="password" class="form-label">Password</label>
                
            </div>
            <input type="password" class="form-control" id="password" name="password" 
                   placeholder="••••••••" required>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn btn-auth">
            Sign in
        </button>
    </form>

    <!-- Simple Footer -->
   
</div>

</body>
</html>