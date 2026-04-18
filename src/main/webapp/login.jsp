<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            height: 100vh;
        }

        .login-container {
            height: 100vh;
        }

        .login-card {
            border: none;
            border-radius: 16px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            background: #ffffff;
        }

        .login-title {
            font-weight: 600;
            margin-bottom: 20px;
        }

        .form-control {
            border-radius: 10px;
            padding: 10px 15px;
        }

        .btn-primary {
            border-radius: 10px;
            padding: 10px;
            font-weight: 500;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background-color: #5a67d8;
        }

        .footer-text {
            font-size: 0.9rem;
            color: #777;
            margin-top: 15px;
            text-align: center;
        }
    </style>
</head>

<body>

<div class="container d-flex justify-content-center align-items-center login-container">
    <div class="card login-card shadow-lg">

        <h3 class="text-center login-title">Welcome Back</h3>

        <!-- Optional JSP Message -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="alert alert-danger text-center">Invalid email or password</div>
        <%
            }
        %>

        <form action="login" method="post">

            <div class="mb-3">
                <input class="form-control" type="text" name="email" placeholder="Enter your email" required>
            </div>

            <div class="mb-3">
                <input class="form-control" type="password" name="password" placeholder="Enter your password" required>
            </div>

            <div class="d-grid">
                <button class="btn btn-primary">Login</button>
            </div>

        </form>

        <div class="footer-text">
            © 2026 Your Company
        </div>

    </div>
</div>

</body>
</html>