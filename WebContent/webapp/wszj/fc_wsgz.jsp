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
	Map<Integer, String> wsMap = new HashMap<Integer, String>();
	wsMap.put(2, "裁判文书不能为规定格式(.html,.htm,.txt)外或者无效文件");
	wsMap.put(3, "文书类型为裁判文书，其文书内容不能为庭审笔录、开庭公告、决定等非裁判文书");
	wsMap.put(4, "裁判文书不能存在模板原始字样或文书内容不能为空");
	wsMap.put(5, "裁判文书中案号与案件不能不一致");
	wsMap.put(6, "裁判文书不能缺少法院、案号");
	List<String> sllist = new ArrayList<String>();

	JSONArray ja = new JSONArray();
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	int t1=0,t2=0;
	String sql = "select ";
	for(int i=2;i<7;i++){
		if(i==2){
			sql+=" SUM(convert(int,FLAGWS0"+i+")) as F"+i;
		}else{
		sql+=" ,SUM(convert(int,FLAGWS0"+i+")) as F"+i;
		}
	}
	sql+=" FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
			+ cxsj1 + "' " + " AND JARQ<='" + cxsj2
			+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
			+ " AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY like '" + id + "%'";
	try {
		conn = WebAppContext.getNewConn("HbsjjzdataSource");
		   st = conn.createStatement();
			rs = st.executeQuery(sql);
			int t=0;
			if (rs.next()) {
				for(int i=2;i<7;i++){
				String str=rs.getString("F"+i)== null ? "0" : rs.getString("F" + i);
				t+=Integer.parseInt(str);
				JSONObject jo = new JSONObject();
				jo.put("WS", wsMap.get(i));
				jo.put("SL", str);
				jo.put("FY",id);
				ja.add(jo);
				}
		}
			JSONObject jo1 = new JSONObject();
			jo1.put("WS", "合计");
			jo1.put("SL", t);
			jo1.put("FY",id);
			ja.add(jo1);
			
			sql = "SELECT COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
					+ cxsj1
					+ "' "
					+ " AND JARQ<='"
					+ cxsj2
					+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
					+ " AND SFCZWS='1' AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '"
					+ id + "%' ";
			rs = st.executeQuery(sql);
			if (rs.next()) {
				JSONObject jo = new JSONObject();
				t1=rs.getInt(1);
				jo.put("WS", "入库文书总数");
				jo.put("SL", rs.getInt(1));
				jo.put("FY",id);
				ja.add(jo);
			}

			sql = "SELECT COUNT(*) FROM TR_DD WHERE AJZT>='800' AND JARQ>='"
					+ cxsj1
					+ "' "
					+ " AND JARQ<='"
					+ cxsj2
					+ "' AND SUBSTRING(XMLNAME,11,2) NOT IN('71','91') "
					+ " AND SFCZWS='1' AND (FLAGWS02='1' OR FLAGWS03='1' "
					+ " OR FLAGWS04='1' OR FLAGWS05='1' OR FLAGWS06='1')AND ISNULL(DEL,'')<>'1' AND ISNULL(JAFS,'')='0' AND FY LIKE '"
					+ id + "%'";
			rs = st.executeQuery(sql);
			if (rs.next()) {
				JSONObject jo = new JSONObject();
				t2=rs.getInt(1);
				jo.put("WS", "不合格文书总数");
				jo.put("SL", rs.getInt(1));
				jo.put("FY",id);
				ja.add(jo);
			}
			
			double prec = 0;
			if (t1 == 0) {
				prec = 0;
			} else {
				prec = ((double) (t1-t2) / t1) * 100;
			}
			String per = StringUtils.formatDouble(prec, "#0.00")
					+ "%";
			JSONObject jo = new JSONObject();
			t2=rs.getInt(1);
			jo.put("WS", "文书合格率");
			jo.put("SL", per);
			jo.put("FY",id);
			ja.add(jo);
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.close(conn, st, rs);
	}
	JSONObject json = new JSONObject();
	json.put("root", ja.toString());
	out.print(json);
%>