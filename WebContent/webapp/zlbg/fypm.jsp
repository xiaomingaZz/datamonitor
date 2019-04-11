<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.web.context.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.*"%>
<%
String CONTEXT_PATH = WebUtils.getContextPath(request);
//String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
//cxsj1 = cxsj1.replace("-","");
//String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
//cxsj2 = cxsj2.replace("-","");
String id=StringUtils.trim(request.getParameter("id"));
if("".equals(id) || "-1".equals(id)){
	id=Constant.fjm.substring(0,1);
}
Connection conn= null;
Statement st = null;
ResultSet rs = null;
Map<String,Integer>totalMap = new HashMap<String,Integer>();
Map<String,Integer>jysbMap = new HashMap<String,Integer>();
Map<String,String>fyMap = new HashMap<String,String>();
List<String> list = new ArrayList<String>();
List<String> pmlist = new ArrayList<String>();
String xmlValue="";
try{
	StringBuilder query  = new StringBuilder();
	query.append("select FY,count(*) ");
	query.append(" from TR_DD where  XMLTYPE='ASS' AND ISNULL(DEL,'')<>'1' AND ((ZT='4'AND JYZT='1') or ZT='3')");
	query.append(" AND FY like '"+id+"%' group by FY");
	conn=WebAppContext.getNewConn("HbsjjzdataSource");
	st=conn.createStatement();
	rs=st.executeQuery(query.toString());
	while(rs.next()){
		totalMap.put(rs.getString(1),rs.getInt(2));
	}
	StringBuilder query2  = new StringBuilder();
	query2.append("select FY,count(*) ");
	query2.append(" from TR_DD where  XMLTYPE='ASS' AND ISNULL(DEL,'')<>'1'  AND ZT='4'AND JYZT='1'");
	query2.append(" AND FY like '"+id+"%' group by FY");
	rs=st.executeQuery(query2.toString());
	while(rs.next()){
		jysbMap.put(rs.getString(1),rs.getInt(2));
	}
	String sql = "select FJM,FYDC  FROM TS_FYMC WHERE FJM LIKE '"
	+ id + "%' order by FJM ";
	rs=st.executeQuery(sql);
	while(rs.next()){
		fyMap.put(rs.getString(1),rs.getString(2));
	}
	
	for(String fy :totalMap.keySet()){
		double prec = 0;
		int jysb=jysbMap.get(fy)==null?0:jysbMap.get(fy);
		int total=totalMap.get(fy);
		if(jysb >0){
	     prec = ((double)(total - jysb) / total )* 100;
		}
		else{
	    prec = 100;
		}
		String per=StringUtils.formatDouble(prec,"#0.00");
		list.add(fy+"_"+per);
	}
	for (int i = 0; i < list.size(); i++) {
			for(int j=i+1;j<list.size();j++){
				double k1=Double.parseDouble(list.get(i).substring(4));
				double k2=Double.parseDouble(list.get(j).substring(4));
				if(k1<k2){
					String temp = list.get(i);
					list.set(i, list.get(j));
					list.set(j, temp);
				}
		     }
	    }
	pmlist.add(0, list.get(0)+";1");
	for(int i=1;i<list.size();i++){
		String value1 =list.get(i-1);
		String value2 =list.get(i);
		String perBef=value1.substring(4);
		String per=value2.substring(4);
	    String pm =pmlist.get(i-1).substring(pmlist.get(i-1).lastIndexOf(";")+1);
	    if(perBef.equals(per)){
	    	pmlist.add(list.get(i)+";"+pm);
	    }else{
	    	pmlist.add(list.get(i)+";"+(Integer.parseInt(pm)+1));
	    }
	}
	
	StringBuilder xml  = new StringBuilder();
	xml.append("<anychart>");
	xml.append("<margin all='0'/>");
	xml.append("<charts>");
	xml.append("<chart plot_type='CategorizedHorizontal'>");
	xml.append("<data_plot_settings default_series_type='Bar'>");
	xml.append("<bar_series>");
	xml.append("<label_settings enabled='true'>");
	xml.append("<position anchor='Center' halign='Center' valign='Center'/>");
	xml.append("<format>{%Value}%  ( {%t}{numDecimals:0} )</format>");
	xml.append("</label_settings>");
	xml.append("</bar_series>");
	xml.append("</data_plot_settings>");
	xml.append("<data>");
	xml.append("<series name='法院合格率'>");
	for(int i=0;i<pmlist.size();i++){
			String fy=pmlist.get(i).substring(0,3);
			String per=pmlist.get(i).substring(4,pmlist.get(i).lastIndexOf(";"));
			String mc=fyMap.get(fy)==null?"":fyMap.get(fy);
			if (mc.indexOf("中院") == -1 && mc.indexOf("高院") == -1
					&& mc.indexOf("海事") == -1 && mc.indexOf("铁路") == -1) {
				mc += "法院";
			}
			xml.append("<point name='"+mc+"' y='"+per+"'>");
			xml.append("<attributes><attribute name='t'>"+(pmlist.get(i).substring(pmlist.get(i).lastIndexOf(";")+1))+"</attribute></attributes>");
			xml.append("</point>");
		}
	xml.append("</series>");
	xml.append("</data> ");
	xml.append("<chart_settings>");
	xml.append("<title><text>法院合格率统计</text></title>");
	xml.append("<chart_background enabled='false'/> ");
	xml.append("<axes>");
	xml.append("<y_axis>");
	xml.append("<title enabled='false'></title>");
	xml.append("<scale maximum='100.00' minimum='0.00'/>");
	xml.append("</y_axis>");
	xml.append("<x_axis> <labels align='Outside' />");
	xml.append("<title enabled='flase'></title>");
	xml.append("<labels display_mode='Normal'/> ");
	xml.append("</x_axis>");
	xml.append("</axes>");
	xml.append("</chart_settings>");
	xml.append("</chart>");
	xml.append("</charts>");
	xml.append("</anychart>");
	xmlValue=xml.toString();
	//System.out.println(xmlValue);
}catch(Exception e){
	e.printStackTrace();
}finally{
	DBUtils.close(conn, st, rs);
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>法院排名</title>
</head>
<body>
	<script type="text/javascript"
		src="<%=CONTEXT_PATH%>/ext/anychart/js/AnyChart.js"></script>
	<script type="text/javascript" language="javascript"> 
    var chart = new AnyChart('<%=CONTEXT_PATH%>/ext/anychart/swf/AnyChart.swf','<%=CONTEXT_PATH%>/ext/anychart/swf/Preloader.swf');
		chart.width = 305;
		chart.height = 4400;
		chart.setXMLData("<%=xmlValue%>");
		chart.write();
	</script>
</body>
</html>