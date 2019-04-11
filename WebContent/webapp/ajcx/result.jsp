<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="tdh.spring.*" %>
<%@ page import="tdh.util.*" %>
<%@ page import="java.text.SimpleDateFormat,tdh.framework.util.StringUtils" %>
<%!
	Map<String,String> getFromHdbcEaj(Connection hdbcConn,String type,String key){
		Statement st = null;
		ResultSet rs = null;
		Map<String,String> rowdata =  null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd HH:mm:ss");
		try{
			String sql = "";
			if("1".equals(type)){
				sql = "select AH,AHDM,LASTUPDATE,FYDM FROM EAJ where AHDM='"+key+"'";
			}else {
				sql = "select AH,AHDM,LASTUPDATE,FYDM FROM EAJ where AH='"+key+"'";
			}
			st = hdbcConn.createStatement();
			rs = st.executeQuery(sql);
			if(rs.next()){
				rowdata = new HashMap<String,String>();
				rowdata.put("AH",rs.getString("AH"));
				rowdata.put("AHDM",rs.getString("AHDM"));
				rowdata.put("FYDM",rs.getString("FYDM"));
				rowdata.put("MODIFYTIME",sdf.format(rs.getTimestamp("LASTUPDATE")));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return rowdata;
	}
	
	String getFromDcDelLog(Connection hdbcConn,String ajbs){
		Statement st = null;
		ResultSet rs = null;
		String deltime = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd HH:mm:ss");
		try{
			String sql = "select DT FROM TS_DEL where TAB='EAJ' AND  PKVAL='"+ajbs+"'";
			st = hdbcConn.createStatement();
			rs = st.executeQuery(sql);
			if(rs.next()){
				deltime = sdf.format(rs.getTimestamp("DT"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return deltime;
	}
	
	String convertZt(String zt){
		if("1".equals(zt)) return "达到";
		if("2".equals(zt)) return "解析";
		if("3".equals(zt)) return "入库";
		if("4".equals(zt)) return "失败";
		return "未入库";
	}
 %>
<%
	Connection hdbcConn = null;
	Connection xdbConn = null;
	String type = request.getParameter("type");
	String key  = request.getParameter("key");
	Statement st = null;
	ResultSet rs = null;
	String ajbs = key;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd HH:mm:ss");
	try{
		hdbcConn = SpringBeanUtils.getConnection(request,"HbdcdataSource");
		xdbConn = SpringBeanUtils.getConnection(request,"HbsjjzdataSource");
		Map<String,String> eajData = getFromHdbcEaj(hdbcConn,type,key);
		String ah = "";
%>
数据中心库
<hr>
根据标识查询：
<br>
<table style="font-size:14px;text-align:center;" border="1">
	<tr height="25"><td>案号</td><td>最近更新时间</td><td>交换文件（XML)</td></tr>

<%     if(eajData == null){
			out.print("<tr><td colspan=\"3\">案件信息不存在</td></tr>");
			if("2".equals(type)) ajbs = "";
		}else{
			if(eajData.get("FYDM").startsWith("1304") || eajData.get("FYDM").startsWith("1306"))
			{
				out.print("<tr height=\"25\"><td>"+eajData.get("AH")+"</td><td>"+eajData.get("MODIFYTIME")+"</td><td >&nbsp;</td></tr>");
			}else{
				out.print("<tr height=\"25\"><td>"+eajData.get("AH")+"</td><td>"+eajData.get("MODIFYTIME")+"</td><td ><a href=\"#\" onclick=\"showXML('"+eajData.get("AHDM")+"');\">查看</a></td></tr>");
			}
			if("2".equals(type)){
				ajbs = eajData.get("AHDM");
			}
			
			ah = eajData.get("AH");
		}
%>
</table>
<hr>
根据案号查询：
<table style="font-size:14px;text-align:center;" border="1">
<%
if(!"".equals(ah)){
	st = hdbcConn.createStatement();
	rs = st.executeQuery("select AHDM,AH,LARQ,JARQ,AJZT FROM EAJ where AH ='"+ah+"' ");
	out.print("<tr height=\"25\"><td>标识</td>"
			+"<td>案号</td>"
			+"<td>立案日期</td>"
			+"<td>结案日期</td>"
			+"<td>案件状态</td>"
			+"</tr>");
	while(rs.next()){
		out.print("<tr height=\"25\"><td>"+rs.getString("AHDM")+"</td>"
						+"<td>"+StringUtils.trim(rs.getString("AH"))+"</td>"
						+"<td>"+StringUtils.trim(rs.getString("LARQ"))+"</td>"
						+"<td>"+StringUtils.trim(rs.getString("JARQ"))+"</td>"
						+"<td>"+StringUtils.trim(rs.getString("AJZT"))+"</td>"
				+"</tr>");
	}
	
}

%>

</table>


<%if(!"".equals(ajbs) ){ 
	String deltime = getFromDcDelLog(hdbcConn,ajbs);
	if(!"".equals(deltime)){
		out.print("<span style=\"color:red;\">本案件已经在"+deltime+"被删除</span>");
	}
}
%>
<%
String xmlname = "";	
if(!"".equals(ajbs)) {%>
<br>
文件系统
<hr>
<table style="font-size:14px;text-align:center;" border="1">
	<tr height="25"><td>日期</td><td>所在压缩包</td><td>文件名称</td><td>解压时间</td><td>校验状态</td></tr>
<%
		//查询文件系统
	
		st = xdbConn.createStatement();
		rs = st.executeQuery("select XMLNAME,CJRQ,ZIPNAME,FILENAME,ERRCODE,LASTUPDATE FROM TR_FILES where XMLTYPE='ASS' AND AJBS='"+ajbs+"' AND ERRCODE=0 "
		//+" union select XMLNAME,CJRQ,ZIPNAME,FILENAME,ERRCODE,LASTUPDATE FROM TR_FILES where XMLTYPE='ASS' and ERRCODE>0 AND  FILENAME like '%"+ajbs+"%'  ORDER BY CJRQ ASC"
		);
		while(rs.next()){
			  String name = rs.getString("XMLNAME");
			  if("".equals(xmlname) && name!=null){
			  	 xmlname = name;
			  }
			%>
			<tr height="25">
				<td><%=rs.getString("CJRQ") %></td>
				<td><%=rs.getString("ZIPNAME") %></td>
				<td><%=rs.getString("FILENAME") %></td>
				<td><%=sdf.format(rs.getTimestamp("LASTUPDATE")) %></td>
				<td><%=rs.getString("ERRCODE") %></td>
			</tr>
			<%
		}
	}
%>
</table>

<br>
交换库
<hr>
<table style="font-size:14px;text-align:center;" border="1">
	<tr height="25"><td>交换文件名称</td><td>状态</td><td>达到时间</td><td>入库时间</td><td>XML</td></tr>
<%
    if(!"".equals(xmlname)){
	rs = st.executeQuery("select XMLNAME,ZT,DDSJ,RKSJ,JYZT,SBYY from TR_DD where XMLNAME='"+xmlname+"' ");
	if(rs.next()){
%>
	<tr>
		<td>
		<%if(rs.getString("XMLNAME").indexOf("ASS")>-1){ %>
		<%=rs.getString("XMLNAME").substring(10) %>
		<%}else{%>
		<%=rs.getString("XMLNAME")%>
		<% } %>
		</td>
		<td><%=convertZt(rs.getString("ZT")) %></td>
		<td><%=sdf.format(rs.getTimestamp("DDSJ")) %></td>
		<td>
		<%if(rs.getTimestamp("RKSJ")!=null){ %>
		<%=sdf.format(rs.getTimestamp("RKSJ")) %>
		<%}else{out.print("&nbsp");} %>
		</td>
		<td>
			<a href="#" onclick="showXML2('<%=rs.getString("XMLNAME") %>');">查看</a>
		</td>
		
	</tr>
	
	<%
		String jyzt = rs.getString("JYZT");
		if("1".equals(jyzt)){
		%>
		<tr>
			<td colspan="5" style="background-color:#fff68f"><%=rs.getString("SBYY") %></td>
		</tr>
		<%} %>
<%}} %>
</table>
<%
}catch(Exception e){
	e.printStackTrace();
}finally{
	DBUtil.closeConn(hdbcConn);
	DBUtil.closeConn(xdbConn);
}
%>
