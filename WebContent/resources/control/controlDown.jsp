<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.frame.web.util.*" %>
<%
 String webRoot =  WebUtils.getContextPath(request);
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
    <title>常用控件下载</title>
    <style>
 div.scrollComponent4listBox{position:absolute;top:0;z-index:1;width:100%;height:100%;overflow:auto;}    
.listComponent{table-layout:fixed;}
.listContrl{cursor:default;width:250px;padding:10px 20px 10px 0;}
.listContrl table{position:relative;z-index:1;float:right;table-layout:fixed;}
.listContrl #caption {padding:8px 5px 2px 5px;font-weight:bold;}
.listContrl #split {background:#A7A7A7;height:1px;}
.listContrl #container {padding:4px 5px;}
.listContrl #container ul {display:block;padding:0;margin:0;list-style-type:none;line-height:18px;}
.listContrl #container ul li {padding:0;margin:0;list-style-type:none;color:#000000;}
.listContrl #container ul li a:link{padding-top:2px;height:100%;text-decoration: none;color:#000000;}
.listContrl #container ul li a:visited{padding-top:2px;height:100%;text-decoration: none;color:#000000;}
.listBox{cursor:default;width:100%;padding:10px 20px;}
.listBox table{table-layout:fixed;}
.listBox table tr td #icontainer{white-space:nowrap;}
.listBox table tr td #lcontainer{white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
.listBox #lcontainer{padding:0 5px;}
.listBox #lcontainer table{table-layout:fixed;}
.listBox #lcontainer table tr td{white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
.listBox #caption {padding:8px 5px 2px 5px;font-weight:bold;}
.listBox #caption a:link{text-decoration: none;color:#000000;}
.listBox #caption a:visited{text-decoration: none;color:#000000;}
.listBox #caption a:hover{text-decoration: underline;color:#000000;}
.listBox #caption a:active{text-decoration: underline;color:#000000;}
.listBox #split {background:#A7A7A7;height:1px;}
.listBox #container{padding:4px 5px;}
.listBox #container table{color:#000000;table-layout:fixed;}
.listBox #container table tr td{white-space:nowrap;text-overflow:ellipsis;overflow:hidden;color:#000000;line-height:18px;}
.listBox #container table tr td a:link{text-decoration: none;color:#000000;}
.listBox #container table tr td a:visited{text-decoration: none;color:#000000;}
.listBox #container table tr td a:hover{text-decoration: underline;color:#000000;}
.listBox #container table tr td a:active{text-decoration: underline;color:#000000;}
.captionColor{line-height:18px;color:#000000;}
.infoColor{line-height:20px;color:#000000;}
.textEditColor{color:#000000;}
.textContentColor{line-height:18px;color:#000000;}
.descriptionColor{line-height:20px;color:#000000;}
.errorColor{line-height:20px;color:#FF0000;
   
    </style>
    <script type="text/javascript" src="<%=webRoot%>/ext/jquery/jquery.js"></script>
    <script type="text/javascript">
    </script>
  </head> 
  <body style="overflow:hidden;margin:0px;padding:0px;">
  <div class="scrollComponent4listBox listBg">
  <div class="scrollContainer">
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="listComponent">
      <tr>
        <td width="99%" height="100%" valign="top" class="listBox" id="listBoxContainer"><!--列表内容开始-->
        
            <table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>仿宋_GB2312字体安装包</a></td>
                  </tr>
                  <tr>
                    <td id="split"><br></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,0,0,1</td>
                         <td width="70%" align="right">相关操作：&nbsp;<a href="<%=webRoot%>/ext/font/getFont.jsp?fn=FangSong_GB2312" target="_blank">安装</a>
                          <a href="#" style="color:#cccccc;">测试</a></td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
       
        <table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>浏览器截屏插件</a></td>
                  </tr>
                  <tr>
                    <td id="split"><br></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,0,0,1</td>
                         <td width="70%" align="right">相关操作：&nbsp;<a href="<%=webRoot%>/ext/ueditor/third-party/snapscreen/UEditorSnapscreen.exe"  classid="C9BC4DFF-4248-4a3c-8A49-63A7D317F404">安装</a>
                          <a href="#" style="color:#cccccc;">测试</a></td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:10px;" >
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>IE浏览器运行设置</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,0,20,1</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="<%=webRoot%>/ie.reg" >安装</a>
                          <a href="#" style="color:#cccccc;">测试</a></td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
         <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:10px;" >
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a >Adobe Flash</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：10,0,12,36</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="javascript:void(0);" onclick="install(this)" classid="D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="<%=webRoot%>/ext/flash/install_flash_player_10_active_x.exe">安装</a>
                          <a href="<%=webRoot %>/ext/flash/flash.jsp" target="_blank">测试</a>
                          <a href="#" onclick="showUninstall();">卸载说明</a>
                          </td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
           <table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin:10px;" >
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>Office办公控件</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：5,0,2,1</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="<%=webRoot%>/ext/ntko/NTKOSetupControlClient5021.exe"  classid="C9BC4DFF-4248-4a3c-8A49-63A7D317F404">安装</a>
                          <a href="<%=webRoot %>/ext/ntko/edit.html" target="_blank">测试</a></td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
          <table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin:10px;" >
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>XP系统(补丁KB931125)</a></td>
                  </tr>
                 
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,0,0,0</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="<%=webRoot%>/ext/ntko/rootsupdKB931125.exe"  classid="C9BC4DFF-4248-4a3c-8A49-63A7D317F404">安装</a>
                          <a href="<%=webRoot %>/ext/ntko/edit.html" target="_blank">测试</a></td>
                        </tr>
                      </table></td>
                  </tr>
                 <tr>
                    <td  nowrap style="font-size:13px;padding-left:5px;">(操作系统XP SP3)解决Office控件浏览时出现的加载过程中几秒空白页面，并且显示正在加载文档的问题。</td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
          
           <table width="100%" border="0" cellspacing="0" cellpadding="0"   style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a >Lodop打印控件</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：6,1,5,7</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a id="LodopA" href="<%=WebUtils.getContextPath(request)%>/ext/lodop/install_lodop32.exe"  caption="Lodop打印控件" classid="2105C259-1E0C-4534-8141-A753534CB4CA">安装</a>
                          <a href="<%=webRoot %>/ext/lodop/lodop.jsp" target="_blank">测试</a></td> 
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
           
          
          
           <table width="100%" border="0" cellspacing="0" cellpadding="0"   style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>ScanOnWeb扫描控件</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,0,0,10</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a  href="#" onclick="install(this);" caption="ScanOnWeb扫描控件" classid="15D142CD-E529-4B01-9D62-22C9A6C00E9B" codebase="<%=webRoot%>/ext/scan/ScanOnWeb.cab#version=1,0,0,10">安装</a>
                          <a href="<%=webRoot %>/ext/scan/scanweb.jsp" target="_blank">测试</a></td> 
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
          
           
           <table width="100%" border="0" cellspacing="0" cellpadding="0"   style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>2代身份证读卡器控件</a></td>
                  </tr>
                  <tr>
                    <td id="split"><br></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：2,1,0,0</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="javascript:void(0);" onclick="install(this)" caption="2代身份证读卡器控件" classid="602B8A77-2C86-4652-8D95-6F99E8779F73" codebase="<%=webRoot%>/ext/icread/ICReadProj.cab#version=2,1,0,0">安装</a>
                           <a href="<%=webRoot %>/ext/icread/ICReadProj.jsp" target="_blank">测试</a>
                          </td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
          
          <table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a>TIFF编辑浏览控件</a></td>
                  </tr>
                  <tr>
                    <td id="split"><br></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：1,9,2,1</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a href="javascript:void(0);" onclick="install(this)" caption="TIFF编辑浏览控件" classid="106E49CF-797A-11D2-81A2-00E02C015623" codebase="<%=webRoot%>/ext/alttiff/alttiff.cab#version=1,9,2,1">安装</a>
                          <a href="<%=webRoot %>/ext/alttiff/alttiff.jsp" target="_blank">测试</a>
                          </td>
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
         
          
          <table width="100%" border="0" cellspacing="0" cellpadding="0"   style="margin:10px;">
            <tr>
              <td id="icontainer" width="56" valign="top" nowrap><img src="plugin_48.gif" hspace="4" vspace="4"></td>
              <td width="99%" valign="top" id="lcontainer"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td id="caption" nowrap><a >ScriptX打印控件(不支持IE8及以上浏览器)</a></td>
                  </tr>
                  <tr>
                    <td id="split"></td>
                  </tr>
                  <tr>
                    <td id="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="30%">版本：5,60,0,375</td>
                          <td width="70%" align="right">相关操作：&nbsp;<a  href="#" onclick="install(this);" caption="ScriptX打印控件" classid="1663ed61-23eb-11d2-b92f-008048fdd814" codebase="<%=webRoot%>/ext/ScriptX/ScriptX.cab#Version=5,60,0,375">安装</a>
                          <a href="<%=webRoot %>/ext/ScriptX/print.htm" target="_blank">测试</a></td> 
                        </tr>
                      </table></td>
                  </tr>
                </table></td>
            </tr>
          </table>
     </td>
     </tr>
     <tr>
     <td><iframe style="display:none;width:200;height:300px;" id="installframe" name="installframe"></iframe></td>
     </tr>
     </table></div>
  </body>
  <script type="text/javascript">
  
  if (navigator.userAgent.indexOf('Win64')>=0){
  	$('#LodopA').attr("href","<%=WebUtils.getContextPath(request)%>/ext/lodop/install_lodop64.exe");
  }  	 
    
  var caption =  "";
  $('#installframe').load(function()
  {
  	   	  var A = document.getElementById("installframe");
  	   	  var I=  A.contentWindow.document;
  	   	  if(A.src=="about:blank" || A.src=='') return true
  	   	  if(I.PLUGIN)
  	   	  {	
  	   	  	alert('插件（'+caption+'） 安装成功!');
  	   	  }else{
  	   	  	alert('插件（'+caption+'） 安装失败,请在检查浏览器的选项中检查浏览器的安全设置!');
  	   	  }
   });
  	   
  function install(plugin){
  	var clsid = plugin.getAttribute("classid");
    caption = plugin.getAttribute("caption");
  	if (clsid == "D27CDB6E-AE6D-11cf-96B8-444553540000") {
  	    var i_flash = false;
  	    var version = 0;
  		try{
  			var ie_flash = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.10');
  			i_flash = true;
  			version  = 10;
  			
  		}catch(e)
  		{
  			if (navigator.plugins && navigator.plugins.length > 0){
  				if (navigator.plugins["Shockwave Flash"])
  				{ 
  					var words = navigator.plugins["Shockwave Flash"].description.split(" ");
  					for (var i = 0; i < words.length; ++i)  
			        {  
			            if (isNaN(parseInt(words[i])))  
			              continue;  
			              version = parseInt(words[i]);  
			         }  
			         i_flash = true;
  					//alert(words); 
  				}  
  			}
  		}
  		
  		if(i_flash && version >= 10 )
  		{
  			alert('插件（ Adobe Flash ）已经存在，不需要安装！');
  			return;
  		}
  		//	
  		var codebase = plugin.getAttribute("codebase");
  		$('#installframe').attr('src',codebase);
  	}else{
  	   $('#installframe').attr('src','install.jsp?clsid='+clsid);  
  	}
  }
  function showUninstall(){
  	var msg = "如已安装adobe flash player插件， 但是系统引入功能仍然无法显示，则需要卸载电脑自身flash插件 \n";
  	msg +="1.我的电脑控制面板点击“添加或删除程序”，卸载adobe flash player相应版本 \n";
  	msg +="2.点击开始-》运行-》输入‘regedit’，找到HKEY_LOCAL_MACHINE\\SOFTWARE\Macromedia\\FlashPlayer\\SafeVersions 注册表项，删除里面的内容  \n";
  	msg +="3.点击安装系统提供的Flash插件 \n"; 
  	alert(msg);
  }
  </script>
</html>
