<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
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
            params = request.getParameterNames();
            params.nextElement();
            params.nextElement();
            try
            {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection(connectString, user, pwd);
                Statement stmt = con.createStatement();
                String table = params.nextElement() + "(";
                String key_name = params.nextElement();
                String key = request.getParameter(key_name);
                String datetime = LocalDateTime.now().toString();
                if (key_name.equals("datetime"))
                {
                	key_name = key;
                	key = datetime;
                }
                table += key_name;
                String values = "values('" + key.replace("\\", "\\\\").replace("'", "''") + "'";
                int attr_num = Integer.parseInt(params.nextElement());
                for (int i = 0; i < attr_num; ++i)
                {
                    String attr_name = params.nextElement();
                    String attr = request.getParameter(attr_name);
                    if (attr_name.equals("datetime"))
                    {
                        attr_name = attr;
                        attr = datetime;
                    }
                    table += "," + attr_name;
                    values += ",'" + attr.replace("\\", "\\\\").replace("'", "''") + "'";
                }
                table += ")";
                values += ")";
                String fmt = "insert into %s %s";
                String sql = String.format(fmt, table, values);
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