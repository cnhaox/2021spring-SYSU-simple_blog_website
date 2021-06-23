<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*, java.util.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%request.setCharacterEncoding("utf-8");%>
<% String path = application.getRealPath("info");
File file = new File(path,"files.txt");
if (!file.getParentFile().exists())
    file.getParentFile().mkdir();
if (!file.exists())
    file.createNewFile();
ArrayList<String> files = new ArrayList<>();

// 读取目录
FileInputStream ch = new FileInputStream(file);
InputStreamReader fr = new InputStreamReader(ch,"UTF-8");
BufferedReader br = new BufferedReader(fr);  //使文件可按行读取并具有缓冲功能
String str = br.readLine();
while(str!=null){
	files.add(str);   //将读取的内容放入files
	str = br.readLine();
}
br.close();

// 上传文件
boolean isMultipart = ServletFileUpload.isMultipartContent(request);//是否用multipart提交的
String dir = application.getRealPath("files") + System.getProperty("file.separator");
File tmp = new File(dir);
if (!tmp.exists())
	tmp.mkdir();
if (isMultipart) {
    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);
    List items = upload.parseRequest(request);
    for (int i = 0; i < items.size(); i++) {
        FileItem fi = (FileItem) items.get(i);
        if (!fi.isFormField()) {//如果是文件
            DiskFileItem dfi = (DiskFileItem) fi;
            if (!dfi.getName().trim().equals("")) {//getName()返回文件名称或空串
                String name = FilenameUtils.getName(dfi.getName());
                dfi.write(new File(dir + name));
                if(!files.contains(name))
                	files.add(name);
            }
        }
    }
}

// 删除文件
String delButton=request.getParameter("delete"); //判断是否按了删除按钮
String fname=request.getParameter("fileID");
if(delButton!=null){
	files.remove(fname);
	File del = new File(dir + fname);
	del.delete();
}

// 查找名字包含指定关键词的文件
ArrayList<String> copy = new ArrayList<>();
String search=request.getParameter("search");
String key=request.getParameter("condition");
if(search!=null){
	for (int i = 0; i < files.size(); i++)
		if(files.get(i).contains(key))
			copy.add(files.get(i));
}
else
	copy = (ArrayList<String>)files.clone();

// 更新目录
FileOutputStream outstr = new FileOutputStream(file);
BufferedWriter fw = new BufferedWriter(new OutputStreamWriter(outstr, "UTF-8"));
for (int i = 0; i < files.size(); i++)
	fw.write(files.get(i)+"\n");
fw.close();

%>
<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>个人博客</title>
        <link rel="stylesheet" type="text/css" href="css/general.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.css" />
        <style>
            .menuChecked {
                top: 120px;
            }
            .menuChecked .menu {
                top: -120px;
            }
            .fileListDiv {
                position: relative;
                margin: 100px 50px;
            }
            .fileList {
                position: relative;
                padding: 0px 10px;
                margin: 30px 0px;
            }
            table { margin-bottom: 60px; }
        </style>
    </head>
    <body>
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
            <div class="fileListDiv">
                <div class="search">
                    <form action="files.jsp" method="post">
                        <i class="fa fa-search" aria-hidden="true"></i>
                        <input type="text" name="condition" placeholder="Searching...">
                        <input type="submit" name="search" value="搜索">
                    </form> 
                </div>
                <div style="clear:both"></div>
                <h1>文件</h1>
                <div class="fileList">
                	<table class="tableStyle">
                        <tr>
                            <th>文件名</th>
                            <th>操作</th>
                        </tr>
                        <% for (int i = 0; i < copy.size(); i++) { %>
                		<tr>
                            <td><%= copy.get(i) %></td>
                            <td>
                                <button type="button" class="downloadButton" onclick="changeButton(this, 'files/<%= copy.get(i) %>')">
                                    <span>下&nbsp;&nbsp;载</span>
                                    <i class="fa fa-check" aria-hidden="true"></i>
                                </button>
                                <form action="files.jsp" method="post" onsubmit="return checkDelete(this)">
                                    <input type="hidden" name="fileID" value="<%= copy.get(i) %>">
                                    <input type="submit" class="deleteButton" name="delete" value="删&nbsp;&nbsp;除">
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                	<div class="upload">
                        <form name="divfileupload" id="fileUpload" action="files.jsp" method="post" enctype="multipart/form-data">
                        </form>
                        <span class="fileTip">上传文件：</span>
                        <div class="uploadButton uploadButton-large button-violet">
                            <label for="fileinput"><i class="fa fa-cloud-upload fa-2x" aria-hidden="true"></i></label>
                            <input type="file" form="fileUpload" id="fileinput" name="file" onchange="refreshFileName(this)">
                        </div>
                        <span class="fileName"></span>
                        <input type="submit" name="submit" form="fileUpload" value="上  传" class="upload-submit-button">
                    </div>
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
            
            function changeButton(obj, link) {
                clearInterval(obj.timer);
                var style = document.defaultView.getComputedStyle(obj);
                var width = parseInt(style.width);
                var height = parseInt(style.height);
                var marginLeft = parseInt(style.marginLeft);
                var marginRight = parseInt(style.marginRight);
                var borderRadius = parseInt(style.borderRadius);
                obj.timer = setInterval(function(){
                    if (width>height&&borderRadius<50)
                    {
                        width -= 4;
                        marginLeft += 2;
                        marginRight += 2;
                        borderRadius += 5;
                        obj.style.width = width+'px';
                        obj.style.marginLeft = marginLeft +'px';
                        obj.style.marginRight = marginRight +'px';
                        obj.style.borderRadius = borderRadius + '%';
                    }
                    else
                    {
                        obj.children[0].style.display = "none";
                        obj.children[1].style.display = "block";
                        clearInterval(obj.timer);
                        window.open(link);
                    }
                }, 10);
            }
            function refreshFileName(obj) {
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
                obj.parentNode.nextElementSibling.innerHTML = fileName;
            }
            function openWebpage(path) {
                window.location.href = path;
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