<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="tdh.frame.web.context.*" %>
<%@ page import="tdh.frame.common.*,tdh.frame.system.TApp" %>
<%
	String cpid = request.getParameter("cpid");
	if(cpid == null) cpid = "";
	String sql = "select CPID,CPMC,BBH,FBRQ,FBSM, APPJC  FROM TS_VERSION,T_APP where T_APP.APPID = TS_VERSION.CPID  ";
	String sql2 = "select APPJC,APPID FROM T_APP where";
  	List<TApp> list = WebAppContext.getWebConfig().getApplist();
	StringBuilder cond = new StringBuilder();
	for(TApp app : list){
		if(cond.length()>0) cond.append(",");
		cond.append("'");
		cond.append(app.getAppid());
		cond.append("'");
	}
	if(!"".equals(cpid)){
		sql += " AND  CPID='"+cpid+"' ";
		sql +=" order by BBH desc";
	} else{   
		sql +=" AND CPID IN ("+cond.toString()+" ) order by T_APP.PXH,CPID,BBH desc";
	}
	sql2 += " APPID IN ("+cond.toString()+") order by PXH ";

	Connection conn = null;
	Statement st  = null;
	ResultSet rs = null;
	StringBuilder cpidsb = new StringBuilder();
	List<Map<String,String>> applist = new ArrayList<Map<String,String>>();
	Map<String,List<Map<String,String>>> listmap = new HashMap<String,List<Map<String,String>>>();
	try{
		conn = WebAppContext.getFrameConn();
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		while(rs.next()){
			String id = rs.getString("CPID");
			String cpmc =  rs.getString("CPMC");
			String bbh =  rs.getString("BBH");
			String fbrq =  rs.getString("FBRQ");
			String fbsm =  rs.getString("FBSM");
			String jc = rs.getString("APPJC");
			if(!UtilComm.isEmpty(jc)){
				cpmc =  jc;
			}			
			if(cpidsb.indexOf(id) == -1){
				cpidsb.append(id).append("|").append(cpmc).append(",");
			}
			Map<String,String>  row = new HashMap<String,String>();
			row.put("BBH",bbh);
			row.put("FBRQ",UtilComm.trim(fbrq));
			row.put("FBSM",UtilComm.trim(fbsm));
			row.put("JC",UtilComm.trim(jc));
			
			List<Map<String,String>> lst = listmap.get(id);
			if(lst == null)
			    lst = new ArrayList<Map<String,String>>();
			lst.add(row);
			listmap.put(id,lst);
		}
		rs.close();
		rs = st.executeQuery(sql2);
		while(rs.next()){
			Map<String,String> row = new HashMap<String,String>();
			row.put("APPID",rs.getString("APPID"));
			row.put("JC",rs.getString("APPJC"));
			applist.add(row);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,st,rs);
	}
%>
<html>
<head>
	<title>软件版本发行说明</title>
</head>
<body>
<table style="font-size:14px;" >
<tr>
<td>导航：<%if(WebAppContext.isFrame()){ %><a href="version_list.jsp" style="color:blue;">全部</a>&nbsp;&nbsp;|<%} %></td>
<%

	String[] cparr = cpidsb.toString().split("\\,");
	
	for(Map<String,String> row : applist){	
	if("COMM".equals(row.get("APPID"))) continue;
%>	
	<td><a style="color:blue;" href="version_list.jsp?cpid=<%=row.get("APPID")%>"><%=row.get("JC")%></a>&nbsp;&nbsp;|</td>
<% 
	}
%>
</tr>
</table>
<table width="100%" cellspacing="1" cellpadding="2" border="0" style="font-size:12px;" bgcolor="#c0c0c0">
<tr  bgcolor="#00ffff">
	<td height="30" width="60">&nbsp;</td><td width="150" align="center"><b>发布日期</b></td><td width="150" align="center"><b>版本号</b></td><td align="center"><b>简要说明</b></td>
</tr>
<%

  for(String cp : cparr){ 
	if(UtilComm.isEmpty(cp)) continue;
	String[] data2 = cp.split("\\|");
	List<Map<String,String>>  lst2 = listmap.get(data2[0]);

%>
	<tr bgcolor="#ffff00">
		<td colspan="4" height="30">产品：<%=data2[1] %></td>
	</tr>
	<%
	  int i = 0;
	  for(Map<String,String> row : lst2){
	  i++;
	  String bg = "#ffffff";
	  if(i %2  == 0){
	  	bg  = "#FAFAFA";
	  }
	  %>
	  <tr bgcolor="<%=bg %>">
	  	<td>&nbsp;</td><td align="center"><%=row.get("FBRQ") %></td><td align="center"><%=data2[0]+" " +row.get("BBH") %></td>
	  	<td>
	  	<div>
	  	<%=row.get("FBSM")%>
	  	</div>
	  	</td>
	  </tr>
	  <%
	  }
	 %>
<%} %> 
</table>
</body>
</html>
