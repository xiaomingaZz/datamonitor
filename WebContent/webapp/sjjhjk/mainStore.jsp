<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%
	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));

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
		
		//到达数
		Map<String,String>  ddsdMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' AND FY in ("
		+ sb.toString()+") group by FY";
		rs = st.executeQuery(sql);
		while(rs.next()){
			ddsdMap.put(rs.getString("FY"),rs.getString(2));
		}
		//入库数
		Map<String,String>  rksdMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE  ZT='3' and DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' AND FY in ("
		+ sb.toString()+") group by FY";
		rs = st.executeQuery(sql);
		while(rs.next()){
			rksdMap.put(rs.getString("FY"),rs.getString(2));
		}
		//异常
		Map<String,String>  ycsdMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE  ZT='4' and DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' AND FY in ("
		+ sb.toString()+") group by FY";
		rs = st.executeQuery(sql);
		while(rs.next()){
			ycsdMap.put(rs.getString("FY"),rs.getString(2));
		}
		//待入库
		Map<String,String>  drksMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE  ZT='1' and DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59'  AND FY in ("
		+ sb.toString()+") group by FY";
		rs = st.executeQuery(sql);
		while(rs.next()){
			drksMap.put(rs.getString("FY"),rs.getString(2));
		}
		//加载
		Map<String,String>  zzjzMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE  ZT='2'and DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59'  AND FY in ("
		+ sb.toString()+") group by FY";
		rs = st.executeQuery(sql);
		while(rs.next()){
			zzjzMap.put(rs.getString("FY"),rs.getString(2));
		}
		
		//删除数
		Map<String,String>  scMap = new HashMap<String,String>();
		sql="select FY,count(*) FROM TR_DD WHERE (ZT = '3' OR ZT='4') and DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' AND  ISNULL(DEL,'')='1' AND FY in ("
				+ sb.toString()+") group by FY";
				rs = st.executeQuery(sql);
				while(rs.next()){
					scMap.put(rs.getString("FY"),rs.getString(2));
				}
		int t1=0,t2=0,t3=0,t4=0,t5=0,t6=0;
		for(String dm: fylist){
				String dds="0";
				String rks="0";
				String ycs="0";
				String drks="0";
				String zzjz="0";
				String scs="0";
				String fymc= map1.get(dm);
				JSONObject jo=new JSONObject();
				dds = ddsdMap.get(dm);
				if(dds == null) dds = "0";
				rks =  rksdMap.get(dm);
				if(rks == null) rks = "0";
				ycs = ycsdMap.get(dm);
				if(ycs == null) ycs = "0";
				drks = drksMap.get(dm);
				if(drks == null) drks = "0";
				zzjz = zzjzMap.get(dm);
				if(zzjz == null) zzjz = "0";
				scs=scMap.get(dm);
				if(scs==null) scs="0";
				t1+=Integer.parseInt(dds);
				t2+=Integer.parseInt(rks);
				t3+=(Integer.parseInt(drks) + Integer.parseInt(zzjz));
				t4+=Integer.parseInt(zzjz);
				t5+=Integer.parseInt(ycs);
				t6+=Integer.parseInt(scs);
				jo.put("FYMC", fymc);
				jo.put("DDS", Integer.parseInt(dds));
				jo.put("RKS", Integer.parseInt(rks));
				jo.put("DRKS", Integer.parseInt(drks) + Integer.parseInt(zzjz));
				jo.put("ZZJZ", Integer.parseInt(zzjz));
				jo.put("YCS", Integer.parseInt(ycs));
				jo.put("SCS",Integer.parseInt(scs));
				jo.put("FYDM", dm);
				ja.add(jo);
			}
		JSONObject jo = new JSONObject();
		jo.put("FYMC", "合计");
		jo.put("DDS", t1);
		jo.put("RKS", t2);
		jo.put("DRKS", t3);
		jo.put("ZZJZ", t4);
		jo.put("YCS", t5);
		jo.put("SCS", t6);
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
