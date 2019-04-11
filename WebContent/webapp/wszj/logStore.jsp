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
	String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-", "");
	String id = StringUtils.trim(request.getParameter("id"));
	if ("".equals(id) || "-1".equals(id)) {
		id = Constant.fjm.substring(0, 1);
	}
	JSONArray ja = new JSONArray();
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;

	String sql = "select FYMC,FJM  FROM TS_FYMC WHERE FJM LIKE '" + id
			+ "%' order by FJM ";
	Map<String, Integer> jaMap = new HashMap<String, Integer>();
	Map<String, Integer> wsMap = new HashMap<String, Integer>();
	Map<String, Integer> errWsMap = new HashMap<String, Integer>();
	Map<String, Integer> wwsAjMap = new HashMap<String, Integer>();
	List<String> fylist = new ArrayList<String>();
	try {
		conn = WebAppContext.getNewConn("HbsjjzdataSource");
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		while (rs.next()) {
			fylist.add(StringUtils.trim(rs.getString("FJM")));
		}
		sql = "SELECT FY,COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
				+ cxsj1
				+ "' "
				+ " AND JARQ<='"
				+ cxsj2
				+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
				+ " AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '" + id + "%'GROUP BY FY";
		rs = st.executeQuery(sql);
		while (rs.next()) {
			jaMap.put(rs.getString("FY"), rs.getInt(2));
		}
		
		sql = "SELECT FY,COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
				+ cxsj1
				+ "' "
				+ " AND JARQ<='"
				+ cxsj2
				+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
				+ " AND SFCZWS='0' AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '"
				+ id
				+ "%' GROUP BY FY";
		rs = st.executeQuery(sql);
		while (rs.next()) {
			wwsAjMap.put(rs.getString("FY"), rs.getInt(2));
		}

		sql = "SELECT FY,COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
				+ cxsj1
				+ "' "
				+ " AND JARQ<='"
				+ cxsj2
				+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
				+ " AND SFCZWS='1' AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '"
				+ id
				+ "%' GROUP BY FY";
		rs = st.executeQuery(sql);
		while (rs.next()) {
			wsMap.put(rs.getString("FY"), rs.getInt(2));
		}

		sql = "SELECT FY,COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
				+ cxsj1
				+ "' "
				+ " AND JARQ<='"
				+ cxsj2
				+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
				+ " AND SFCZWS='1' AND (FLAGWS02='1' OR FLAGWS03='1' "
				+ " OR FLAGWS04='1' OR FLAGWS05='1' OR FLAGWS06='1')AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '"
				+ id + "%' GROUP BY FY";
		rs = st.executeQuery(sql);
		while (rs.next()) {
			errWsMap.put(rs.getString("FY"), rs.getInt(2));
		}

		int t1 = 0, t2 = 0, t3 = 0,t6=0;
		double t4 = 0, t5 = 0;
		for (String fy : fylist) {
			double precFg = 0, precWs = 0;
			int wss = wsMap.get(fy) == null ? 0 : wsMap.get(fy);
			int total = jaMap.get(fy) == null ? 0 : jaMap.get(fy);
			int bhgWss = errWsMap.get(fy) == null ? 0 : errWsMap
					.get(fy);
			int wwsaj = wwsAjMap.get(fy)== null ? 0 : wwsAjMap
					.get(fy);
			if (wss == 0 || total == 0) {
				precFg = 0;
				precWs = 0;
			} else {
				precFg = ((double) wss / total) * 100;
				precWs = ((double) (wss - bhgWss) / wss) * 100;
			}
			String perFg = StringUtils.formatDouble(precFg, "#0.00")
					+ "%";
			String perWs = StringUtils.formatDouble(precWs, "#0.00")
					+ "%";

			t1 += total;
			t2 += wss;
			t3 += bhgWss;
			t6 += wwsaj;
			JSONObject jo = new JSONObject();
			jo.put("FYMC", Constant.fjmMap.get(fy));
			jo.put("SJAJS", total);
			jo.put("WWSAJ",wwsaj);
			jo.put("WSS", wss);
			jo.put("BHGWSS", bhgWss);
			jo.put("WSHGL", perWs);
			jo.put("FGL", perFg);
			jo.put("FJM", fy);
			ja.add(jo);
		}
		if (t1 != 0 && t2 != 0) {
			t5 = ((double) t2 / t1) * 100;
			t4 = ((double) (t2 - t3) / t2) * 100;
		}
		JSONObject job = new JSONObject();
		job.put("FYMC", "合计");
		job.put("SJAJS", t1);
		job.put("WWSAJ", t6);
		job.put("WSS", t2);
		job.put("BHGWSS", t3);
		job.put("WSHGL", StringUtils.formatDouble(t4, "#0.00") + "%");
		job.put("FGL", StringUtils.formatDouble(t5, "#0.00") + "%");
		job.put("FJM",id);
		ja.add(0, job);

	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.close(conn, st, rs);
	}
	JSONObject json = new JSONObject();
	json.put("root", ja.toString());//记录数据项
	out.print(json);
%>
