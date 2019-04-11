<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	/**
	 *	数据比对
	 算法：
	 数据通过kettle采集到110上的中心库中表DB_TJ中
	 进一步加工到FACT_SJSJC_XF中
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("HbdcJdbcTemplateExt");
	String fysql = "";
	String column = "";
	if(fydm.length() == 2 || fydm.length() == 4 && fydm.endsWith("00")){
		column = "SUBSTRING(ID_FYDM,1,4)";
		fysql = "select DM_CITY DM, NAME_CITY MC from DC_CITY WHERE DM_CITY LIKE '"+fydm+"%' and datalength(DM_CITY) = 4 ";
	}else if(fydm.length() == 4 ){
		column = "ID_FYDM";
		fysql = "select DM_CITY DM, NAME_CITY MC from DC_CITY WHERE DM_CITY LIKE '"+fydm+"%' and datalength(DM_CITY) = 6";
	}else{
		column = "ID_FYDM";
		fysql = "select DM_CITY DM, NAME_CITY MC from DC_CITY WHERE DM_CITY = '"+fydm+"' ";
	}
	
	List<Map<String,Object>> fylist = bi09.queryForList(fysql);
	Map<String,String> fymap = new HashMap<String,String>();
	List<String> dxList = new ArrayList<String>();
	for(Map<String,Object> map:fylist){
		dxList.add(map.get("DM").toString());
		fymap.put(StringUtils.trim(map.get("DM")),StringUtils.trim(map.get("MC")));
	}
	
	String start=StringUtils.trim(request.getParameter("start"));
	String limit = StringUtils.trim(request.getParameter("limit"));
	
	
	
	String sql = "";
	sql = "SELECT "+column+" DM"
		+" ,SUM(N_SPS) SPS"
		+" ,SUM(N_ZXS) ZXS"
		+" ,SUM(N_SPDCS) SPDCS"
		+" ,SUM(N_ZXDCS) ZXDCS"
		
		+" FROM FACT_SJSJC_XF WHERE ID_FYDM LIKE '"+fydm+"%' GROUP BY "+column;
	
	System.out.println("sql-->"+sql);
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	list = bi09.queryForList(sql);
	Map<String,Map<String,Object>> vmap = new HashMap<String,Map<String,Object>>();
	for(Map<String,Object> map : list){
		String dm = (String)map.get("DM");
		vmap.put(dm,map);
	}
		
	

	StringBuffer tb = new StringBuffer();
	tb.append("<table id='detail' width='100%' cellpadding='0' cellspacing='0' class='table-body' >");
	tb.append("<thead>");
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<th class='table-header-th table-cell-rownumber'></th>");
	
	tb.append("<th class='table-header-th' width='15%'>单位</th>");
	tb.append("<th class='table-header-th' width='20%'>审判库</th>");
	tb.append("<th class='table-header-th' width='20%'>中心库</th>");
	tb.append("<th class='table-header-th' width='20%'>审判多出</th>");
	tb.append("<th class='table-header-th' width='20%'>中心多出</th>");
	tb.append("</tr>");
	
	tb.append("</thead>");
	
	tb.append("<tbody>");
 	
	String CONTEXT_PATH=WebUtils.getContextPath(request);
	
	int sum1=0,sum2=0,sum3=0,sum4=0,sum5=0,sum6=0,sum7=0,sum8=0;
	int sum9=0,sum10=0,sum11=0,sum12=0,sum13=0,sum14=0,sum15=0,sum16=0;
	int i = 0;
	for(String dm : dxList){
		tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
    	tb.append("<td class='table-cell-rownumber'>"+(i+1)+"</td>");
		Map<String,Object> map = vmap.get(dm);
		if(map != null){
			String sps = map.get("SPS")==null?"0":StringUtils.trim(map.get("SPS"));
			String zxs = map.get("ZXS")==null?"0":StringUtils.trim(map.get("ZXS"));
			String spdcs = map.get("SPDCS")==null?"0":StringUtils.trim(map.get("SPDCS"));
			String zxdcs = map.get("ZXDCS")==null?"0":StringUtils.trim(map.get("ZXDCS"));
			
			
			//先审判后中心
			sum1 += Integer.parseInt(sps);
			sum2 += Integer.parseInt(zxs);
			sum3 += Integer.parseInt(spdcs);
			sum4 += Integer.parseInt(zxdcs);
			
			tb.append("<td align='center' >"+fymap.get(dm)+"</td>");
			
			tb.append("<td align='center' >"+sps+"</td>");
			tb.append("<td align='center' >"+zxs+"</td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','dcs_sp')\" >"+spdcs+"</a></td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','dcs_zx')\" >"+zxdcs+"</a></td>");
			
		}else{
			tb.append("<td align='center' >"+fymap.get(dm)+"</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
		}
		
    	tb.append("</tr>");
    	i++;
	}
	
	//合计
	tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
	tb.append("<td align='center' colspan='2' >合计</td>");
	tb.append("<td align='center' >"+sum1+"</td>");
	tb.append("<td align='center' >"+sum2+"</td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','dcs_sp')\" >"+sum3+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','dcs_zx')\" >"+sum4+"</a></td>");
	tb.append("</tr>");
	
	tb.append("</tbody>");
	tb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", tb.toString());
    out.print(json);
%>