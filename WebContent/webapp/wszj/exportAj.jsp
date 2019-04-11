<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.VelocityUtils"%>
<%@page import="tdh.frame.web.context.*"%>
<%@ page import="tdh.framework.util.StringUtils"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="tdh.*"%>
<%@page import="tdh.util.*"%>
<%@page import="tdh.tr.*"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Pragma", "no-cache");

	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

	String id = StringUtils.trim(request.getParameter("id"));
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-", "");

	if ("".equals(id) || "-1".equals(id)) {
		id = Constant.fjm.substring(0, 1);
	}
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String filename = "exportAj.xls";
	String sql = "select FY,AJBS,AH,LARQ,JARQ FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
				+ cxsj1
				+ "' "
				+ " AND JARQ<='"
				+ cxsj2
				+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
				+ " AND SFCZWS='0' AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY like '"+ id + "%' ";

	try {
		conn = WebAppContext.getNewConn("HbsjjzdataSource");
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		int xh = 0;
		while (rs.next()) {
			xh++;
			Map<String, Object> row = new HashMap<String, Object>();
			row.put("fymc", Constant.fjmMap.get(rs.getString("FY")));
			row.put("fy", rs.getString("FY"));
			row.put("ajbs", StringUtils.trim(rs.getString("AJBS")));
			row.put("ah", StringUtils.trim(rs.getString("AH")));
			row.put("larq", StringUtils.trim(rs.getString("LARQ")));
			row.put("jarq", StringUtils.trim(rs.getString("JARQ")));
			row.put("xh", xh);
			list.add(row);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.close(conn, st, rs);
	}

	response.setContentType("application/vnd.ms-excel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment;filename=\""
			+ filename + "\"");
	VelocityContext context = new VelocityContext();
	context.put("cnts", list.size() + 1);
	context.put("cntItems", list);
	VelocityUtils.write("/wwsajlist.xml", context, request, response);
%>