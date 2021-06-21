<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%
    if (request.getMethod().equalsIgnoreCase("post"))
    {
        String msg ="";
        String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
        String user = "blogger_18308013";
        String pwd = "18340197";
        request.setCharacterEncoding("utf-8");
        Enumeration<String> params = request.getParameterNames();
        String redirect = params.nextElement();
        int redo = Integer.parseInt(params.nextElement());
        do
        {
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
                msg = "cnt:" + cnt;
                stmt.close();
                con.close();
                if (cnt > 0)
                {
                	msg = key;
                    break;
                }
                --redo;
            }
            catch (Exception e)
            {
                msg = e.getMessage();
                --redo;
            }
        }
        while (redo > 0);
        response.sendRedirect(redirect + (redirect.contains("?") ? "&" : "?") + "msg=" + msg);
    }
%>