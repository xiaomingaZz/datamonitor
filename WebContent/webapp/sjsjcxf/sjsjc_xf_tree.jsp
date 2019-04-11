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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("HbdcJdbcTemplateExt");
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY where DM_CITY like '"+fydm+"%' and isnull(SFJY,'0') <> '1' order by DM_CITY");
	
	JSONArray ja = new JSONArray();
	for(int i=0;i<fylist.size();i++){
		Map<String,Object> mm = fylist.get(i);
		String dm = StringUtils.trim(mm.get("DM"));
		String mc = StringUtils.trim(mm.get("MC"));
		
		if(!dm.endsWith("0000")){
			JSONObject jo = new JSONObject();
			jo.put("id", dm);
			jo.put("pId",dm.substring(0,dm.length()-2));
			jo.put("name",mc);
			ja.add(jo);
		}
		
	}
	out.print(ja);
%>