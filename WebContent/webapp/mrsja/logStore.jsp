<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*"%>
<%@page import="tdh.*"%>
<%
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String id = StringUtils.trim(request.getParameter("id"));
	if ("".equals(id) || "-1".equals(id)) {
		id = Constant.fjm.substring(0, 1);
	}
	JSONArray ja = new JSONArray();
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;

	Connection conn2 = null;
	Statement st2 = null;
	ResultSet rs2 = null;

	String sql = "select FYMC,DM,FJM  FROM TS_FYMC WHERE FJM LIKE '"
			+ id + "%' order by FYDM ";
	Map<String, String> map1 = new HashMap<String, String>();
	Map<String, String> map2 = new HashMap<String, String>();
	StringBuffer sb = new StringBuffer();
	List<String> fylist = new ArrayList<String>();
	try {
		conn = WebAppContext.getNewConn("HbsjjzdataSource");
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		while (rs.next()) {
			String fjm = StringUtils.trim(rs.getString("FJM"));
			fylist.add(fjm);
			if (sb.length() > 0)
				sb.append(",");
			sb.append("'").append(rs.getString("DM")).append("'");

			map1.put(fjm, StringUtils.trim(rs.getString("FYMC")));
			map2.put(fjm, StringUtils.trim(rs.getString("DM")));
		}
		Map<String, Integer> mapdata1 = new HashMap<String, Integer>();
		Map<String, Integer> mapdata2 = new HashMap<String, Integer>();

		conn2 = WebAppContext.getNewConn("HbdcdataSource");
		st2 = conn2.createStatement();

		sql = "select JBFY,count(*) from DC_WS_DAILY_SA where RQ='"
				+ cxsj1 + "' and " + " JBFY in (" + sb.toString()
				+ ") group by JBFY";

		rs2 = st2.executeQuery(sql);
		while (rs2.next()) {
			String fjm = Constant.fyDMtoFjmMap.get(rs2
					.getString("JBFY"));
			mapdata1.put(fjm, rs2.getInt(2));
		}

		sql = "select JBFY,count(*) from DC_WS_DAILY_JA where RQ='"
				+ cxsj1 + "' and " + " JBFY in (" + sb.toString()
				+ ") group by JBFY";

		rs2 = st2.executeQuery(sql);
		while (rs2.next()) {
			String fjm = Constant.fyDMtoFjmMap.get(rs2
					.getString("JBFY"));
			mapdata2.put(fjm, rs2.getInt(2));
		}

		int t1 = 0, t2 = 0;
		for (String dm : fylist) {
			String fymc = map1.get(dm);
			JSONObject jo = new JSONObject();

			Integer v1 = mapdata1.get(dm);
			if (v1 == null)
				v1 = 0;
			Integer v2 = mapdata2.get(dm);
			if (v2 == null)
				v2 = 0;

			t1 += v1;
			t2 += v2;

			jo.put("FYMC", fymc);
			jo.put("SAS", v1);
			jo.put("JAS", v2);
			jo.put("DM", map2.get(dm));
			ja.add(jo);
		}
		JSONObject jo = new JSONObject();
		jo.put("FYMC", "合计");
		jo.put("SAS", t1);
		jo.put("JAS", t2);
		ja.add(jo);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.close(conn, st, rs);
		DBUtils.close(conn2, st2, rs2);
	}
	JSONObject json = new JSONObject();
	json.put("root", ja.toString());//记录数据项
	json.put("totalCount", fylist.size());//总记录数
	out.print(json);
%>
