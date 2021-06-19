<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
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
            String title = request.getParameter("Title");
            String author = request.getParameter("Author");
            SimpleDateFormat DTfmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String fmt = "update Article set Title='%s',Author='%s',ATime='%s' where AID=%s";
            String sql = String.format(fmt, title, author, DTfmt.format(new java.util.Date()), AID);
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
        <title>update</title>
        <style>
        </style>
    </head>
    <body>
        <div class = "container">
            <h1>update</h1>
            <form action = "update.jsp" method = "post" name = "f">
                AID:<input id = "AID" name = "AID" type = "text"><br>
                Title:<input id = "Title" name = "Title" type = "text"><br>
                Author:<input id = "Author" name = "Author" type = "text"><br>
                <input name = "update" type = "submit" value = "update">
            </form>
            <%=msg%>
        </div>
    </body>
</html>