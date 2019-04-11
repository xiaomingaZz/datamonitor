<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@page import="tdh.frame.web.context.WebAppContext"%>
<%@page import="tdh.framework.dao.springjdbc.JdbcTemplateExt"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="jxl.Workbook"%>
<%@ page import="jxl.write.WritableCellFormat"%>
<%@ page import="jxl.write.WritableFont"%>
<%@ page import="jxl.write.WritableSheet"%>
<%@ page import="jxl.write.WritableWorkbook"%>
<%@page import="jxl.format.Colour"%>
<%@page import="tdh.Constant"%>
<%
	response.setHeader("Cache-Control","no-cache");     
	response.setHeader("Pragma","no-cache");     
	response.setDateHeader("Expires", 0);
	String filename = "数据导出";

	out.clear();
	out = pageContext.pushBody();
	
	OutputStream sout = null;
	try{
		sout = response.getOutputStream();
		response.reset();
		response.setContentType("application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename="+ java.net.URLEncoder.encode(filename+".xls","UTF-8"));

		JdbcTemplateExt bi09 = WebAppContext.getBeanEx("BiJdbcTemplateExt");
		List<Map<String,Object>> fylist = bi09.queryForList("select DM_CITY DM,NAME_CITY MC from DM_CITY");
		Map<String,String> fymap = new HashMap<String,String>();
		for(Map<String,Object> map:fylist){
			fymap.put(map.get("DM").toString(),map.get("MC").toString());
		}
		
		String flag = StringUtils.trim(request.getParameter("flag"));
		String fydm = StringUtils.trim(request.getParameter("FYDM"));
		String kssj = StringUtils.trim(request.getParameter("kssj"));
		String jssj = StringUtils.trim(request.getParameter("jssj"));
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Map<String,Integer> vmap = new HashMap<String,Integer>();
		String fieldmc = "法院,案号,案件标识,立案日期,案由描述,当事人,结案日期";
		String field = "FYDM,AH,AHDM,LARQ,AYMS,DSR,JARQ";
		
		String dl = flag.split("_")[0];
		String fg = flag.split("_")[1];
		String table = "";
		if("sp".equals(fg)){
			table = "DB_CASE_"+dl.toUpperCase()+"_ND_CY";
		}else{
			table = "DB_ZX_"+dl.toUpperCase()+"_ND_CY";
		}
		String sql = "SELECT AHDM,AH,FYDM,LARQ,JARQ FROM "+table+" WHERE FYDM LIKE '"+fydm+"%'  ";
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
		
		sql += " AND " + Constant.fcmap.get(flag).replace("@kssj@",kssj).replace("@jssj@",jssj);
		
		sql += " order by FYDM,AH ";
		System.out.println("sql-->"+sql);
		list = bi09.queryForList(sql);
		
		
		//设置标题字体格式
 		WritableFont wf = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false);//设置写入字体 TIMES 10 加粗
		WritableCellFormat wcf = new WritableCellFormat(wf);//设置CellFormat 
		wcf.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf.setAlignment(jxl.format.Alignment.CENTRE);//水平对齐方式 居中
		wcf.setBackground(Colour.SKY_BLUE);
		//设置字体格式1
		WritableFont wf1 = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);//设置写入字体 TIMES 10 不加粗
		WritableCellFormat wcf1 = new WritableCellFormat(wf1);//设置CellFormat 
		wcf1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf1.setAlignment(jxl.format.Alignment.CENTRE);//水平对齐方式 居中
		wcf1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);//垂直对齐方式 居中
		//设置字体格式2
		WritableFont wf2 = new WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false);//设置写入字体 TIMES 10 不加粗
		WritableCellFormat wcf2 = new WritableCellFormat(wf2);//设置CellFormat 
		wcf2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		wcf2.setAlignment(jxl.format.Alignment.LEFT);//水平对齐方式 左对齐
		wcf2.setWrap(true);
		
		WritableWorkbook workbook = Workbook.createWorkbook(sout);
		
		try{
		  	int len = list.size();
		  	int pag = 60000;
		  	int index = len%pag==0?len/pag:len/pag+1;
		  	String[] mcs = fieldmc.split(",");
			String[] fields = field.split(",");
		  	for(int i=0;i<=index;i++){
		  		WritableSheet sheet = workbook.createSheet("数据导出"+i, i);
				sheet.setRowView(0,360);
				for(int j =0;j< mcs.length;j++){
					sheet.addCell(new jxl.write.Label(j, 0, mcs[j], wcf));
					if(j == 1){
						sheet.setColumnView(j,35);
					}else{
						sheet.setColumnView(j,25);
					}
				}
				int row=1;
		  		for(int k=i*pag;k<(i+1)*pag;k++){
		  			sheet.setRowView(row,360);
		  			if(k>=len){
		  				break;
		  			}
		  			Map<String,Object> map = list.get(k);
					for(int j=0;j<fields.length;j++){
						String fi = StringUtils.trim(fields[j]);
						if(fi.contains(".")){
							fi=fi.substring(fi.lastIndexOf("."));
						}
						String value = StringUtils.trim(map.get(fields[j]));
						if(fi.equals("FYDM")){
							value = fymap.get(value);
						}
						sheet.addCell(new jxl.write.Label(j, row, value, wcf2));
					}
					row++;
		  		}
		  	}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				if(workbook!=null){
					workbook.write();
					workbook.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(sout!=null){
			sout.flush();
			sout.close();
		}
		out.clear();
		out = pageContext.pushBody();
	}
%>
