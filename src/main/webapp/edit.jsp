<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding = "utf-8"%>
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
    else if (userType.equals("visitor"))
        response.sendRedirect("index.jsp");
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
	String msg = "";
	String title = "";
	String author = "";
	String tags = "";
	String content = "";
	String ATime = "";
	String mode = "insertArticle";
    String folder_name = "";
    String path_name = "";
	String img_table = "";
    if (request.getMethod().equalsIgnoreCase("post"))
    {
        mode = "updateArticle";
        String connectString = "jdbc:mysql://localhost:3306/blog_18308045?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
        String user = "blogger_18308013";
        String pwd = "18340197";
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSSSS");
        request.setCharacterEncoding("utf-8");
        boolean isMultipart = ServletFileUpload.isMultipartContent(request); // 是否用multipart提交的?
        try
        {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(connectString, user, pwd);
            Statement stmt = con.createStatement();
            if (isMultipart)
            {
                FileItemFactory factory = new DiskFileItemFactory();
                ServletFileUpload upload = new ServletFileUpload(factory);
                List items = upload.parseRequest(request);
                boolean mode_is_update = ((FileItem)items.get(items.size() - 1)).getFieldName().equals("updateArticle");
                content = ((FileItem)items.get(items.size() - 3)).getString("utf-8");
                tags = ((FileItem)items.get(items.size() - 4)).getString("utf-8");
                author = ((FileItem)items.get(items.size() - 5)).getString("utf-8");
                title = ((FileItem)items.get(items.size() - 6)).getString("utf-8");
                if (mode_is_update)
                {
                    ATime = ((FileItem)items.get(items.size() - 2)).getString();
                }
                int redo = 100;
                String fmt = "";
                String sql = "";
                do
                {
                    try
                    {
                    	if (mode_is_update)
                    	{
                    		fmt = "update Article set Title='%s', Author='%s' where ATime='%s'";
                    		sql = String.format(fmt, title, author, ATime);
                    	}
                    	else
                    	{
                            ATime = LocalDateTime.now().format(df);
                            fmt = "insert into Article values('%s', '%s', '%s')";
                            sql = String.format(fmt, ATime, title, author);
                    	}
                        int cnt = stmt.executeUpdate(sql);
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
                folder_name = "img/" + ATime.replace(":", "");
                path_name = application.getRealPath(folder_name);
                content = content.replace("<!--Folder-->", folder_name);
                redo = 100;
                do
                {
                    try
                    {
                    	if (mode_is_update)
                    	{
                            fmt = "update Text set AContent='%s' where ATime='%s'";
                            sql = String.format(fmt, content.replace("\\", "\\\\").replace("'", "''"), ATime);
                    	}
                        else
                        {
                            fmt = "insert into Text values('%s', '%s')";
                            sql = String.format(fmt, ATime, content.replace("\\", "\\\\").replace("'", "''"));
                        }
                        int cnt = stmt.executeUpdate(sql);
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
                String[] tag_list = tags.split(";");
                Set<String> tag_set_new = new HashSet<String>();
                Set<String> tag_set_old = new HashSet<String>();
                if (mode_is_update)
                {
                    for (int i = 0; i < tag_list.length; ++i)
                    {
                    	tag_set_new.add(tag_list[i]);
                    }
                    fmt = "select TName from Tag where ATime='%s'";
                    sql = String.format(fmt, ATime);
                    ResultSet rs = stmt.executeQuery(sql);
                    while(rs.next())
                    {
                    	String TName = rs.getString("TName");
                    	if (!tag_set_new.contains(TName))
                    	{
                            Statement stmt_new = con.createStatement();
                    		redo = 100;
                    		do
                    		{
                    			try
                    			{
                                    fmt = "delete from Tag where TName='%s' and ATime='%s'";
                                    sql = String.format(fmt, TName, ATime);
                                    int cnt = stmt_new.executeUpdate(sql);
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
                            stmt_new.close();
                    	}
                    	else
                    	{
                            tag_set_old.add(TName);
                    	}
                    }
                }
                for (int i = 0; i < tag_list.length; ++i)
                {
                    if (!tag_set_old.contains(tag_list[i]))
                    {
                        redo = 100;
                        do
                        {
                            try
                            {
                                fmt = "insert into Tag values('%s', '%s')";
                                sql = String.format(fmt, tag_list[i], ATime);
                                int cnt = stmt.executeUpdate(sql);
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
                    }
                }
                Set<String> img_set_old = new HashSet<String>();
                Set<String> img_set_new = new HashSet<String>();
                if (mode_is_update)
                {
                    for (int i = 0; i < items.size() - 7; i++)
                    {
                        FileItem fi = (FileItem) items.get(i);
                        if (!fi.isFormField())// 如果不是表单元素，跳过。 旧图片的name存储在表单元素中
                            continue;
                        img_set_new.add(fi.getFieldName());
                    }
                    File dir=new File(path_name);
                    for(File file : dir.listFiles())
                    {
                        String fname = file.getName();
                        if (!img_set_new.contains(fname))
                        {
                            file.delete();
                        }
                        else
                        {
                            img_set_old.add(fname);
                        }
                    }
                }
                else
                {
                    File dir = new File(path_name);
                    dir.mkdir(); 
                }
                for (int i = 0; i < items.size() - 7; i++)
                {
                    FileItem fi = (FileItem)items.get(i);
                    if (fi.isFormField())// 如果是表单元素，跳过。 新图片存储在文件元素中
                        continue;
                    DiskFileItem dfi = (DiskFileItem) fi;
                    String fname = FilenameUtils.getName(dfi.getName());
                    if (!mode_is_update || !img_set_old.contains(fname))
                    {
                        dfi.write(new File(path_name + "/" + fname));
                    }
                }
            }
            else
            {
                ATime = request.getParameter("ATime");
                folder_name = "img/" + ATime.replace(":", "");
                path_name = application.getRealPath(folder_name);
                String fmt = "select * from Article,Text where Article.ATime='%s' and Text.ATime='%s'";
                String sql = String.format(fmt, ATime, ATime);
                ResultSet rs = stmt.executeQuery(sql);
                rs.next();
                title = rs.getString("Title");
                author = rs.getString("Author");
                content = rs.getString("AContent");
                rs.close();
                fmt = "select TName from Tag where ATime='%s'";
                sql = String.format(fmt, ATime);
                rs = stmt.executeQuery(sql);
                if (rs.next())
                {
                    tags += rs.getString("TName");
                }
                while (rs.next())
                {
                    tags += ";" + rs.getString("TName");
                }
                rs.close();
            }
            stmt.close();
            con.close();
            File dir=new File(path_name);
            for(File file : dir.listFiles())
            {
                img_table += "<tr class='old-img-tr'>\n";
                img_table += "    <td>" + folder_name + "/" + file.getName() + "</td>\n";
                img_table += "    <td>\n";
                img_table += "        <div>\n";
                img_table += "            <button class='deleteButton' onclick='deleteImgTr(this)'>删&nbsp;&nbsp;除</button>\n";
                img_table += "            <input type='hidden' form='newArticle' name='" + file.getName() + "'/>\n";
                img_table += "        </div>\n";
                img_table += "    </td>\n";
                img_table += "</tr>\n";
            }
        }
        catch (Exception e)
        {
            msg = e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>个人博客</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="css/edit.css" />
        <style>
            .menuChecked {
                top: 0px;
            }
            .menuChecked .menu {
                top: -0px;
            }
        </style>
        <script>
            if ( window.history.replaceState )
            {
                window.history.replaceState( null, null, window.location.href );
            }
        </script>
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
            <div class="edit-container">
                <h1>发布</h1>
                <form action="edit.jsp" method="post" id="newArticle" class="form-hidden-style" onsubmit="return checkSubmit(this)" enctype="multipart/form-data">
                </form>
                <div class="img-list">
                    <table class="tableStyle" id="imgTable">
                        <tbody >
                            <tr>
                                <th>图片路径</th>
                                <th>操作</th>
                            </tr>
<%=img_table%>
                            <tr class="new-img-tr">
                                <td></td>
                                <td>
                                    <div class="hidden">
                                        <button class="deleteButton" onclick="deleteImgTr(this)">删&nbsp;&nbsp;除</button>
                                    </div>
                                    <div class="uploadButton">
                                        <label for="img1">添&nbsp;&nbsp;加</label>
                                        <input type="file" form="newArticle" id="img1" name="img1" onchange="refreshImgTr(this)">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="edit-container-title">
                    <span>标题</span>：<input type="text" form="newArticle" name="title" placeholder="请输入标题" value="<%=title%>">
                </div>
                <div class="edit-container-author">
                    <span>作者</span>：<input type="text" form="newArticle" name="author" placeholder="请输入作者名" value="<%=author%>">
                </div>
                <div class="edit-container-tags">
                    <span>标签</span>：<input type="text" form="newArticle" name="tags" placeholder="请输入标签，标签之间用英文分号(;)隔开" value="<%=tags%>">
                </div>
                <div class="edit-container-article">
                    <p><span>正文</span>：</p>
                    <textarea form="newArticle" name="article" placeholder="请在此处使用MarkDown语法输入正文内容。（插入图片时先上传图片，然后使用上述列表展示的图片路径）"><%=content%></textarea>
                </div>

                <div class="edit-container-submit">
                	<input name="ATime" value="<%=ATime%>" type="hidden" form="newArticle">
                    <input type="button" class="manageButton" onclick="openWebpage('home.jsp')" value="取消"/>
                    <input type="submit" form="newArticle" class="manageButton" name="<%=mode%>" value="发布"/>
                </div>
                <div><%=msg%></div>
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
            function refreshImgTr(obj) {
                // 获取文件名并显示，切换按钮显示
                var filePath = obj.value;
                var fileName = null;
                if (filePath.indexOf("/")!=-1)
                {
                    var arr = filePath.split('/');
                    fileName = arr[arr.length-1];
                }
                else if (filePath.indexOf("\\"!=-1))
                {
                    var arr = filePath.split("\\");
                    fileName = arr[arr.length-1];
                }
                else
                    fileName = filePath;
                var tr_obj = obj.parentNode.parentNode.parentNode;
                // 显示名字
                tr_obj.children[0].innerHTML = "&lt;!--Folder--&gt;/"+fileName;
                // 切换显示
                tr_obj.children[1].children[0].style.display = "block";
                tr_obj.children[1].children[1].style.display = "none";
                // 创建新行
                var new_tr = document.createElement("tr");
                new_tr.setAttribute("class","new-img-tr");
                new_tr.appendChild(document.createElement("td"));
                new_tr.appendChild(document.createElement("td"));
                new_tr.children[1].appendChild(document.createElement("div"));
                new_tr.children[1].children[0].setAttribute("class","hidden");

                new_tr.children[1].children[0].appendChild(document.createElement("button"));
                new_tr.children[1].children[0].children[0].setAttribute("class","deleteButton");
                new_tr.children[1].children[0].children[0].innerHTML = "删&nbsp;&nbsp;除";
                new_tr.children[1].children[0].children[0].setAttribute("onclick", "deleteImgTr(this)");
                
                new_tr.children[1].appendChild(document.createElement("div"));
                new_tr.children[1].children[1].setAttribute("class","uploadButton");
                
                new_tr.children[1].children[1].appendChild(document.createElement("label"));
                new_tr.children[1].children[1].children[0].innerHTML = "添&nbsp;&nbsp;加";
                
                new_tr.children[1].children[1].appendChild(document.createElement("input"));
                new_tr.children[1].children[1].children[1].setAttribute("type", "file");
                new_tr.children[1].children[1].children[1].setAttribute("form", "newArticle");
                new_tr.children[1].children[1].children[1].setAttribute("onchange", "refreshImgTr(this)");
                tr_obj.parentNode.appendChild(new_tr);
                updateImgTable();
            }
            function updateImgTable() {
                // 更新文件列表的id和name
                var trLists = document.getElementsByClassName("new-img-tr");
                for (var i=0; i<trLists.length; i++)
                {
                    var str = "img"+i;
                    var uploadButton = trLists[i].children[1].children[1];
                    uploadButton.children[0].setAttribute("for", str);
                    uploadButton.children[1].setAttribute("id", str);
                    uploadButton.children[1].setAttribute("name", str);
                }
            }
            function deleteImgTr(obj) {
                var tr_obj = obj.parentNode.parentNode.parentNode;
                var table_obj = tr_obj.parentNode;
                table_obj.removeChild(tr_obj);
                updateImgTable();
            }
            function checkSubmit(obj)
            {
                var r=confirm("是否确认发布文章？");
                if (r)
                    return true;
                else
                    return false;
            }
        </script>
    </body>
</html>