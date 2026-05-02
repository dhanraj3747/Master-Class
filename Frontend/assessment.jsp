<%@ page import="java.sql.*,com.project.DBConnection" %>

<%
    // ✅ TEMP (remove after login works)
    if(session.getAttribute("student_id") == null){
        session.setAttribute("student_id", 1); // for testing
    }

    Connection con = DBConnection.getConnection();

    if(con == null){
        out.println("<h3>❌ Database Connection Failed</h3>");
        return;
    }

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM questions_bank WHERE assessment_id=?"
    );
    ps.setInt(1, 1);

    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Assessment</title>

<style>
body {
    font-family: Arial;
    background: #f4f4f4;
}
.container {
    width: 60%;
    margin: auto;
    background: white;
    padding: 20px;
    border-radius: 10px;
}
.question {
    margin-bottom: 15px;
}
button {
    background: purple;
    color: white;
    padding: 10px;
    border: none;
}
</style>

</head>
<body>

<div class="container">
<h2>Assessment Test</h2>

<form action="submitAssessment.jsp" method="post">

<%
boolean hasData = false;

while(rs.next()){
    hasData = true;

    int qid = rs.getInt("id");
    String question = rs.getString("question");
    String type = rs.getString("type");
%>

<div class="question">
    <p><b><%= question %></b></p>

<%
    // ✅ MCQ
    if("MCQ".equalsIgnoreCase(type)){
        PreparedStatement ps2 = con.prepareStatement(
            "SELECT * FROM options WHERE question_id=?"
        );
        ps2.setInt(1, qid);
        ResultSet rs2 = ps2.executeQuery();

        while(rs2.next()){
%>
        <input type="radio" name="q<%=qid%>" 
               value="<%=rs2.getString("option_text")%>" required>
        <%=rs2.getString("option_text")%><br>
<%
        }
    } 
    // ✅ SINGLE WORD
    else if("SINGLE".equalsIgnoreCase(type)){
%>
        <input type="text" name="q<%=qid%>" 
               placeholder="Enter answer" required>
<%
    }
%>

</div>

<%
}

// ❌ If no questions
if(!hasData){
    out.println("<h3 style='color:red;'>No questions found in database ❌</h3>");
}
%>

<br>
<button type="submit">Submit Test</button>

</form>

</div>

</body>
</html>