<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String tech = request.getParameter("tech");
    if(tech == null) tech = "JAVA";
    tech = tech.toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= tech %> Professional Module | EduStream Pro</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* =========================================================================
           MATCHED COLOR PALETTE (Glassy Cyan Enterprise)
           ========================================================================= */
        :root {
            --bg-color: #f4f7f9; 
            --glass-bg: rgba(255, 255, 255, 0.9);
            --glass-border: rgba(255, 255, 255, 0.6);
            --text-color: #1e293b;
            --cyan-primary: #00f2fe;
            --cyan-secondary: #4facfe;
            --cyan-glow: rgba(0, 242, 254, 0.2);
            --cyan-gradient: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            background-image: radial-gradient(circle at 0% 0%, var(--cyan-glow), transparent 40%), 
                              radial-gradient(circle at 100% 100%, var(--cyan-glow), transparent 40%);
            background-attachment: fixed;
            color: var(--text-color);
            padding: 50px 20px;
        }

        .content-card {
            max-width: 950px;
            margin: auto;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 30px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.08);
        }

        .module-hero {
            background: var(--cyan-gradient);
            padding: 50px;
            color: white;
            text-align: center;
        }

        .module-hero h1 { font-weight: 800; font-size: 2.8rem; letter-spacing: -1px; }

        .main-content { padding: 50px; }

        h2 { font-weight: 700; color: #0f172a; margin-top: 40px; margin-bottom: 20px; display: flex; align-items: center; gap: 15px; }
        h2 i { color: var(--cyan-secondary); }

        p { line-height: 1.8; color: #475569; font-size: 1.05rem; margin-bottom: 20px; }

        .code-window {
            background: #0f172a;
            color: #38bdf8;
            padding: 25px;
            border-radius: 16px;
            font-family: 'Fira Code', monospace;
            margin: 25px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border-left: 5px solid var(--cyan-primary);
        }

        .info-pill {
            background: var(--cyan-glow);
            border: 1px solid var(--cyan-secondary);
            color: var(--cyan-secondary);
            padding: 15px 25px;
            border-radius: 12px;
            font-weight: 600;
            margin-bottom: 30px;
        }

        .btn-finish {
            background: var(--cyan-gradient);
            color: white;
            font-weight: 700;
            padding: 20px;
            border-radius: 15px;
            width: 100%;
            border: none;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px var(--cyan-glow);
            margin-top: 50px;
        }

        .btn-finish:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(0, 242, 254, 0.4);
        }

        ul li { margin-bottom: 12px; color: #475569; }
    </style>
</head>
<body>

<div class="content-card">
    <div class="module-hero">
        <h6 class="text-uppercase fw-bold opacity-75 mb-2">Curriculum Excellence</h6>
        <h1><%= tech %> Masterclass</h1>
        <p class="text-white opacity-75 mb-0">Level: Intermediate to Advanced • Duration: 45 Mins</p>
    </div>

    <div class="main-content">
        
        <div class="info-pill">
            <i class="fas fa-info-circle me-2"></i> 
            <strong>Note:</strong> Completion of this reading will automatically unlock your Assessment and Assignment tasks.
        </div>

        <% if(tech.equals("JAVA")) { %>
            <h2><i class="fas fa-microchip"></i> 1. Java Architecture (JDK vs JRE vs JVM)</h2>
            <p>To master Java, you must understand the environment. The <strong>JDK (Java Development Kit)</strong> contains tools like the compiler. The <strong>JRE (Java Runtime Environment)</strong> provides libraries, and the <strong>JVM (Java Virtual Machine)</strong> is the engine that actually executes the bytecode.</p>
            
            <h2><i class="fas fa-plus-circle"></i> 2. Feature Focus: Adding Two Numbers</h2>
            <p>In Java, arithmetic operations are performed using standard operators. We utilize the <code>Scanner</code> class from <code>java.util</code> to accept dynamic user input from the console.</p>
            
            <div class="code-window">
                import java.util.Scanner;<br><br>
                public class Main {<br>
                &nbsp;&nbsp;public static void main(String[] args) {<br>
                &nbsp;&nbsp;&nbsp;&nbsp;Scanner input = new Scanner(System.in);<br>
                &nbsp;&nbsp;&nbsp;&nbsp;System.out.print("Enter First Number: ");<br>
                &nbsp;&nbsp;&nbsp;&nbsp;int num1 = input.nextInt();<br>
                &nbsp;&nbsp;&nbsp;&nbsp;System.out.print("Enter Second Number: ");<br>
                &nbsp;&nbsp;&nbsp;&nbsp;int num2 = input.nextInt();<br><br>
                &nbsp;&nbsp;&nbsp;&nbsp;int sum = num1 + num2;<br>
                &nbsp;&nbsp;&nbsp;&nbsp;System.out.println("Result: " + sum);<br>
                &nbsp;&nbsp;}<br>
                }
            </div>

            <h2><i class="fas fa-project-diagram"></i> 3. Memory Management</h2>
            <p>Java handles memory automatically through <strong>Garbage Collection</strong>. Objects are stored in the <em>Heap</em>, while local variables and method calls reside in the <em>Stack</em>.</p>

        <% } else if(tech.equals("HTML")) { %>
            <h2><i class="fas fa-code"></i> 1. Semantic Tagging & SEO</h2>
            <p>Modern web standards demand semantic HTML. Instead of generic <code>&lt;div&gt;</code> tags, we use <code>&lt;main&gt;</code>, <code>&lt;nav&gt;</code>, and <code>&lt;article&gt;</code>. This tells search engines exactly what each part of your page represents.</p>

            <div class="code-window">
                &lt;header&gt;<br>
                &nbsp;&nbsp;&lt;h1&gt;Global Education&lt;/h1&gt;<br>
                &lt;/header&gt;<br>
                &lt;section id="course-details"&gt;<br>
                &nbsp;&nbsp;&lt;p&gt;Learning HTML5 is the first step to becoming a dev.&lt;/p&gt;<br>
                &lt;/section&gt;
            </div>

            <h2><i class="fas fa-wpforms"></i> 2. Form Validation</h2>
            <p>HTML5 introduced native validation. By adding attributes like <code>required</code>, <code>minlength</code>, and <code>type="email"</code>, the browser handles errors before the data even reaches your Java backend.</p>

        <% } else if(tech.equals("CSS")) { %>
            <h2><i class="fas fa-layer-group"></i> 1. The Modern Box Model</h2>
            <p>Everything in CSS is a box. We control the spacing using <strong>Margin</strong> (outside the border), <strong>Border</strong>, <strong>Padding</strong> (inside the border), and <strong>Content</strong>. Using <code>box-sizing: border-box;</code> is an industry standard to simplify width calculations.</p>

            <h2><i class="fas fa-th"></i> 2. Flexbox vs Grid</h2>
            <ul>
                <li><strong>Flexbox:</strong> Perfect for aligning items in a single row or column.</li>
                <li><strong>CSS Grid:</strong> Designed for complex, two-dimensional layouts with rows AND columns.</li>
            </ul>

            <div class="code-window">
                .container {<br>
                &nbsp;&nbsp;display: flex;<br>
                &nbsp;&nbsp;justify-content: center;<br>
                &nbsp;&nbsp;align-items: center;<br>
                &nbsp;&nbsp;gap: 20px;<br>
                }
            </div>

        <% } else if(tech.equals("JAVASCRIPT")) { %>
            <h2><i class="fab fa-js"></i> 1. DOM Manipulation</h2>
            <p>The Document Object Model (DOM) is an interface that allows scripts to update the content, structure, and style of a document while it's being viewed. We use <code>document.getElementById()</code> to target specific elements.</p>

            <div class="code-window">
                const button = document.querySelector('#completeBtn');<br>
                button.addEventListener('click', () => {<br>
                &nbsp;&nbsp;console.log("Course Status Updated!");<br>
                &nbsp;&nbsp;document.body.style.backgroundColor = "#e0f2fe";<br>
                });
            </div>

            <h2><i class="fas fa-bolt"></i> 2. ES6+ Modern Syntax</h2>
            <p>Modern JS utilizes <strong>Arrow Functions</strong>, <strong>Template Literals</strong>, and <strong>Destructuring</strong> to write cleaner, more maintainable enterprise code.</p>

        <% } else if(tech.equals("PYTHON")) { %>
            <h2><i class="fab fa-python"></i> 1. Indentation & Readability</h2>
            <p>Unlike Java or C++, Python does not use curly braces. It uses <strong>Whitespace Indentation</strong> to define blocks of code. This forces developers to write clean, readable code by default.</p>

            <div class="code-window">
                def calculate_sum(a, b):<br>
                &nbsp;&nbsp;&nbsp;&nbsp;result = a + b<br>
                &nbsp;&nbsp;&nbsp;&nbsp;return result<br><br>
                print(f"The total is: {calculate_sum(50, 50)}")
            </div>

            <h2><i class="fas fa-chart-line"></i> 2. Data Science Ecosystem</h2>
            <p>Python's strength lies in its libraries. <strong>NumPy</strong> handles arrays, <strong>Pandas</strong> manages dataframes, and <strong>Matplotlib</strong> generates professional visualizations.</p>
        <% } %>

        <form action="ProgressActionServlet" method="GET">
            <input type="hidden" name="action" value="complete">
            <input type="hidden" name="tech" value="<%= tech %>">
            <input type="hidden" name="task" value="course_read">
            
            <button type="submit" class="btn-finish shadow">
                <i class="fas fa-check-circle me-2"></i> 
                Complete Reading & Unlock Final Tasks
            </button>
        </form>

    </div>
</div>

<p class="text-center text-muted mt-4 mb-5 small">
    &copy; 2026 EduStream Pro Learning Management System • Verified Professional Curriculum
</p>

</body>
</html>