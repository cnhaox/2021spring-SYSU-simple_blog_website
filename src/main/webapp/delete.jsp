<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String msg ="";
	String connectString = "jdbc:mysql://localhost:3306/blog?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger";
    String pwd = "123";
    if (request.getMethod().equalsIgnoreCase("post"))
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        try
        {
            String AID = request.getParameter("AID");
            String fmt = "delete from Article where AID=%s";
            String sql = String.format(fmt, AID);
            int cnt = stmt.executeUpdate(sql);
            if (cnt > 0) msg = "Success!";
            stmt.close(); con.close();
        }
        catch (Exception e)
        {
            msg = e.getMessage();
        }
    }
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>delete</title>
        <style>
        </style>
    </head>
    <body>
        <div class = "container">
            <h1>delete</h1>
            <form action = "delete.jsp" method = "post" name = "f">
                AID:<input id = "AID" name = "AID" type = "text"><br>
                <input name = "delete" type = "submit" value = "delete">
            </form>
            <%=msg%>
        </div>
    </body>
</html>