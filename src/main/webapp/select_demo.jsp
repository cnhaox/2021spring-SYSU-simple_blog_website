<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String msg ="";
	String connectString = "jdbc:mysql://localhost:3306/blog?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger";
    String pwd = "123";
    StringBuilder table = new StringBuilder();
    if (request.getMethod().equalsIgnoreCase("post"))
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(connectString, user, pwd);
            Statement stmt = con.createStatement();
            String AID = request.getParameter("AID");
            String fmt = "select * from Article where AID=%s";
            String sql = String.format(fmt, AID);
            ResultSet rs = stmt.executeQuery(sql);
            table.append("<table><tr><th>AID</th><th>Title</th><th>Author</th><th>ATime</th></tr>");
            while(rs.next())
            {
                table.append
                (String.format(
                    "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
                    rs.getString("AID"), rs.getString("Title"), rs.getString("Author"), rs.getString("ATime")
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
            <form action = "select_demo.jsp" method = "post" name = "f">
                AID<input id = "AID" name = "AID" type = "text">
                <input name = "select" type = "submit" value = "select">
            </form>
            <%=table%>
            <%=msg%>
		</div>
	</body>
</html>