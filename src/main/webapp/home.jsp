<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.*"%>
<%@ page import="java.io.*"%>
<%@ page import = "org.apache.commons.io.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%
    String userType = (String)session.getAttribute("userType");
    boolean isManager = false;
    if (userType==null)
        response.sendRedirect("index.jsp");
    else if (userType.equals("manager"))
        isManager = true;
%>
<%
    // 获取名字
    String namePath = application.getRealPath("info");
    File introFile = new File(namePath,"per_info.txt");
    Map<String, String> info = new HashMap<String, String>();
    String BLOGName = "";
    if (introFile.exists()) {
        FileInputStream ch = new FileInputStream(introFile);
        InputStreamReader fr = new InputStreamReader(ch,"UTF-8");
        BufferedReader br = new BufferedReader(fr);  //使文件可按行读取并具有缓冲功能
        String str = br.readLine();
        while(str!=null){
            info.put(str, br.readLine());   //将读取的内容放入info
            str = br.readLine();
        }
        br.close();
        BLOGName = info.get("name");
    }
%>
<%
    String msg ="";
    String title_list1 = "";
    String title_list2 = "";
    String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String user = "blogger_18308013";
    String pwd = "18340197";
    request.setCharacterEncoding("utf-8");
    try
    {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, user, pwd);
        Statement stmt = con.createStatement();
        String sql = "select * from Article, Text where Article.ATime=Text.ATime";
        if (request.getParameter("search") != null)
        {
        	sql += " and Title like '%" + request.getParameter("condition") + "%'";
        }
        else if (request.getParameter("delete") != null)
        {
        	String ATime = request.getParameter("ATime");
        	int redo = 100;
            do
            {
                try
                {
                    Class.forName("com.mysql.jdbc.Driver");
                    String fmt = "delete from Article where ATime='%s'";
                    String sql_temp = String.format(fmt, ATime);
                    int cnt = stmt.executeUpdate(sql_temp);
                    if (cnt > 0)
                    {
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
            File dir = new File(application.getRealPath("img/" + ATime.replace(":", "")));
            for (File file : dir.listFiles())
            {
                file.delete();
            }
            dir.delete();
        }
        ResultSet rs = stmt.executeQuery(sql);
        DateTimeFormatter idf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
        DateTimeFormatter odf = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss E");
        while(rs.next())
        {
            String ATime = LocalDateTime.parse(rs.getString("ATime").replace(" ", "T")).format(idf);
            String title = rs.getString("Title");
            title_list1 += "<div class='titleBlockDiv' onclick=\"openWebpage('article.jsp?ATime=" + ATime + "')\">\n";
            title_list1 += "    <div class='titleBlock'>\n";
            title_list1 += "        <h2>" + title + "</h2>\n";
            title_list1 += "        <p class=titleMessage>@" + rs.getString("Author") + "&nbsp;|&nbsp;" + LocalDateTime.parse(ATime,idf).format(odf) + "</p>\n";
            title_list1 += "    </div>\n";
            title_list1 += "    <div class='contentBlock'>\n";
            title_list1 += "        <p id='titleContent" + ATime + "' class='titleContent'></p>\n";
            title_list1 += "        <script>\n";
            title_list1 += "            var abstract = marked(\n";
            title_list1 += "`" + rs.getString("AContent").replace("\\", "\\\\").replace("`", "\\`") + "`\n";
            title_list1 += "            );\n";
            title_list1 += "            abstract = abstract.replaceAll(/<[^>]+>/g, '').replaceAll(/\\n/g, ' ').slice(0, 200) + '&hellip;';\n";
            title_list1 += "            document.getElementById('titleContent" + ATime + "').innerHTML = abstract;\n";
            title_list1 += "        </script>\n";
            title_list1 += "    </div>\n";
            title_list1 += "    <footer>Read More >></footer>\n";
            title_list1 += "</div>\n";
            title_list2 += "<tr>\n";
            title_list2 += "    <td>" + title + "</td>\n";
            title_list2 += "    <td>" + ATime + "</td>\n";
            title_list2 += "    <td>\n";
            title_list2 += "        <form action='edit.jsp' method='post'>\n";
            title_list2 += "            <input name='ATime' type='hidden' value='" + ATime + "'>\n";
            title_list2 += "            <input type='submit' class='editButton' name='edit' value='编&nbsp;&nbsp;辑'>\n";
            title_list2 += "        </form> \n";
            title_list2 += "        <form action='home.jsp' method='post' onsubmit='return checkDelete(this)'>\n";
            title_list2 += "            <input name='ATime' type='hidden' value='" + ATime + "'>\n";
            title_list2 += "            <input type='submit' class='deleteButton' name='delete' value='删&nbsp;&nbsp;除'>\n";
            title_list2 += "        </form>\n";
            title_list2 += "    </td>\n";
            title_list2 += "</tr>\n";
        }
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
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>home</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/home.css" />
        <style>
            .menuChecked {
                top: 0px;
            }
            .menuChecked .menu {
                top: -0px;
            }
        </style>
        <script src="js/marked.js"></script>
    </head>
    <body>
        <div id="leftPart">
            <div id="nameContainer">
                <div id="headPortraitContainer">
                    <div id="headPortrait"></div>
                </div>
                <div id="blogName">
                    <h2><%=BLOGName%>的个人博客</h2>
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
            <div class="titleListDiv">
                <div class="search">
                    <form action="home.jsp" method="post">
                        <i class="fa fa-search" aria-hidden="true"></i>
                        <input type="text" name="condition" placeholder="Searching...">
                        <input type="submit" name="search" value="搜索">
                    </form> 
                </div>
                <div style="clear:both"></div>
                <h1>文章</h1>
                <div class="titleList" id="titleList1">
                    <% if (isManager) {%>
                    <div class="manage">
                        <input type="button" class="manageButton" onclick="openWebpage('edit.jsp')" value="发布"/>
                        <input type="button" class="manageButton" onclick="manageArticle(true)" value="管理"/>
                    </div>
                    <%}%>
                    <div style="clear:both"></div>
<%=title_list1%>
                    <div><%=msg%></div>
                    <!--
                    <div class="pageBottonDiv">
                        <a href="" id="prevLink"><input type="button" class="pageButton" value="<< 上一页"></a>
                        <a href="http://www.baidu.com/" id="nextLink"><input type="button" class="pageButton" value="下一页 >>"></a>
                    </div>-->
                </div>
                <div class="titleList" id="titleList2">
                    <div class="manage">
                        <input type="button" class="manageButton" onclick="manageArticle(false)" value="完成"/>
                    </div>
                    <div style="clear:both"></div>
                    <table class="tableStyle">
                        <tr>
                            <th>文章标题</th>
                            <th>时间</th>
                            <th>操作</th>
                        </tr>
<%=title_list2%>
                    </table>
                    <div><%=msg%></div>
                </div>
            </div>
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
            function manageArticle(boolVal) {
                if (boolVal)
                {
                    document.getElementById("titleList1").style.display = "none";
                    document.getElementById("titleList2").style.display = "block";
                }
                else
                {
                    document.getElementById("titleList2").style.display = "none";
                    document.getElementById("titleList1").style.display = "block";
                }
            }
            function checkDelete(obj) {
                var articleName = obj.children[0].value;
                var r=confirm("是否确认删除 "+articleName+" ?");
                if (r)
                    return true;
                else
                    return false;
            }
        </script>
    </body>
</html>