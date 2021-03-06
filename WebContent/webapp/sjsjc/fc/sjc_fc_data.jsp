<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils,tdh.spring.SpringContextHolder"%>
<%@page import="tdh.Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	/**
	 *	数据比对反查
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	JSONObject json = new JSONObject();
	
	StringBuffer tb = new StringBuffer();
	int totalCounts = 0;
	int totalPages = 0;
	int cuPage = 0;
	
	try{
		JdbcTemplateExt bi09 = WebAppContext.getBeanEx("HbdcJdbcTemplateExt");
		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DC_CITY");
		Map<String,String> fymap = new HashMap<String,String>();
		for(Map<String,Object> map:fylist){
			fymap.put(map.get("DM").toString(),map.get("MC").toString());
		}
		
		String flag = StringUtils.trim(request.getParameter("flag"));
		String fydm = StringUtils.trim(request.getParameter("FYDM"));
		String kssj = StringUtils.trim(request.getParameter("kssj"));
		String jssj = StringUtils.trim(request.getParameter("jssj"));
		
		String start=StringUtils.trim(request.getParameter("start"));
		String limit = StringUtils.trim(request.getParameter("limit"));
		
		String dl = flag.split("_")[0];
		String fg = flag.split("_")[1];
		String table = "";
		String column = "";
		String table2 = "";
		String column2 = "";
		if("sp".equals(fg)){
			table = "DB_TJ_HY";
			column = " AJBS ";
			table2 = "EAJ";
			column2 = " AHDM ";
		}else{
			table = "EAJ";
			column = " AHDM ";
			table2 = "DB_TJ_HY";
			column2 = " AJBS ";
		}
		String sql = "SELECT "+column+"AHDM,AH,FYDM,LARQ,JARQ FROM "+table+" WHERE FYDM LIKE '"+fydm+"%'  ";
		/*if("jc".equals(dl)){
			sql += " AND AJZT >='300' AND LARQ < '"+kssj+"' AND (AJZT < '800' or AJZT >='800' AND JARQ >='"+kssj+"')"
				+" AND "+column+" NOT IN (SELECT "+column2+" FROM "+table2+" WHERE AJZT >='300' ) ";
		}else if("sa".equals(dl)){
			sql += " AND AJZT >='300' AND LARQ >= '"+kssj+"' AND LARQ <='"+jssj+"' "
				+" AND "+column+" NOT IN (SELECT "+column2+" FROM "+table2+" WHERE AJZT >='300' AND LARQ > '' ) ";
		}else if("ja".equals(dl)){
			sql += " AND AJZT >='800' AND JARQ >= '"+kssj+"' AND JARQ <='"+jssj+"' "
				+" AND "+column+" NOT IN (SELECT "+column2+" FROM "+table2+" WHERE AJZT >='800' AND JARQ >='') ";
		}else{
			sql += " AND AJZT >='300' AND LARQ <= '"+jssj+"' AND (AJZT < '800' or AJZT >='800' AND JARQ > '"+jssj+"')"
				+" AND "+column+" NOT IN (SELECT "+column2+" FROM "+table2+" WHERE AJZT >='300' ) ";
		}*/
		
		sql += " AND " + Constant.fcmap.get(flag).replace("@kssj@",kssj)
				.replace("@jssj@",jssj)
				.replace("@column@",column)
				.replace("@column2@",column2)
				.replace("@table2@",table2);
		
		sql += " order by FYDM,AH ";
		
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		Map<String,Integer> vmap = new HashMap<String,Integer>();
		String fieldmc = "法院,案号,案件标识,立案日期,结案日期";
		String field = "FYDM,AH,AHDM,LARQ,JARQ";
			
		PaginateJdbc pdbc = WebAppContext.getBeanEx("HbdcPaginateJdbc");
		PageBean pb = new PageBean();
		pb.setCurrentPage(Integer.valueOf(start));
	   	pb.setStartRow((Integer.valueOf(start)-1)*Integer.valueOf(limit));
	    pb.setLen(Integer.valueOf(limit));
	    System.out.println("fc data sql-->"+sql);
		pb.setHql(sql);    
		pb = pdbc.getList(pb);
		list = pb.getResult();
		totalCounts = pb.getTotalRows();
		totalPages = pb.getTotalPage();
		cuPage = pb.getCurrentPage();
		
		
		tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
		tb.append("<thead>");
		tb.append("<tr class='table-header table-header-row'>");
		tb.append("<th class='table-header-th table-cell-rownumber'></th>");
		String[] mcs = fieldmc.split(",");
		String[] fields = field.split(",");
		
		for(int i =0;i< mcs.length;i++){
			String fi = StringUtils.trim(fields[i]);
			if(fi.contains("FY")){
				tb.append("<th class='table-header-th' width='20%'>"+mcs[i]+"</th>");
			}else if(fi.contains("AH")){
				tb.append("<th class='table-header-th' width='30%' >"+mcs[i]+"</th>");
			}else{
				tb.append("<th class='table-header-th' ><input type='text' value='"+mcs[i]+"' readonly></th>");
			}
		}
		tb.append("</tr>");
		tb.append("</thead>");
		
		tb.append("<tbody>");
	 	
		String CONTEXT_PATH=WebUtils.getContextPath(request);
		for(int i=0;i<list.size();i++){
			tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
	    	tb.append("<td class='table-cell-rownumber'>"+(i+1)+"</td>");
			Map<String,Object> map = list.get(i);
			for(int j=0;j<fields.length;j++){
				String fi = StringUtils.trim(fields[j]);
				if(fi.contains(".")){
					fi=fi.substring(fi.lastIndexOf("."));
				}
				String value = StringUtils.trim(map.get(fields[j]));
				if(fi.contains("FY")){
					tb.append("<td align='left' >"+fymap.get(value)+"</td>");
				}else if(fi.contains("AH")){
					tb.append("<td align= 'left' >"+value+"</td>");
				}else{
					tb.append("<td ><input type='text' value='"+value+"' title='"+value+"' readonly></td>");
				}
			}
	    	tb.append("</tr>");
		}
		tb.append("</tbody>");
		tb.append("</table>");
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
	
    json.put("table", tb.toString());
    json.put("totalCounts",totalCounts );
    json.put("totalPages",totalPages );
    json.put("cuPage",cuPage );
    out.print(json);
%>