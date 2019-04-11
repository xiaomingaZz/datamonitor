<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*"%>
<%@page import="tdh.*"%>
<%@page import="tdh.util.*"%>
<%@page import="tdh.tr.*"%>
<%
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String id = StringUtils.trim(request.getParameter("id"));
	if ("".equals(id) || "-1".equals(id)) {
		id = Constant.fjm.substring(0, 1);
	}
	String flag = StringUtils.trim(request.getParameter("flag"));
	String dm = StringUtils.trim(request.getParameter("dm"));

	int start = Integer.parseInt(StringUtils.trim(request
			.getParameter("start")));
	int limit = Integer.parseInt(StringUtils.trim(request
			.getParameter("limit")));
	int top = start + limit;

	JSONArray ja = new JSONArray();
	int num = 0;
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String sql = "select top " + top
			+ " AJBS,AH,JBFY FROM DC_WS_DAILY_" + flag + "  WHERE RQ='"
			+ cxsj1 + "' and JBFY ='" + dm + "'";
	//System.out.println(sql);
	try {
		conn = WebAppContext.getNewConn("HbdcdataSource");
		st = conn.createStatement();
		rs = st.executeQuery("select count(*) from DC_WS_DAILY_" + flag
				+ "  WHERE RQ='" + cxsj1 + "' and JBFY ='" + dm + "'");
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
				jo.put("AJBS", rs.getString("AJBS"));
				jo.put("AH", rs.getString("AH"));
				String fjm = Constant.fyDMtoFjmMap.get(rs
						.getString("JBFY"));
				jo.put("FY", fjm);
				jo.put("FYMC", Constant.fjmMap.get(fjm));
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