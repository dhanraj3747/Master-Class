<%@ page import="java.sql.*,java.util.*,com.project.DBConnection" %>

<%
Connection con = DBConnection.getConnection();
int studentId = (Integer) session.getAttribute("student_id");

Enumeration<String> params = request.getParameterNames();

while(params.hasMoreElements()){
    String param = params.nextElement();

    if(param.startsWith("q")){
        int qid = Integer.parseInt(param.substring(1));
        String ans = request.getParameter(param);

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO answers(student_id, question_id, answer) VALUES (?, ?, ?)"
        );
        ps.setInt(1, studentId);
        ps.setInt(2, qid);
        ps.setString(3, ans);
        ps.executeUpdate();
    }
}
%>

<h2>Test Submitted Successfully ✅</h2>
<a href="result.jsp">View Result</a>