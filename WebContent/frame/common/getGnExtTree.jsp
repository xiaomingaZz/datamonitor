<%@ page language="java"  pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="tdh.frame.web.util.*"%>
<%@ page import="tdh.frame.common.*"%>
<%@ page import="tdh.frame.system.*"%>
<%@page import="tdh.frame.system.service.CommonService"%>
<%@page import="tdh.frame.xtgl.service.RightsService"%>
<%
  String mkdm = UtilComm.trim(request.getParameter("gndm"));
  CommonService service = (CommonService) SpringBeanUtils.getBean(request, "FrameCommonService");
  
  UserBean user = (UserBean) session.getAttribute("user");
  RightsService rightService = (RightsService)SpringBeanUtils.getBean(request,"RightsService");
  //List<TModule> listm = rightService.uTree(request, user.getFy().getFydm(), user.getYhdm(), "showsy");
  List<TModule> listm = (List<TModule>)session.getAttribute("listm");
  if(listm == null){
  	listm = rightService.uTree(request, user.getFy().getFydm(), user.getYhdm(), "showsy");
  	session.setAttribute("listm",listm);
  }
  for (TModule tm : listm) {
    if (mkdm.equals(tm.getGndm())) {
      //System.out.println(service.convertTModuleJson(tm.getChildList(), true));
      out.println(service.convertTModuleJson(tm.getChildList(), true));
      break;
  }
 }
%>