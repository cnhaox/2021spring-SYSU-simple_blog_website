<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	String msg ="";
    StringBuilder table = new StringBuilder();
	String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "user";
    String pwd = "123";
	request.setCharacterEncoding("utf-8");
    try
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        String sql = "select * from Article";
        ResultSet rs = stmt.executeQuery(sql);
        table.append("<table><tr><th>ATime</th><th>Title</th><th>Author</th></tr>");
        while(rs.next())
        {
            table.append
            (String.format(
                "<tr><td>%s</td><td>%s</td><td>%s</td></tr>",
                rs.getString("ATime"), rs.getString("Title"), rs.getString("Author")
            ));
        }
        table.append("</table>");
        rs.close();
        stmt.close();
        con.close();
    }
    catch (Exception e)
    {
        msg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
	<head>
		<title>select</title>
		<style>
		</style>
	</head>
	<body>
		<div class="container">
			<h1>select</h1>
            <%=table%>
            <%=msg%>
		</div>
	</body>
</html>