<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.spring.*" %>
<%@ page import="tdh.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	String kssj = request.getParameter("cxsj1");
	String jssj = request.getParameter("cxsj2");
	kssj = kssj.replace("-","");
	jssj = jssj.replace("-","");
	String id = request.getParameter("id");
	if(id == null || "".equals(id.trim())) id = "3";
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	Map<String,Integer> sasMap = new HashMap<String,Integer>();
	Map<String,Integer> jasMap = new HashMap<String,Integer>();
	Map<String,Integer> wjsMap = new HashMap<String,Integer>();
	StringBuilder sb = new StringBuilder();
	List<String> list = new ArrayList<String>();
	Map<String,String> dmMap = new HashMap<String,String>();
	JSONArray  ja=new JSONArray();
	try{
		conn = SpringBeanUtils.getConnection(request,"HbdcdataSource");
		st = conn.createStatement();
		rs = st.executeQuery("select FYDM,FYMC from TS_FYMC where FJM like '"+id+"%' ORDER BY FYDM");
		while(rs.next()){
			String fydm = rs.getString("FYDM");
			String fymc = rs.getString("FYMC");
			if(sb.length()>0) sb.append(",");
			sb.append("'").append(fydm).append("'");
			dmMap.put(fydm,fymc);
			list.add(fydm);
		}
		String sas = "select FYDM,count(*) from EAJ where LARQ>='"+kssj+"' and LARQ<='"+jssj+"' AND AJZT>='300' and FYDM in ("+sb.toString()+") group by FYDM";
		rs = st.executeQuery(sas);
		while(rs.next()){
			sasMap.put(rs.getString("FYDM"),rs.getInt(2));
		}
		String jas = "select FYDM,count(*) from EAJ where JARQ>='"+kssj+"' and JARQ<='"+jssj+"' AND AJZT>='800' and FYDM in ("+sb.toString()+") group by FYDM";
		rs = st.executeQuery(jas);
		while(rs.next()){
			jasMap.put(rs.getString("FYDM"),rs.getInt(2));
		}
		String wjs = "select FYDM,count(*) from EAJ where  ( AJZT<'800' or (AJZT>='800' AND JARQ>'"+jssj+"')) and FYDM in ("+sb.toString()+") group by FYDM";
		rs = st.executeQuery(wjs);
		while(rs.next()){
			wjsMap.put(rs.getString("FYDM"),rs.getInt(2));
		}
		for(String fydm :  list){
			JSONObject jo=new JSONObject();
			int isas=0,ijas=0,iwjs=0,ijcs=0;
			if(sasMap.get(fydm)!=null) isas = sasMap.get(fydm);
			if(jasMap.get(fydm)!=null) ijas = jasMap.get(fydm);
			if(wjsMap.get(fydm)!=null) iwjs = wjsMap.get(fydm);
			
			ijcs = iwjs + ijas - isas;
		
			String fymc = dmMap.get(fydm);
			jo.put("FYMC",fymc);
			jo.put("SAS",isas);
			jo.put("JAS",ijas);
			jo.put("WJS",iwjs);
			jo.put("JCS",ijcs);
			ja.add(jo);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtil.closeConn(conn);
	}
	JSONObject json=new JSONObject();
	json.put("root", ja.toString());
	json.put("totalCount", ja.size());
	out.print(json);
%>