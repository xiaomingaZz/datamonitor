<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="tdh.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.frame.system.*" %>
<%
	String fydm = "300";//取分级码
	String fymc = "河北省高级人民法院";
    Map<String,String> data = new HashMap<String,String>();

    JSONArray faArr = new JSONArray();
    
    Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	try{
		conn = WebAppContext.getConn("HbsjjzdataSource");
		st = conn.createStatement();
		rs = st.executeQuery("select DM_CITY,NAME_CITY FROM T_CITY order by DM_CITY");
		while(rs.next()){
			data.put(rs.getString("DM_CITY"),rs.getString("NAME_CITY"));
		}
		
		List<TsFymc> list = new ArrayList<TsFymc>();
		String sql = "SELECT * FROM TS_FYMC WHERE FJM LIKE '3%'";
		rs = st.executeQuery(sql);
		while(rs.next()){
			String _fydm = rs.getString("FYDM");
			String _fjm = rs.getString("FJM");
			String _fymc = rs.getString("FYMC");
			String _fydc = rs.getString("FYDC");
			TsFymc tf = new TsFymc();
			tf.setFydm(_fydm);
			tf.setFymc(_fymc);
			tf.setFydc(_fydc);
			tf.setFjm(_fjm);
			list.add(tf);
		}
		
		//开始构造
		TsFymc _fy = new TsFymc();
		for (TsFymc wf : list) {
			if (wf.getFjm().equals(fydm)) {
				_fy = wf;
				fymc = wf.getFymc();
				break;
			}
		}
		
		if ("00".equals(fydm.substring(1, 3))) {
			JSONArray nArr = new JSONArray();
			
			//加入一个高级法院
			JSONObject gy_json = new JSONObject();
			gy_json.put("id", fydm);
			gy_json.put("text", fymc);
			gy_json.put("leaf", true);
			gy_json.put("fl", "fy");
			//gy_json.put("checked", false);//checked
			nArr.add(gy_json);
			
			
			for (TsFymc fyxx : list) {
				String _fydm = fyxx.getFjm();
				if ("0".equals(_fydm.substring(2, 3))
						&& !"00".equals(_fydm.substring(1, 3))) {
					Map<String, Object> zymap = new HashMap<String, Object>(); // 中院
					
					//加入一层 市
					zymap.put("id", fyxx.getFjm().substring(0,2));
					//zymap.put("text", fyxx.getFyjc());//地区名称--框架库，fyjc存地区名称！！
					zymap.put("text",data.get(fyxx.getFjm().substring(0,2)));
					zymap.put("cls", "folder");
					zymap.put("expanded", false);
					zymap.put("fl", "fy");
					//zymap.put("checked", false);//checked
					
					
					JSONArray jyArr = new JSONArray();// 基层法院
					//把中院加入
					JSONObject zy_json = new JSONObject();
					zy_json.put("id", fyxx.getFjm());
					zy_json.put("text", fyxx.getFymc());
					zy_json.put("leaf", true);
					zy_json.put("fl", "fy");
					//zy_json.put("checked", false);//checked
					jyArr.add(zy_json);
					
					for (TsFymc fy : list) {
						if (!"0".equals(fy.getFjm().substring(2, 3))
								&& fy.getFjm().substring(1, 2)
										.equals(fyxx.getFjm().substring(1,2))) {
							JSONObject json = new JSONObject();
							json.put("id", fy.getFjm());
							json.put("text", fy.getFymc());
							json.put("leaf", true);
							json.put("fl", "fy");
							//json.put("checked", false);//checked
							jyArr.add(json);
						}
					}
					if (jyArr.size() == 0) {
						zymap.put("leaf", true);
					} else {
						zymap.put("leaf", true);
						//zymap.put("children", jyArr.toArray());
					}
					nArr.add(zymap);
				}
			}
			
			//加入省
			JSONObject njson = new JSONObject();
			njson.put("id", fydm.substring(0,1));
			//njson.put("text", _fy.getFyjc());
			njson.put("text", data.get(fydm.substring(0,1)));
			njson.put("cls", "folder");
			//njson.put("checked", false);//checked
			njson.put("children", nArr.toArray());
			njson.put("expanded", true);
			
			faArr.add(njson);
		} else if ("0".equals(fydm.substring(2, 3))
				&& !"00".equals(fydm.substring(1, 3))) {
			Map<String, Object> zymap = new HashMap<String, Object>(); // 中院
			zymap.put("id", fydm.subSequence(0, 2));
			zymap.put("text", _fy.getFyjc());
			zymap.put("cls", "folder");
			zymap.put("expanded", true);
			zymap.put("fl", "fy");
			JSONArray jyArr = new JSONArray();// 基层法院
			
			JSONObject zy_json = new JSONObject();
			zy_json.put("id", fydm);
			zy_json.put("text", fymc);
			zy_json.put("leaf", true);
			zy_json.put("fl", "fy");
			jyArr.add(zy_json);
			
			for (TsFymc fy : list) {
				if (!"0".equals(fy.getFjm().substring(2, 3))
						&& fy.getFjm().substring(1, 2)
								.equals(fydm.substring(1, 2))) {
					JSONObject json = new JSONObject();
					json.put("id", fy.getFjm());
					json.put("text", fy.getFymc());
					json.put("leaf", true);
					json.put("fl", "fy");
					jyArr.add(json);
				}
			}
			if (jyArr.size() == 0) {
				zymap.put("leaf", true);
			} else {
				zymap.put("leaf", true);
				//zymap.put("children", jyArr.toArray());
			}
			faArr.add(zymap);
		} else if (!"0".equals(fydm.substring(2, 3))
				&& !"00".equals(fydm.substring(1, 3))) {
			JSONArray jyArr = new JSONArray();
				JSONObject json = new JSONObject();
				json.put("id", fydm);
				json.put("text", fymc);
				json.put("leaf", true);
				json.put("fl", "fy");
				jyArr.add(json);
			faArr = jyArr;
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtil.closeConn(conn);
	}
	out.print(faArr.toString());
%>
