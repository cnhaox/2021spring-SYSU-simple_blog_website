<!-- 时间属性用到的包 -->
<%@ page import="java.time.*"%>
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
            	<!-- 重定位地址 -->
                <input name = "update_demo.jsp" type = "hidden">
            	<!-- 表名 -->
                <input name = "Article" type = "hidden">
            	<!-- 主键 -->
                AID:<input name = "AID" type = "text"><br>
            	<!-- 需要更新的属性数量 -->
                <input name = "2" type = "hidden">
            	<!-- 普通属性 -->
                Title:<input name = "Title" type = "text"><br>
            	<!-- 时间属性 -->
                <input name = "ATime" value = <%=LocalDateTime.now()%> type = "hidden">
            	<!-- 这个只是个按钮，不算属性 -->
                <input name = "update" type = "submit" value = "update">
            </form>
            <!-- 返回msg -->
            <%=request.getParameter("msg")%>
        </div>
    </body>
</html>
