  <%@ page language="java" pageEncoding="utf-8"%>
  <%@page import="tdh.frame.web.util.WebUtils"%>
  <%@page import="tdh.frame.web.context.WebAppContext"%>
  <script type="text/javascript">
  	  imgpath = "<%=WebUtils.getContextPath(request)%>";
  </script>
  <input type="hidden" name="start" id="start" value="0">
  <input type="hidden" name="limit" id="limit" value="<%=WebAppContext.getDefaultPageSize() %>">
  <span id="load" style="font-size:12px;" style="visibility:hidden;"><img src="<%=WebUtils.getContextPath(request)%>/frame/images/load.gif" align="absmiddle" >正在加载数据...</span>
  <img name="sy" id="sy" src="<%=WebUtils.getContextPath(request)%>/frame/images/left1a.gif" onClick="sy_onclick()"  style="cursor:hand;" title="首页">
  <img name="left" id="left" src="<%=WebUtils.getContextPath(request)%>/frame/images/left2a.gif" onClick="left_onclick()"  style="cursor:hand;" title="上一页">
  <span class="style_12">第</span><input type="text" name="curPage" id="curPage" readonly size="3" value="1" class="style_12_input" style="width:30px;"><span class="style_12">页 </span>
  <span class="style_12">共</span><input type="text" name="PageCount" id="PageCount" readonly size="3" value="1" class="style_12_input" style="width:30px;"><span class="style_12">页</span>
  <img name="right" id="right" src="<%=WebUtils.getContextPath(request)%>/frame/images/right1a.gif" onClick="right_onclick()"  style="cursor:hand;" title="下一页">
  <img name="wy" id="wy" src="<%=WebUtils.getContextPath(request)%>/frame/images/right2a.gif" onClick="wy_onclick()"  style="cursor:hand;" title="尾页">
  <span class="style_12">共</span><input title='显示全部数据' type="text" name="totalnum" id="totalnum" readonly size="4" class="style_12_input" style="cursor:hand;color:blue;width:40px;" onclick="showAllList(this);"><span class="style_12">个</span>
