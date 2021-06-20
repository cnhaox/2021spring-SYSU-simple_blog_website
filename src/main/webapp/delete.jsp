<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String msg ="";
	String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger_18308013";
    String pwd = "18340197";
    if (request.getMethod().equalsIgnoreCase("post"))
    {
        Enumeration<String> params = request.getParameterNames();
        String redirect = params.nextElement();
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(connectString, user, pwd);
            Statement stmt = con.createStatement();
        	String table = params.nextElement();
        	String key_name = params.nextElement();
            String key = "'" + request.getParameter(key_name) + "'";
            String fmt = "delete from %s where %s=%s";
            String sql = String.format(fmt, table, key_name, key);
            int cnt = stmt.executeUpdate(sql);
            msg = "" + cnt;
            stmt.close();
            con.close();
        }
        catch (Exception e)
        {
            msg = e.getMessage();
        }
        response.sendRedirect(redirect+"?msg="+msg);
    }
%>