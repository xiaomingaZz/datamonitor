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
		sql = "select FYDM,FJM,ZT,count(*) from TR_LOG where CJRQ>='"+cxsj1+"' and CJRQ<='"+cxsj2+"' and "
		+" FJM in ("+sb.toString()+") group by FYDM,ZT";
		Map<String,int[]>  dataMap = new HashMap<String,int[]>();
		rs = st.executeQuery(sql);
		
		while(rs.next()){
			String fjm =  rs.getString("FJM");
			String zt =  rs.getString("ZT");
			int[] data = dataMap.get(fjm);
			if(data==null)  {
			   data = new int[2];
			   data[0] = 0;
			   data[1] = 0;
			 }
			if("3".equals(zt)){
				data[0] = rs.getInt(4);
			}else if("4".equals(zt)){
				data[1] = rs.getInt(4);
			}
			dataMap.put(fjm,data);
		}
		int t1=0,t2=0,t3=0;
		for(String dm: fylist){
				int s=0;
				int f=0;
				String fymc= map1.get(dm);
				JSONObject jo=new JSONObject();
				int[] data = dataMap.get(dm);
				if(data!=null){
					s = data[0];
					f = data[1];
				}
				t1 += s+f;
				t2 += s;
				t3 += f;
				jo.put("FYMC", fymc);
				jo.put("Z", s+f);
				jo.put("S", s);
				jo.put("F", f);
				jo.put("FJM",dm);
				ja.add(jo);
		}
		JSONObject jo=new JSONObject();
		jo.put("FYMC", "合计");
		jo.put("Z", t1);
		jo.put("S", t2);
		jo.put("F", t3);
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
