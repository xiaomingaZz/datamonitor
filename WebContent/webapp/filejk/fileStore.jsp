<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%
	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-","");
	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-","");
	
	String id=StringUtils.trim(request.getParameter("id"));
	if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
	JSONArray  ja=new JSONArray();
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select FYMC,DM,FJM  FROM TS_FYMC WHERE FJM LIKE '"+id+"%' order by FYDM ";
	Map<String,String> map1 = new HashMap<String,String>();
	Map<String,String> map2 = new HashMap<String,String>();
	StringBuffer sb=new StringBuffer();
	List<String> fylist = new ArrayList<String>();
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st=conn.createStatement();
		rs=st.executeQuery(sql);
		while(rs.next()){
			String fjm = StringUtils.trim(rs.getString("FJM"));
			fylist.add(fjm);
			if(sb.length()>0) sb.append(",");
			sb.append("'").append(fjm).append("'");
			map1.put(fjm, StringUtils.trim(rs.getString("FYMC")));
			map2.put(fjm, StringUtils.trim(rs.getString("DM")));
		}
		
		Map<String,Integer> dataMap1 =  new HashMap<String,Integer>();
		Map<String,Integer> dataMap2 =  new HashMap<String,Integer>();
		Map<String,Integer> dataMap3 =  new HashMap<String,Integer>();
		Map<String,Integer> dataMap4 =  new HashMap<String,Integer>();
		Map<String,Integer> dataMap5 =  new HashMap<String,Integer>();
		Map<String,Integer> dataMap6 =  new HashMap<String,Integer>();
		
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"'  and CJRQ<='"+cxsj2+"' and  "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap1.put(rs.getString("FJM"),rs.getInt(2));
		}
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and XMLTYPE='ASS' and "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap2.put(rs.getString("FJM"),rs.getInt(2));
		}
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and XMLTYPE='ADL' and "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap3.put(rs.getString("FJM"),rs.getInt(2));
		}
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and XMLTYPE='AJG' and "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap4.put(rs.getString("FJM"),rs.getInt(2));
		}
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and ERRCODE=1 and "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap5.put(rs.getString("FJM"),rs.getInt(2));
		}
		sql = "select FJM,count(*) from TR_FILES where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and ERRCODE=2 and "
		+" FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			dataMap6.put(rs.getString("FJM"),rs.getInt(2));
		}
		
		int t1=0,t2=0,t3=0,t4=0,t5=0,t6=0;
		for(String dm: fylist){
				int v1=0,v2=0,v3=0,v4=0,v5=0,v6=0;
				if(dataMap1.get(dm)!=null) v1 = dataMap1.get(dm);
				if(dataMap2.get(dm)!=null) v2 = dataMap2.get(dm);
				if(dataMap3.get(dm)!=null) v3 = dataMap3.get(dm);
				if(dataMap4.get(dm)!=null) v4 = dataMap4.get(dm);
				if(dataMap5.get(dm)!=null) v5 = dataMap5.get(dm);
				if(dataMap6.get(dm)!=null) v6 = dataMap6.get(dm);
				
				t1 += v1;
				t2 += v2;
				t3 += v3;
				t4 += v4;
				t5 += v5;
				t6 += v6;
				
				String fymc= map1.get(dm);
				JSONObject jo=new JSONObject();
				jo.put("FYMC", fymc);
				jo.put("V1", v1);
				jo.put("V2", v2);
				jo.put("V3", v3);
				jo.put("V4", v4);
				jo.put("V5", v5);
				jo.put("V6", v6);
				jo.put("FJM",dm);
				ja.add(jo);
		}
		JSONObject jo=new JSONObject();
		jo.put("FYMC", "合计");
		jo.put("V1", t1);
		jo.put("V2", t2);
		jo.put("V3", t3);
		jo.put("V4", t4);
		jo.put("V5", t5);
		jo.put("V6", t6);
		ja.add(0,jo);
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	JSONObject json=new JSONObject();
	json.put("root", ja.toString());//记录数据项
	json.put("totalCount", fylist.size());//总记录数
	out.print(json);
%>
