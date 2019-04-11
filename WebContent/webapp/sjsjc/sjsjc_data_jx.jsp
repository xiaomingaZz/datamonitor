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
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
	/**
	 *	数据比对
	 算法：
	 数据通过kettle采集到110上的中心库中表DB_TJ中
	 进一步加工到FACT_SJSJC中
	 CREATE TABLE FACT_SJSJC(
	 ID_DAY VARCHAR(8) NOT NULL,
	 ID_FYDM VARCHAR(6) NOT NULL,
	 N_ZXSAS INT NULL,
	 N_ZXJAS INT NULL,
	 N_ZXJCS INT NULL,
	 N_ZXWJS INT NULL,
	 N_SPSAS INT NULL,
	 N_SPJAS INT NULL,
	 N_SPJCS INT NULL,
	 N_SPWJS INT NULL
	 );
	 
	 **/
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	
	String fydm = StringUtils.trim(request.getParameter("FYDM"));
	String kssj = StringUtils.trim(request.getParameter("kssj"));
	String jssj = StringUtils.trim(request.getParameter("jssj"));

	JdbcTemplateExt bi09 = WebAppContext.getBeanEx("BiJdbcTemplateExt");
	String fysql = "";
	String column = "";
	if(fydm.length() == 2 || fydm.length() == 4 && fydm.endsWith("00")){
		column = "SUBSTRING(C_FYDM,1,4)";
		fysql = "select DM_CITY DM, NAME_CITY MC from DM_CITY WHERE DM_CITY LIKE '"+fydm+"%' and datalength(DM_CITY) = 4 ";
	}else if(fydm.length() == 4 ){
		column = "C_FYDM";
		fysql = "select DM_CITY DM, NAME_CITY MC from DM_CITY WHERE DM_CITY LIKE '"+fydm+"%' and datalength(DM_CITY) = 6";
	}else{
		column = "C_FYDM";
		fysql = "select DM_CITY DM, NAME_CITY MC from DM_CITY WHERE DM_CITY = '"+fydm+"' ";
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
	
	String sj = "";
	List<Map<String,Object>> sjlist = bi09.queryForList("SELECT SJ FROM FACT_SJ WHERE ID = 'SJSJC'");
	if(sjlist != null && sjlist.size() > 0){
		sj = StringUtils.trim(sjlist.get(0).get("SJ"));
	}
	
	
	String sql = "";
	sql = "SELECT "+column+" DM"
		+" ,SUM(N_DC_SAS) ZXSAS,SUM(N_DC_JAS) ZXJAS"
		/* +" ,SUM(CASE WHEN ID_DAY = '"+kssj+"' THEN N_ZXJCS ELSE 0 END) ZXJCS"*/
		+" ,SUM(CASE WHEN C_RQ = '"+jssj+"' THEN N_DC_WJS ELSE 0 END) ZXWJS" 
		+" ,SUM(N_DAY_SAS) SPSAS,SUM(N_DAY_JAS) SPJAS"
		/* +" ,SUM(CASE WHEN ID_DAY = '"+kssj+"' THEN N_SPJCS ELSE 0 END) SPJCS"*/
		+" ,SUM(CASE WHEN C_RQ = '"+jssj+"' THEN N_DAY_WJS ELSE 0 END) SPWJS" 
		
		+" ,SUM(N_PC_ZSAS) ZXSAS_CY,SUM(N_PC_ZJAS) ZXJAS_CY"
		/* +" ,SUM(CASE WHEN ID_DAY = '"+kssj+"' THEN N_ZXJCS_CY ELSE 0 END) ZXJCS_CY"*/
		+" ,SUM(CASE WHEN C_RQ = '"+jssj+"' THEN N_PC_ZWJS ELSE 0 END) ZXWJS_CY" 
		+" ,SUM(N_PC_FSAS) SPSAS_CY,SUM(N_PC_FJAS) SPJAS_CY"
		/* +" ,SUM(CASE WHEN ID_DAY = '"+kssj+"' THEN N_SPJCS_CY ELSE 0 END) SPJCS_CY"*/
		+" ,SUM(CASE WHEN C_RQ = '"+jssj+"' THEN N_PC_FWJS ELSE 0 END) SPWJS_CY" 
		
		+" FROM FACT_ND_SJJH WHERE "
		+" C_RQ >= '"+kssj+"' AND C_RQ <= '"+jssj+"' " 
		+" AND C_FYDM LIKE '"+fydm+"%' GROUP BY "+column;
	
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
	tb.append("<th class='table-header-th table-cell-rownumber' rowspan='2'></th>");
	
	tb.append("<th class='table-header-th' width='10%' rowspan='2'>单位</th>");
	tb.append("<th class='table-header-th' colspan='3'>审判库</th>");
	tb.append("<th class='table-header-th' colspan='3'>中心库</th>");
	tb.append("<th class='table-header-th' colspan='3'>中心多</th>");
	tb.append("<th class='table-header-th' colspan='3'>中心少</th>");
	tb.append("<th class='table-header-th' colspan='3'>可信度(%)</th>");
	tb.append("</tr>");
	
	tb.append("<tr class='table-header table-header-row'>");
	tb.append("<th class='table-header-th' >新收</th>");
	tb.append("<th class='table-header-th' >结案</th>");
	tb.append("<th class='table-header-th' >未结</th>");
	tb.append("<th class='table-header-th' >新收</th>");
	tb.append("<th class='table-header-th' >结案</th>");
	tb.append("<th class='table-header-th' >未结</th>");
	tb.append("<th class='table-header-th' >新收</th>");
	tb.append("<th class='table-header-th' >结案</th>");
	tb.append("<th class='table-header-th' >未结</th>");
	tb.append("<th class='table-header-th' >新收</th>");
	tb.append("<th class='table-header-th' >结案</th>");
	tb.append("<th class='table-header-th' >未结</th>");
	tb.append("<th class='table-header-th' >新收</th>");
	tb.append("<th class='table-header-th' >结案</th>");
	tb.append("<th class='table-header-th' >未结</th>");
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
			Integer zxsas = map.get("ZXSAS")==null?0:(Integer)map.get("ZXSAS");
			Integer zxjas = map.get("ZXJAS")==null?0:(Integer)map.get("ZXJAS");
			Integer zxwjs = map.get("ZXWJS")==null?0:(Integer)map.get("ZXWJS");
			Integer spsas = map.get("SPSAS")==null?0:(Integer)map.get("SPSAS");
			Integer spjas = map.get("SPJAS")==null?0:(Integer)map.get("SPJAS");
			Integer spwjs = map.get("SPWJS")==null?0:(Integer)map.get("SPWJS");
			
			Integer zxsas_cy = map.get("ZXSAS_CY")==null?0:(Integer)map.get("ZXSAS_CY");
			Integer zxjas_cy = map.get("ZXJAS_CY")==null?0:(Integer)map.get("ZXJAS_CY");
			Integer zxwjs_cy = map.get("ZXWJS_CY")==null?0:(Integer)map.get("ZXWJS_CY");
			Integer spsas_cy = map.get("SPSAS_CY")==null?0:(Integer)map.get("SPSAS_CY");
			Integer spjas_cy = map.get("SPJAS_CY")==null?0:(Integer)map.get("SPJAS_CY");
			Integer spwjs_cy = map.get("SPWJS_CY")==null?0:(Integer)map.get("SPWJS_CY");
			
			//先审判后中心
			sum2 += spsas;
			sum3 += spjas;
			sum4 += spwjs;
			
			sum6 += zxsas;
			sum7 += zxjas;
			sum8 += zxwjs;
			
			
			
			sum10 += zxsas_cy;
			sum11 += zxjas_cy;
			sum12 += zxwjs_cy;
			sum14 += spsas_cy;
			sum15 += spjas_cy;
			sum16 += spwjs_cy;
			
			
			tb.append("<td align='center' >"+fymap.get(dm)+"</td>");
			
			tb.append("<td align='center' >"+spsas+"</td>");
			tb.append("<td align='center' >"+spjas+"</td>");
			tb.append("<td align='center' >"+spwjs+"</td>");
			
			tb.append("<td align='center' >"+zxsas+"</td>");
			tb.append("<td align='center' >"+zxjas+"</td>");
			tb.append("<td align='center' >"+zxwjs+"</td>");
			
			//差异
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','sa_zx')\" >"+zxsas_cy+"</td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','ja_zx')\" >"+zxjas_cy+"</td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','wj_zx')\" >"+zxwjs_cy+"</td>");
			
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','sa_sp')\" >"+spsas_cy+"</a></td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','ja_sp')\" >"+spjas_cy+"</a></td>");
			tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+dm+"','"+kssj+"','"+jssj+"','wj_sp')\" >"+spwjs_cy+"</a></td>");
			
			String kxd_sa = "-";
			String kxd_ja = "-";
			String kxd_wj = "-";
			if(zxsas > 0){
				kxd_sa = StringUtils.formatDouble((1-(zxsas_cy + spsas_cy)*1.0/zxsas)*100,"#0.00");
			}
			if(zxjas > 0){
				kxd_ja = StringUtils.formatDouble((1-(zxjas_cy + spjas_cy)*1.0/zxjas)*100,"#0.00");
			}
			if(zxwjs > 0){
				kxd_wj = StringUtils.formatDouble((1-(zxwjs_cy + spwjs_cy)*1.0/zxwjs)*100,"#0.00");
			}
			
			tb.append("<td align='center' >"+kxd_sa+"</td>");
			tb.append("<td align='center' >"+kxd_ja+"</td>");
			tb.append("<td align='center' >"+kxd_wj+"</td>");
			
		}else{
			tb.append("<td align='center' >"+fymap.get(dm)+"</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");   
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >0</td>");
			tb.append("<td align='center' >-</td>");
			tb.append("<td align='center' >-</td>");
			tb.append("<td align='center' >-</td>");
		}
		
    	tb.append("</tr>");
    	i++;
	}
	
	//合计
	tb.append("<tr class='table-row "+(i%2==0?"":"odd")+"'>");
	tb.append("<td align='center' colspan='2' >合计</td>");
	tb.append("<td align='center' >"+sum2+"</td>");
	tb.append("<td align='center' >"+sum3+"</td>");
	tb.append("<td align='center' >"+sum4+"</td>");
	tb.append("<td align='center' >"+sum6+"</td>");
	tb.append("<td align='center' >"+sum7+"</td>");
	tb.append("<td align='center' >"+sum8+"</td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','sa_zx')\" >"+sum10+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','ja_zx')\" >"+sum11+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','wj_zx')\" >"+sum12+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','sa_sp')\" >"+sum14+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','ja_sp')\" >"+sum15+"</a></td>");
	tb.append("<td align='center' ><a href='javascript:void(0);' onclick=\"doFc('"+fydm+"','"+kssj+"','"+jssj+"','wj_sp')\" >"+sum16+"</a></td>");
	
	String kxd_sa = "-";
	String kxd_ja = "-";
	String kxd_wj = "-";
	if(sum6 > 0){
		kxd_sa = StringUtils.formatDouble((1-(sum10 + sum14)*1.0/sum6)*100,"#0.00");
	}
	if(sum7 > 0){
		kxd_ja = StringUtils.formatDouble((1-(sum11 + sum15)*1.0/sum7)*100,"#0.00");
	}
	if(sum8 > 0){
		kxd_wj = StringUtils.formatDouble((1-(sum12 + sum16)*1.0/sum8)*100,"#0.00");
	}
	
	tb.append("<td align='center' >"+kxd_sa+"</td>");
	tb.append("<td align='center' >"+kxd_ja+"</td>");
	tb.append("<td align='center' >"+kxd_wj+"</td>");
	tb.append("</tr>");
	
	tb.append("</tbody>");
	tb.append("</table>");
	JSONObject json = new JSONObject();
    json.put("table", tb.toString());
    json.put("sj", sj);
    out.print(json);
%>