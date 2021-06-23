<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.*"%>
<%
    String msg ="";
    String tag_list = "";
    String title_list = "";
    String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger_18308013";
    String pwd = "18340197";
    request.setCharacterEncoding("utf-8");
    try
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        String sql = "select distinct TName from Tag";
        ResultSet rs = stmt.executeQuery(sql);
        while(rs.next())
        {
        	String TName = rs.getString("TName");
        	tag_list += "<a class='tag' href='tags.jsp?tag=" + TName +  "'>" + TName + "</a>\n";
        }
        rs.close();
        String TName = request.getParameter("tag");
        if (TName != null)
        {
            sql = "select * from Article, Text, Tag where TName='" + TName + "' and Article.ATime=Tag.ATime and Article.ATime=Text.ATime";
            rs = stmt.executeQuery(sql);
            DateTimeFormatter idf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
            DateTimeFormatter odf = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss E");
            title_list += "<h1>相关文章</h1>\n";
            title_list += "<div class='titleList' id='titleList1'>\n";
            while(rs.next())
            {
                String ATime = LocalDateTime.parse(rs.getString("ATime").replace(" ", "T")).format(idf);
                title_list += "<div class='titleBlockDiv' onclick=\"openWebpage('article.jsp?ATime=" + ATime + "')\">\n";
                title_list += "    <div class='titleBlock'>\n";
                title_list += "        <h2>" + rs.getString("Title") + "</h2>\n";
                title_list += "        <p class=titleMessage>@" + rs.getString("Author") + "&nbsp;|&nbsp;" + LocalDateTime.parse(ATime,idf).format(odf) + "</p>\n";
                title_list += "    </div>\n";
                title_list += "    <div class='contentBlock'>\n";
                title_list += "        <p id='titleContent" + ATime + "' class='titleContent'></p>\n";
                title_list += "        <script>\n";
                title_list += "            var abstract = marked(\n";
                title_list += "`" + rs.getString("AContent").replace("\\", "\\\\").replace("`", "\\`") + "`\n";
                title_list += "            );\n";
                title_list += "            abstract = abstract.replaceAll(/<[^>]+>/g, '').replaceAll(/\\n/g, ' ').slice(0, 200) + '&hellip;';\n";
                title_list += "            document.getElementById('titleContent" + ATime + "').innerHTML = abstract;\n";
                title_list += "        </script>\n";
                title_list += "    </div>\n";
                title_list += "    <footer>Read More >></footer>\n";
                title_list += "</div>\n";
            }
            title_list += "</div>\n";
            rs.close();
            stmt.close();
            con.close();
        }
    }
    catch (Exception e)
    {
        msg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>个人博客</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/tags.css" />
        <link rel="stylesheet" type="text/css" href="css/home.css" />
        <style>
            .menuChecked {
                top: 60px;
            }
            .menuChecked .menu {
                top: -60px;
            }
        </style>
        <script src="js/marked.js"></script>
    </head>
    <body>
        <div id="blogCover" style="display: none;opacity: 1;">
            <h1>个人博客</h1>
            <button onClick="startHideCover()">继续</button>
        </div>
        <div id="leftPart">
            <div id="nameContainer">
                <div id="headPortraitContainer">
                    <div id="headPortrait"></div>
                </div>
                <div id="blogName">
                    <h2>XX的个人博客</h2>
                </div>
            </div>
            <div id="menuContainer">
                <ul class="menu">
                    <li>Home</li>
                    <li>Tags</li>
                    <li>Files</li>
                    <li>About</li>
                </ul>
                <!-- 用来代表原本菜单中的三个选项（li元素） -->
                <div class="menuHover menuHover1" onclick="openWebpage('home.jsp')"></div>
                <div class="menuHover menuHover2" onclick="openWebpage('tags.jsp')"></div>
                <div class="menuHover menuHover3" onclick="openWebpage('files.jsp')"></div>
                <div class="menuHover menuHover4" onclick="openWebpage('about.jsp')"></div>
                <div class="menuChecked">
                    <ul class="menu">
                        <li>Home</li>
                        <li>Tags</li>
                        <li>Files</li>
                        <li>About</li>
                    </ul>
                </div>
            </div>
           
        </div>
        <div id="mainPart">
            <div class="tagListDiv">
                <div style="clear:both"></div>
                <h1>标签</h1>
                <div class="tagList">
                    <div class="tagBlock">
<%=tag_list%>
                    </div>
                </div>
<%=title_list%>
            </div>
<%=msg%>            
        </div>
        
        <script>
            window.onscroll = function() {
                var sl=0-Math.max(document.body.scrollLeft,document.documentElement.scrollLeft);
                var style = document.defaultView.getComputedStyle(document.getElementById('leftPart'));  
                var leftWidth = parseInt(style.left);
                if (leftWidth>=0)
                    sl += parseInt(style.left);
                document.getElementById('leftPart').style.left = sl+'px';
            };
            window.onresize = function() {
                var clientWidth = Math.max(document.body.clientWidth, document.documentElement.clientWidth);
                var leftWidth = parseInt(document.defaultView.getComputedStyle(document.getElementById("leftPart")).width);
                var mainWidth = parseInt(document.defaultView.getComputedStyle(document.getElementById("mainPart")).width);
                var cl=Math.max(Math.ceil((clientWidth-leftWidth-mainWidth)/2), 0);
                document.getElementById('leftPart').style.left = cl+'px';
                document.getElementById('mainPart').style.left = (360+cl)+'px';
            }
            window.onresize();
            function openWebpage(path) {
                window.location.href = path;
            }
        </script>
    </body>
</html>