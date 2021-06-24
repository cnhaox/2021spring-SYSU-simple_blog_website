<%@ page language="java" import="java.util.*,java.io.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="javax.swing.JOptionPane"%>
<%
    request.setCharacterEncoding("utf-8");
    String userType = (String)session.getAttribute("userType");
    if (request.getParameter("submit1")!=null)
    {
        session.setAttribute("userType", "visitor");
        response.sendRedirect("home.jsp");
    }
    if (request.getParameter("submit2")!=null)
    {
        String password = request.getParameter("password");
        if (password.equals("123"))
        {
            session.setAttribute("userType", "manager");
            response.sendRedirect("home.jsp");
        }
        else
        	JOptionPane.showMessageDialog(null, "密码错误！", "error", JOptionPane.PLAIN_MESSAGE);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>My Blog</title>
<link rel="stylesheet" type="text/css" href="css/general.css" />
<link rel="stylesheet" type="text/css" href="css/index.css" />
<style>
</style>
</head>
<body>
    <div id="shadow"></div>
    <div id="title">Welcome To My Blog !</div>
    <div id="nav">
        <ul>
            <li><label for="submit1" style="cursor:pointer;">游客入口</label></li>
            <li id="managerEntry"><a onclick="displayPasswordDiv(true)" style="cursor:pointer;">管理员入口</a></li>
        </ul>
        <div id="passwordDiv">
            <form action="index.jsp" method="post">
                <input type="password" name="password" placeholder="请输入密码（默认：123）">
                <input type="submit" name="submit2" value="确&nbsp;&nbsp;认">
                <input type="submit" class="hidden" name="submit1" id="submit1" value="游客">
            </form> 
        </div>
    </div>
    <div id="footer">
        <p>&copy; 2021 SYSU Web</p>
    </div>

    <script>
        window.onresize = function() {
            var clientWidth = document.documentElement.scrollWidth;
            var clientHeight = Math.max(document.documentElement.clientHeight, document.documentElement.scrollHeight);
            var shadow = document.getElementById("shadow");
            shadow.style.width = "" + clientWidth + "px";
            shadow.style.height = "" + clientHeight + "px";
        }
        window.onresize();
        function displayPasswordDiv(boolValue) {
            var div = document.getElementById("passwordDiv");
            if (boolValue)
            {
                div.children[0].children[0].value = "";
                div.style.display = "block";
            }
            else
            div.style.display = "none";
        }
        if ( window.history.replaceState )
        {
            window.history.replaceState( null, null, window.location.href );
        }
    </script>
</body>
</html>