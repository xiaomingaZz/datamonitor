<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("HbdcJdbcTemplateExt");
	
	String flag = StringUtils.trim(request.getParameter("flag"));
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	
	JSONArray ja = new JSONArray();
	
	try{
		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY like '"+fydm+"%' and isnull(SFJY,'0') <> '1' order by DM_CITY");
		
		
		String dl = flag.split("_")[0];
		String fg = flag.split("_")[1];
		String table = "";
		String table2 = "";
		String column = "";
		String column2 = "";
		if("sp".equals(fg)){
			table = "DB_TJ_HY";
			column = "AJBS";
			table2 = "EAJ";
			column2 = "AHDM";
		}else{
			table2 = "DB_TJ_HY";
			column2 = "AJBS";
			table = "EAJ";
			column = "AHDM";
		}
		
		Map<String,Integer> vmap = new HashMap<String,Integer>();
		String sql = "SELECT FYDM DM,COUNT(*) SL FROM "+table+" WHERE ";
		
		sql += Constant.xfFcMap.get(flag).replace("@column@",column)
				.replace("@column2@",column2)
				.replace("@table2@",table2);
		sql += " group by FYDM ";
		
		System.out.println("fc tree sql-->"+sql);
		List<Map<String,Object>> list = bi09.queryForList(sql);
		for(Map<String,Object> mm:list){
			String dm = mm.get("DM").toString();
			int sl = mm.get("SL")==null?0:Integer.valueOf(mm.get("SL").toString());
			vmap.put(dm,sl);
			if(vmap.containsKey(dm.substring(0,4))){
				vmap.put(dm.substring(0,4),sl+vmap.get(dm.substring(0,4)));
			}else{
				vmap.put(dm.substring(0,4),sl);
			}
			if(vmap.containsKey(dm.substring(0,2))){
				vmap.put(dm.substring(0,2),sl+vmap.get(dm.substring(0,2)));
			}else{
				vmap.put(dm.substring(0,2),sl);
			}
		}
				
		
		for(int i=0;i<fylist.size();i++){
			Map<String,Object> mm = fylist.get(i);
			String dm = mm.get("DM").toString();
			String mc = mm.get("MC").toString();
			
			if(!dm.endsWith("0000")){
				int sl = vmap.containsKey(dm)?vmap.get(dm):0;
				JSONObject jo = new JSONObject();
				jo.put("id", dm);
				jo.put("pId",dm.substring(0,dm.length()-2));
				jo.put("name",mc+"("+sl+")");
				ja.add(jo);
			}
			
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	out.print(ja);
%>