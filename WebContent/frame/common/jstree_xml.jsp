<?xml version="1.0" encoding="UTF-8"?>
<tree id="0">
<%@ page contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="tdh.frame.web.util.SpringBeanUtils" %>
<%@ page import="tdh.frame.xtgl.TRole" %>
<%@ page import="tdh.frame.system.TApp" %>
<%@page import="tdh.frame.xtgl.service.RightsService"%>
<%@page import="tdh.frame.system.service.CommonService"%>

<%
    String yydms = (String)session.getAttribute("yydm");
    RightsService service = (RightsService)SpringBeanUtils.getBean(request,"RightsService");	
	CommonService commonservice = (CommonService)SpringBeanUtils.getBean(request,"FrameCommonService");
		
	List<TApp> yydmList = commonservice.getAppDao().findAppByYydm(yydms);
	TApp t_app = new TApp();
	t_app.setAppid("COMM");
	t_app.setAppjc("通用角色");
	t_app.setAppmc("");
	t_app.setUrl("");
	yydmList.add(0,t_app);
	//删除没有角色的应用，如果某应用下面没有角色，则不显示该应用的名称
	commonservice.deleteAppHasNoRole(yydmList);
	for(TApp tapp:yydmList){
		out.println("<item id='yydm_"+tapp.getAppid()+"' text='"+tapp.getAppjc()+"' child='1' open='1'>");
		List<TRole> trolelist = service.getQxgljdbcdao().getRoleByYydm(tapp.getAppid());
		for(TRole role:trolelist){
        out.println("<item id='"+role.getJsdm()+"' text='"+role.getMc()+"'>");
        out.println("</item>");
    	}
    	out.println("</item>");
	}
 %>
 </tree>

