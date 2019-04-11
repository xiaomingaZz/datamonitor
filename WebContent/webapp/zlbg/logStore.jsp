<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%@page import="tdh.util.*" %>
<%@page import="tdh.tr.*" %>
<%
	//String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	//cxsj1 = cxsj1.replace("-","");
	//String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
	//cxsj2 = cxsj2.replace("-","");
	String id=StringUtils.trim(request.getParameter("id"));
	if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
	JSONArray  ja=new JSONArray();
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select BH,GZMS from TR_GZ order by BH ";

	StringBuffer sb=new StringBuffer();
	List<GzBean> list = new ArrayList<GzBean>();
	
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st=conn.createStatement();
		rs=st.executeQuery(sql);
		while(rs.next()){
			GzBean bean = new GzBean();
			bean.setBh(rs.getInt("BH"));
			bean.setGzms(rs.getString("GZMS"));
			list.add(bean);
		}
		StringBuilder query = new StringBuilder();
		query.append("select ");
		for(int i = 1 ; i <= 40 ; i++){
			query.append("sum(convert(int,FLAG").append(MyUtils.numToStr(String.valueOf(i),2));
			query.append(")) as CNT"+i);
			if(i < 40) query.append(",");
		}
		query.append(" from TR_DD where  XMLTYPE='ASS' AND ISNULL(DEL,'')<>'1' AND JYZT='1' and ZT='4' ");
		query.append(" AND FY like '"+id+"%'");
		//System.out.println(query.toString());
		rs = st.executeQuery(query.toString());
		Map<String,Integer> data = new HashMap<String,Integer>();
		if(rs.next()){
			for(int i = 1; i <=40 ; i++){
				data.put(String.valueOf(i),rs.getInt("CNT"+i));
			}
		}
		
		for(GzBean bean : list){
				
			
				JSONObject jo=new JSONObject();
				
				jo.put("MS", bean.getGzms());
				jo.put("BH", bean.getBh());
	
				jo.put("F",data.get(String.valueOf(bean.getBh()))==null?0:data.get(String.valueOf(bean.getBh())) );
				ja.add(jo);
		}
		
	
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	JSONObject json=new JSONObject();
	json.put("root", ja.toString());//记录数据项
	json.put("totalCount", list.size());//总记录数
	out.print(json);
%>
