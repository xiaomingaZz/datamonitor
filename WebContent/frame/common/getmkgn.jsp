<%
  out.println("<?xml version='1.0' encoding='utf-8'?>");
  out.println("<tree id='0'>");
%>
<%@ page language="java" contentType="text/xml;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="tdh.frame.web.util.*"%>
<%@ page import="tdh.frame.common.*"%>
<%@ page import="tdh.frame.system.*"%>
<%@page import="tdh.frame.system.service.CommonService"%>
<%@page import="tdh.frame.xtgl.service.RightsService"%>
<%
  String mkdm = UtilComm.trim(request.getParameter("mkdm"));
  CommonService service = (CommonService) SpringBeanUtils.getBean(request, "FrameCommonService");
  
  UserBean user = (UserBean) session.getAttribute("user");
  RightsService rightService = (RightsService)SpringBeanUtils.getBean(request,"RightsService");
  List<TModule> listm = rightService.uTree(request, user.getFy().getFydm(), user.getYhdm(), "showsy");
  for (TModule tm : listm) {
    if (mkdm.equals(tm.getGndm())) {
      out.println(service.convertTModuleXML(tm.getChildList(), true));
      break;
    }
  }
  out.println("</tree>");
%>