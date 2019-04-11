<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Flash Player 测试页面</title>
  </head>
  <body style="text-align:center;">
  <br>
  <div style="text-align:center;color:red;">如果你能看到页面的Flash 动画（滚动的齿轮)</div>
  <div>
     <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="500" height="400" id="FlashID" title="">
    <param name="movie" value="flash.swf" />
    <param name="quality" value="high" />
    <param name="wmode" value="transparent" />
    <param name="swfversion" value="6.0.65.0" />
    <!-- 此 param 标签提示使用 Flash Player 6.0 r65 和更高版本的用户下载最新版本的 Flash Player。如果您不想让用户看到该提示，请将其删除。 -->
    <!-- 下一个对象标签用于非 IE 浏览器。所以使用 IECC 将其从 IE 隐藏。 -->
    <!--[if !IE]>-->
    <object type="application/x-shockwave-flash" data="flash.swf" width="500" height="400">
      <!--<![endif]-->
      <param name="quality" value="high" />
      <param name="wmode" value="opaque" />
      <param name="swfversion" value="6.0.65.0" />
      <!-- 浏览器将以下替代内容显示给使用 Flash Player 6.0 和更低版本的用户。 --> 
      <!--[if !IE]>-->
    </object>
   </object> 
    
  </body>
</html>
