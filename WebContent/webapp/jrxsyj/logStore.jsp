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
	
	Connection conn2= null;
	Statement st2 = null;
	ResultSet rs2 = null;
	
	String sql="select FYMC,DM,FJM  FROM TS_FYMC WHERE FJM LIKE '"+id+"%' order by FYDM ";
	Map<String,String> map1 = new HashMap<String,String>();
	Map<String,String> map2 = new HashMap<String,String>();
	StringBuffer sb=new StringBuffer();
	StringBuffer sb2=new StringBuffer();
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
			
			if(sb2.length()>0) sb2.append(",");
			sb2.append("'").append(rs.getString("DM")).append("'");
			
			map1.put(fjm, StringUtils.trim(rs.getString("FYMC")));
			map2.put(fjm, StringUtils.trim(rs.getString("DM")));
		}
		Map<String,Integer> mapdata1 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata21 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata22 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata23 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata3 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata4 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata5 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata6 = new HashMap<String,Integer>();
		Map<String,Integer> mapdata7 = new HashMap<String,Integer>();
		
		sql = "select FYDM,count(*) from TR_LOG where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and "
		+" FYDM in ("+sb.toString()+") group by FYDM";
		
		rs = st.executeQuery(sql);
		while(rs.next()){
			String fjm =  rs.getString("FYDM");
			mapdata1.put(fjm,rs.getInt(2));
		}
		
		sql = "select FJM,count(*) from TR_ZIPSBLOG where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+" WJMC like 'AJ%'  and SBZT='1' AND FJM in ("+sb.toString()+") group by FJM";
		
		rs = st.executeQuery(sql);
		while(rs.next()){
			String fjm =  rs.getString("FJM");
			mapdata21.put(fjm,rs.getInt(2));
		}
		
		sql = "select FJM,count(*) from TR_ZIPSBLOG where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+" WJMC like 'DL%'  and  SBZT='1' AND FJM in ("+sb.toString()+") group by FJM";
		
		rs = st.executeQuery(sql);
		while(rs.next()){
			String fjm =  rs.getString("FJM");
			mapdata22.put(fjm,rs.getInt(2));
		}
		
		sql = "select FJM,count(*) from TR_ZIPSBLOG where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+" WJMC like 'JG%'  and  SBZT='1' AND FJM in ("+sb.toString()+") group by FJM";
		
		rs = st.executeQuery(sql);
		while(rs.next()){
			String fjm =  rs.getString("FJM");
			mapdata23.put(fjm,rs.getInt(2));
		}

		sql = "select FJM,count(*) from TR_ZIPSBLOG where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+"  SBZT='2' AND FJM in ("+sb.toString()+") group by FJM";
		rs = st.executeQuery(sql);
		while(rs.next()){
			String fjm =  rs.getString("FJM");
			mapdata3.put(fjm,rs.getInt(2));
		}
		
		conn2 = WebAppContext.getNewConn("HbdcdataSource");
		st2 = conn2.createStatement();
		
		sql = "select JBFY,count(*) from DC_WS_DAILY_SA where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+" JBFY in ("+sb2.toString()+") group by JBFY";
		
		//System.out.println(sql);
		rs2 = st2.executeQuery(sql);
		while(rs2.next()){
			String fjm =  Constant.fyDMtoFjmMap.get(rs2.getString("JBFY"));
			mapdata4.put(fjm,rs2.getInt(2));
		}
		
		
		sql = "select FJM,count(*) from EAJ where  AJZT>='300' AND LARQ>='"+cxsj1+"' and LARQ<='"+cxsj2+"' and "
				+" FJM in ("+sb.toString()+") group by FJM";
		
		//System.out.println(sql);
		rs2 = st2.executeQuery(sql);
		while(rs2.next()){
			String fjm = rs2.getString("FJM");
			mapdata5.put(fjm,rs2.getInt(2));
		}
		
		sql = "select JBFY,count(*) from DC_WS_DAILY_JA where RQ>='"+cxsj1+"' and RQ<='"+cxsj2+"' and "
				+" JBFY in ("+sb2.toString()+") group by JBFY";
		
		//System.out.println(sql);
		rs2 = st2.executeQuery(sql);
		while(rs2.next()){
			String fjm =  Constant.fyDMtoFjmMap.get(rs2.getString("JBFY"));
			mapdata6.put(fjm,rs2.getInt(2));
		}
		
		sql = "select FJM,count(*) from EAJ where AJZT>='800' AND  JARQ>='"+cxsj1+"' and JARQ<='"+cxsj2+"' and "
				+" FJM in ("+sb.toString()+") group by FJM";
		
		//System.out.println(sql);
		rs2 = st2.executeQuery(sql);
		while(rs2.next()){
			String fjm = rs2.getString("FJM");
			mapdata7.put(fjm,rs2.getInt(2));
		}
		
		int t1=0,t21=0,t22=0,t23=0,t3=0,t4=0,t5=0,t6=0,t7=0;
		for(String dm: fylist){
				String fymc= map1.get(dm);
				JSONObject jo=new JSONObject();
				Integer v1 = mapdata1.get(dm);
				if(v1 == null) v1 = 0;
				
				Integer v21 = mapdata21.get(dm);
				if(v21 == null) v21 = 0;
				
				Integer v22 = mapdata22.get(dm);
				if(v22 == null) v22 = 0;
				
				Integer v23 = mapdata23.get(dm);
				if(v23 == null) v23 = 0;
				
				Integer v3 = mapdata3.get(dm);
				if(v3 == null) v3 = 0;
				
				Integer v4 = mapdata4.get(dm);
				if(v4 == null) v4 = 0;
				
				Integer v5 = mapdata5.get(dm);
				if(v5 == null) v5 = 0;
				
				Integer v6 = mapdata6.get(dm);
				if(v6 == null) v6 = 0;
				
				Integer v7 = mapdata7.get(dm);
				if(v7 == null) v7 = 0;
				
				t1 += v1;
				t21 += v21;
				t22 += v22;
				t23 += v23;
				t3 += v3;
				t4 += v4;
				t5 += v5;
				t6 += v6;
				t7 += v7;
				
				jo.put("FYMC", fymc);
				jo.put("N1", v1);
				jo.put("N21", v21);
				jo.put("N22", v22);
				jo.put("N23", v23);
				jo.put("N3", v3);
				jo.put("N4", v4);
				jo.put("N5", v5);
				jo.put("N6", v6);
				jo.put("N7", v7);
				ja.add(jo);
		}
		JSONObject jo=new JSONObject();
		jo.put("FYMC", "合计");
		jo.put("N1", t1);
		jo.put("N21", t21);
		jo.put("N22", t22);
		jo.put("N23", t23);
		jo.put("N3", t3);
		jo.put("N4", t4);
		jo.put("N5", t5);
		jo.put("N6", t6);
		jo.put("N7", t7);
		ja.add(0, jo);
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
		DBUtils.close(conn2, st2, rs2);
	}
	JSONObject json=new JSONObject();
	json.put("root", ja.toString());//记录数据项
	json.put("totalCount", fylist.size());//总记录数
	out.print(json);
%>
