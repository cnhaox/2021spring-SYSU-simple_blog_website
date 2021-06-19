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
            String fmt = "insert into Article(AID,Title,Author,ATime) values(%s,'%s','%s','%s')";
            String sql = String.format(fmt, AID, title, author, DTfmt.format(new java.util.Date()));
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
        <title>insert</title>
        <style>
        </style>
    </head>
    <body>
        <div class = "container">
            <h1>insert</h1>
            <form action = "insert.jsp" method = "post" name = "f">
                AID:<input id = "AID" name = "AID" type = "text"><br>
                Title:<input id = "Title" name = "Title" type = "text"><br>
                Author:<input id = "Author" name = "Author" type = "text"><br>
                <input name = "insert" type = "submit" value = "insert">
            </form>
            <%=msg%>
        </div>
    </body>
</html>
