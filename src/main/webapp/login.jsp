<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | Edutree-Stars</title>

    <!-- Google Fonts: Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* =========================================================================
           ULTRA PREMIUM ENTERPRISE THEME (SPLIT LAYOUT)
           ========================================================================= */
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --text-muted: #64748b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.15);
            --input-bg: #ffffff;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }

        /* --- Wide Enterprise Container --- */
        .enterprise-card {
            width: 100%;
            max-width: 1000px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            display: flex;
        }

        /* --- Left Branding Side --- */
        .brand-section {
            background: linear-gradient(135deg, rgba(0, 242, 254, 0.05), rgba(79, 172, 254, 0.15));
            border-right: 1px solid var(--glass-border);
            padding: 50px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .brand-logo {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-color);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-logo i {
            color: var(--cyan-primary);
            font-size: 2.2rem;
            filter: drop-shadow(0 0 10px var(--cyan-glow));
        }

        .feature-list {
            margin-top: 40px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .feature-icon {
            width: 40px;
            height: 40px;
            background: var(--cyan-glow);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--cyan-secondary);
            font-size: 1.1rem;
        }

        .feature-text h5 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 3px 0;
            color: var(--text-color);
        }

        .feature-text p {
            font-size: 0.85rem;
            margin: 0;
            color: var(--text-muted);
        }

        /* --- Right Form Side --- */
        .form-section {
            padding: 50px;
            flex: 1.2;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .auth-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--text-color);
        }

        .auth-subtitle {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-bottom: 35px;
        }

        /* --- Detailed Inputs --- */
        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 8px;
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group-custom i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
            transition: 0.3s;
        }

        .form-control {
            background: var(--input-bg);
            border: 1px solid var(--glass-border);
            color: var(--text-color);
            padding: 14px 16px 14px 45px;
            font-size: 0.95rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus {
            background: var(--input-bg);
            color: var(--text-color);
            border-color: var(--cyan-secondary);
            box-shadow: 0 0 0 4px var(--cyan-glow);
            outline: none;
        }

        .form-control:focus + i {
            color: var(--cyan-secondary);
        }

        /* --- Options Row --- */
        .options-row {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            font-size: 0.85rem;
        }

        .custom-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            cursor: pointer;
        }

        /* --- Primary Button --- */
        .btn-auth {
            background: linear-gradient(135deg, var(--cyan-primary), var(--cyan-secondary));
            border: none;
            color: #ffffff;
            padding: 14px;
            font-weight: 700;
            font-size: 1rem;
            border-radius: 12px;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px var(--cyan-glow);
        }

        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(0, 242, 254, 0.4);
            color: #ffffff;
        }

        /* Error Alert */
        .error-banner {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #ef4444;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .enterprise-card { flex-direction: column; max-width: 500px; }
            .brand-section { padding: 40px 30px; border-right: none; border-bottom: 1px solid var(--glass-border); }
            .form-section { padding: 40px 30px; }
            .feature-list { display: none; }
        }
    </style>
</head>
<body>

<div class="enterprise-card">
    
    <!-- LEFT SIDE: Branding & Features -->
    <div class="brand-section">
        <div>
            <div class="brand-logo">
                <i class="fas fa-layer-group"></i> Edutree-Stars
            </div>
            <p class="mt-3" style="color: var(--text-muted); font-size: 0.95rem;">
                The industry-standard platform for enterprise learning management, analytics, and student tracking.
            </p>
        </div>

        <div class="feature-list">
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-chart-pie"></i></div>
                <div class="feature-text">
                    <h5>Advanced Analytics</h5>
                    <p>Track performance via interactive dashboards.</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                <div class="feature-text">
                    <h5>Secure Access</h5>
                    <p>Enterprise-grade security and role-based control.</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="fas fa-certificate"></i></div>
                <div class="feature-text">
                    <h5>Global Certification</h5>
                    <p>Issue and manage industry-recognized credentials.</p>
                </div>
            </div>
        </div>

        <div style="font-size: 0.8rem; color: var(--text-muted);">
            &copy; 2026 Edutree-Stars Technologies. All rights reserved.
        </div>
    </div>

    <!-- RIGHT SIDE: Login Form -->
    <div class="form-section">
        <h1 class="auth-title">Welcome back</h1>
        <p class="auth-subtitle">Enter your credentials to access the portal.</p>

        <!-- Error Alert from Servlet -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="error-banner">
                <i class="fas fa-exclamation-circle"></i>
                Invalid email or password. Please try again.
            </div>
        <%
            }
        %>

        <form action="login" method="post">
            
            <!-- Email Field with Icon -->
            <label for="email" class="form-label">Email Address</label>
            <div class="input-group-custom">
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="admin@edustream.com" required autocomplete="email">
                <i class="far fa-envelope"></i>
            </div>

            <!-- Password Field with Icon -->
            <label for="password" class="form-label">Password</label>
            <div class="input-group-custom">
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="••••••••" required>
                <i class="fas fa-lock"></i>
            </div>

            <!-- Options Row -->
            <div class="options-row">
                <label class="custom-checkbox">
                    <input type="checkbox" checked style="accent-color: var(--cyan-secondary);">
                    Keep me signed in
                </label>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-auth">
                Sign In to Portal <i class="fas fa-arrow-right ms-2"></i>
            </button>
        </form>

    </div>

</div>

</body>
</html>