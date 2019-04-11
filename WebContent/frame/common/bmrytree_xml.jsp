<?xml version="1.0" encoding="UTF-8"?>
<%

/*
*构建部门人员树
*type=init 被设置用户szyh.jsp  用户授权管理 yhsqgl.jsp调用
*type=child 被设置用户szyh.jsp  用户授权管理 yhsqgl.jsp调用
*
*/
/**
2010-08-27修改订正部门也会被当做人员添加的情况 增加对 userdata isfy 的判断
*/
String type = request.getParameter("type");
String yhbm = request.getParameter("yhbm");
String yhzw = request.getParameter("yhzw");
String id = request.getParameter("id");


UserBean user = (UserBean) session.getAttribute("user");
String fydm = user.getFy().getFydm();
if(type==null){
    type = "init";
}

if(type.equals("init")){
    out.println("<tree id=\"0\">");
}else if(type.equals("child")){
    out.println("<tree id='"+id+"' >");
}


if(yhbm==null){
    yhbm = "";
}
if(yhzw==null){
    yhzw = "";
}
%>
<%@ page import="tdh.frame.xtgl.service.RightsService"%>
<%@ page import="tdh.frame.web.util.SpringBeanUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="tdh.frame.common.*" %>
<%@ page import="tdh.frame.xtgl.TDepart" %>
<%@ page import="tdh.frame.xtgl.dao.TDepartDAO"%>
<%@ page import="tdh.frame.system.dao.TsBzdmDao"%>
<%@ page import="tdh.frame.system.dao.TUserDAO"%>
<%@ page import="tdh.frame.system.TUser"%>
<%@ page import="tdh.frame.system.TsBzdm"%>
<%

Map<String,TsBzdm> mapyhzw = null;

TsBzdmDao bzdm = (TsBzdmDao) SpringBeanUtils.getBean(request,"FrameTsBzdmDao");
TDepartDAO deDao = (TDepartDAO) SpringBeanUtils.getBean(request,"TDepartDAO");

mapyhzw = bzdm.findByKindMap("00081");

String tj = "";
String tj2 = "";
if(!yhzw.equals("")&&!yhzw.equals("-1")){
    tj += " and yhzw='"+yhzw+"'";
    tj2 += " and YHZW='"+yhzw+"'";
}
if(!yhbm.equals("")&&!yhbm.equals("-1")){
    tj += " and yhbm='"+yhbm+"'";
    tj2 += " and YHBM='"+yhbm+"'";
}

if(tj.length()>0){
    tj = tj.substring(4);
    tj2 = tj2.substring(4);
}
TUserDAO  usDao = (TUserDAO) SpringBeanUtils.getBean(request,"TUserDAO");
List<TUser> uslist = null;

RightsService serv = (RightsService)SpringBeanUtils.getBean(request,"RightsService");
Map<String,Integer>  map = serv.getQxgljdbcdao().bmRys(fydm,tj2);

    List<TDepart> delist = null;
    if(yhbm.trim().equals("")||yhbm.equals("-1")){
        delist = deDao.findBySingleFy(fydm," order by bmdm",true);

    }else {
        delist = new ArrayList<TDepart>();
        delist.add(deDao.findById(yhbm));
    }
    for(TDepart dep:delist){
        if(map.get(dep.getBmdm())!=null&&map.get(dep.getBmdm())>0){
        
        out.println("<item id='dept"+dep.getBmdm()+"' text='"+dep.getBmmc()+"' child='1' >");
        out.println("<userdata name=\"isry\">0</userdata>");

		if(tj.length()==0){
		    String hql = "from TUser a where yhbm='"+dep.getBmdm()+"' and (sfjy<>'1' or sfjy is null)";
		    Object[] obj = {};
		    uslist = usDao.findByHql(hql,obj);
		}else {
		    String hql = "from TUser a where yhbm='"+dep.getBmdm()+"' and "+tj+" and (sfjy<>'1' or sfjy is null) ";
		    Object[] obj = {};
		    uslist = usDao.findByHql(hql,obj);
		}
			
	    for(TUser u:uslist){	    
		    out.println("<item id='"+u.getYhdm()+"' text='"+u.getYhxm()+"' >");
		    out.println("<userdata name=\"isry\">1</userdata>");
		    out.println("<userdata name=\"yhzw\">");
		    if(mapyhzw.containsKey(u.getYhzw())){
		      out.println(mapyhzw.get(u.getYhzw()).getMc());
		    }
		    out.println("</userdata>");
		    out.println("</item>");
	    }

        out.println("</item>");
        }
    }
out.println("</tree>");    
%> 
