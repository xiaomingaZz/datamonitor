<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*"%>
<%@page import="tdh.*"%>
<%@page import="tdh.util.*"%>
<%@page import="tdh.tr.*"%>
<%
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-", "");
	String id = StringUtils.trim(request.getParameter("id"));
	if ("".equals(id) || "-1".equals(id)) {
		id = Constant.fjm.substring(0, 1);
	}
	int start = Integer.parseInt(StringUtils.trim(request
			.getParameter("start")));
	int limit = Integer.parseInt(StringUtils.trim(request
			.getParameter("limit")));
	int top = start + limit;

	JSONArray ja = new JSONArray();
	int num = 0;
	Connection conn = null;
	Statement st = null;
	Statement st2 = null;
	ResultSet rs = null;
	String sql = "select top "
			+ top
			+ " FY,AJBS,AH,LARQ,JARQ FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
			+ cxsj1
			+ "' "
			+ " AND JARQ<='"
			+ cxsj2
			+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') AND SFCZWS='0'"
			+ " AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY like '" + id + "%' ";
	String sql2 = "select count(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
			+ cxsj1
			+ "' "
			+ " AND JARQ<='"
			+ cxsj2
			+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
			+ " AND SFCZWS='0' AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY like '" + id + "%' ";
	//System.out.println(sql);

	try {
		conn = WebAppContext.getNewConn("HbsjjzdataSource");
		st2 = conn.createStatement();
		rs = st2.executeQuery(sql2);
		if (rs.next()) {
			num = rs.getInt(1);
		}
		if (num > 0 && num > start) {
			st = conn.createStatement(
					ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rs = st.executeQuery(sql);
			if (start > 0)
				rs.absolute(start);
			int i = 0;
			while (rs.next()) {
				i++;
				if (i > limit)
					break;
				JSONObject jo = new JSONObject();
				jo.put("FYMC", Constant.fjmMap.get(rs.getString("FY")));
				jo.put("FY", rs.getString("FY"));
				jo.put("AJBS", rs.getString("AJBS"));
				jo.put("AH", rs.getString("AH"));
				jo.put("LARQ", rs.getString("LARQ"));
				jo.put("JARQ", rs.getString("JARQ"));
				ja.add(jo);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.close(conn, st, rs);
	}
	JSONObject json = new JSONObject();
	json.put("root", ja.toString());
	json.put("totalCount", num);
	out.print(json);
%>