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
        Enumeration<String> params = request.getParameterNames();
        String redirect = params.nextElement();
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(connectString, user, pwd);
            Statement stmt = con.createStatement();
        	String table = params.nextElement() + "(";
        	int attr_num = Integer.parseInt(params.nextElement());
        	String values = "values(";
            String attr = params.nextElement();
            table += attr;
            values += "'" + request.getParameter(attr) + "'";
        	for (int i = 1; i < attr_num; ++i)
        	{
                attr = params.nextElement();
                table += "," + attr;
                values += ",'" + request.getParameter(attr) + "'";
        	}
        	table += ")";
        	values += ")";
            String fmt = "insert into %s %s";
            String sql = String.format(fmt, table, values);
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