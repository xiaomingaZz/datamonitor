package tdh.frame.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import tdh.frame.system.TApp;
import tdh.frame.system.TModule;
import tdh.frame.system.TUser;
import tdh.frame.system.TsFymc;
import tdh.frame.system.dao.TModuleDao;
import tdh.frame.system.service.CommonService;
import tdh.frame.system.service.TUserService;
import tdh.frame.web.context.WebAppContext;
import tdh.frame.web.context.WebConfig;
import tdh.frame.web.log.Logger;
import tdh.frame.web.util.SpringBeanUtils;
import tdh.frame.web.util.StringUtils;
import tdh.frame.web.util.TDHSecurity;
import tdh.frame.web.xml.XMLDocument;
import tdh.frame.web.xml.XMLNode;
import tdh.frame.xtgl.TDepart;
import tdh.frame.xtgl.TRole;
import tdh.frame.xtgl.TRoleAuth;
import tdh.frame.xtgl.TUserAuth;
import tdh.frame.xtgl.TUserRole;
import tdh.frame.xtgl.TsDm;
import tdh.frame.xtgl.TsDmId;
import tdh.frame.xtgl.dao.QxglJdbcDAO;
import tdh.frame.xtgl.dao.TRoleDAO;
import tdh.frame.xtgl.dao.TUserAuthDAO;
import tdh.frame.xtgl.dao.TUserRoleDAO;
import tdh.frame.xtgl.dao.TsDmDAO;
import tdh.frame.xtgl.service.TDepartService;
import tdh.security.lic.License;

/**
 * @author 施健伟 2010-6-23 登陆Servlet.
 */
public class LoginServlet extends HttpServlet implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static String License_FRAME_Product = "FRAME";

	/**
	 * 
	 */
	//private static final long serialVersionUID = 6517408833364872338L;
	/**
	 * The doGet method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to
	 * post.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 用户的账号
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("text/html; charset=UTF-8");
		String fydm = request.getParameter("fydm");

		PrintWriter pw = response.getWriter();
		License license = (License) request.getSession().getServletContext()
				.getAttribute(License.WEB_KEY);
		String allfydm = license.getEndUserDecode();
		if (allfydm.indexOf(fydm) == -1) {
			pw.println("<script>");
			pw.println("alert(\" 该法院没有被授权!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		}
		
		String j_username = request.getParameter("yhid");
		String yhdm = fydm + j_username;
		// 用户的密码
		String j_password = request.getParameter("yhkl");
		// 记住用户
		String j_rememberName = request.getParameter("rememberMe");
		
		if("true".equals(j_rememberName))  j_rememberName ="no";
		
		/**
		 * 以下部分判断是否授权的法院系统管理员 if FYDM=j_username then {}
		 */
		if ("admin".equals(j_username)) { //取消大小写
			// check password
			TsDmDAO dao = (TsDmDAO) SpringBeanUtils.getBean(request,
					"FrameTsDmDao");
			TsDm dm = dao.findById(new TsDmId("法院客户", fydm));
			if (dm == null) {
				pw.println("<script>");
				pw.println("alert(\"该法院管理员账号没有被授权!\");");
				pw.println("window.history.back();");
				pw.println("</script>");
				return;
			}
			String yhkl = TDHSecurity.convPass(j_username, j_password, 1);
			if (yhkl.equals(dm.getMc())) {
				initNormalAdmin(fydm, yhdm, request);
				//保存账号
				if ("on".equals(j_rememberName)) {
					Cookie cookie = new Cookie("tdhyhid_spjx", UtilComm
							.encodeURI(j_username));
					cookie.setMaxAge(365 * 24 * 60 * 60);
					response.addCookie(cookie);
					cookie = new Cookie("tdhfydm_spjx", UtilComm.encodeURI(fydm));
					cookie.setMaxAge(365 * 24 * 60 * 60);
					response.addCookie(cookie);
					cookie = new Cookie("rememberName_spjx", "yes");
					cookie.setMaxAge(365 * 24 * 60 * 60);
					response.addCookie(cookie);
					
					cookie = new Cookie("tdhyhkl_spjx", UtilComm
							.encodeURI(j_password));
					cookie.setMaxAge(365 * 24 * 60 * 60);
					response.addCookie(cookie);
					
				} else {
					response.addCookie(new Cookie("tdhyhid_spjx", ""));
					response.addCookie(new Cookie("tdhfydm_spjx", ""));
					response.addCookie(new Cookie("tdhyhkl_spjx", ""));
					response.addCookie(new Cookie("rememberName_spjx", ""));
				}
				
				parseAuthApp(request);
				loginSuccess(response, request);
			} else {
				pw.println("<script>");
				pw.println("alert(\"您的用户密码不正确,请确认!\");");
				pw.println("window.history.back();");
				pw.println("</script>");
			}
			return;
		}

		// String _spring_security_remember_me =
		// request.getParameter("_spring_security_remember_me");
		TUserService service = (TUserService) SpringBeanUtils.getBean(request,
				"TUserService");
		//修改为使用登录单位和登录帐号来查找用户信息

		WebConfig conf = (WebConfig) request.getSession().getServletContext()
				.getAttribute(WebConfig.WEBKEY);

		TUser tUser = null;
		if ("rygh".equals(conf.getLoginType())) {
			//按人员工号查找用户信息
			tUser = service.findTUserByRygh(fydm, j_username);
		} else {
			tUser = service.findTUserByFydmYhid(fydm, j_username);
		}

		if (tUser == null) {
			pw.println("<script>");
			pw.println("alert(\"该用户不存在,请联系系统管理员!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		}
		if ("1".equals(tUser.getSfjy())) {
			pw.println("<script>");
			pw.println("alert(\"该用户已禁用,请联系系统管理员!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		}
		if (tUser.getDwdm() == null || tUser.getDwdm().trim().equals("")
				|| tUser.getYhbm() == null || tUser.getYhbm().trim().equals("")) {
			pw.println("<script>");
			pw.println("alert(\"该用户异常,请联系系统管理!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		}

		if ("1".equals(tUser.getSfjy())) {
			pw.println("<script>");
			pw.println("alert(\"该人员已禁用,请联系系统管理员!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		}

		String yhkl = TDHSecurity.convPass(tUser.getYhid(), j_password, 1);
		if (!(yhkl.equals(tUser.getYhkl()) /*|| j_password.equals(StringUtils.decodeBase64(key))*/)) {
			pw.println("<script>");
			pw.println("alert(\"您的用户密码不正确,请确认!\");");
			pw.println("window.history.back();");
			pw.println("</script>");
			return;
		} else {
			response.setHeader("sso", "success");
			initSession(tUser, request, "1");
			//保存账号
			if ("on".equals(j_rememberName)) {
				Cookie cookie = new Cookie("tdhyhid_spjx", UtilComm
						.encodeURI(j_username));
				cookie.setMaxAge(365 * 24 * 60 * 60);
				response.addCookie(cookie);
				cookie = new Cookie("tdhfydm_spjx", UtilComm.encodeURI(fydm));
				cookie.setMaxAge(365 * 24 * 60 * 60);
				response.addCookie(cookie);
				cookie = new Cookie("rememberName_spjx", "yes");
				cookie.setMaxAge(365 * 24 * 60 * 60);
				response.addCookie(cookie);
				
				cookie = new Cookie("tdhyhkl_spjx", UtilComm
						.encodeURI(j_password));
				cookie.setMaxAge(365 * 24 * 60 * 60);
				response.addCookie(cookie);
				
			} else {
				response.addCookie(new Cookie("tdhyhid_spjx", ""));
				response.addCookie(new Cookie("tdhfydm_spjx", ""));
				response.addCookie(new Cookie("tdhyhkl_spjx", ""));
				response.addCookie(new Cookie("rememberName_spjx", ""));
			}
			
			 //保存密码
		    if("on".equals(j_rememberName)){
		    	Cookie cookie = new Cookie("tdhyhkl_spjx", UtilComm.encodeURI(j_password));
		        cookie.setMaxAge(365*24*60*60);
		        response.addCookie(cookie);
		        cookie = new Cookie("rememberPass_spjx", "yes");
		        cookie.setMaxAge(365*24*60*60);
		        response.addCookie(cookie);
		    }else{
		    	response.addCookie(new Cookie("tdhyhkl_spjx", ""));
		    	response.addCookie(new Cookie("rememberPass_spjx", ""));
		    }
			loginSuccess(response, request);
			parseAuthApp(request);
		}

	}

	/**
	 * 解析授权的应用
	 */
	public void parseAuthApp(HttpServletRequest request) {
		
		StringBuffer sb = new StringBuffer();
		List<TApp> app_list = new ArrayList<TApp>();
		
		request.getSession().setAttribute("syfs", "0");

		TApp tapp = new TApp();
		tapp.setAppid("COMM");
		tapp.setAppjc("基础功能");
		tapp.setAppmc("基础功能");
		app_list.add(0, tapp);
		
		TApp tapp1 = new TApp();
		tapp1.setAppid("GJKH");
		tapp1.setAppjc("干警考核");
		tapp1.setAppmc("干警考核系统");
		app_list.add(tapp1);
		
		sb.append("GJKH");
		
		request.getSession().setAttribute("yydm", sb.toString());
		request.getSession().setAttribute("app_list", app_list);
	}

	/**
	 * 设置Session 对象.
	 * 
	 * @param tUser
	 *            T_USER
	 * @param session
	 *            会话对象.
	 * @see tdh.frame.context.WebSessionAttrbuteBindingListener
	 */
	public void initSession(TUser tUser, HttpServletRequest request, String type) {
		UserBean bean = new UserBean();
		bean.setYhdm(tUser.getYhdm()); // 用户代码 = 单位代码 + 用户账号
		bean.setYhid(tUser.getYhid()); // 用户账号
		bean.setLoginIp(request.getRemoteAddr()); // 登录的IP
		bean.setLoginTime(new Date()); // 登录的时间
		bean.setYhxm(tUser.getYhxm()); // 用户姓名
		bean.setGxbm(tUser.getGxbm());
		CommonService service = (CommonService) SpringBeanUtils.getBean(
				request, "FrameCommonService");
		TsFymc fy = service.getFymc(tUser.getDwdm());
		bean.setFy(fy); // 单位信息.
		TDepartService dService = (TDepartService) SpringBeanUtils.getBean(
				request, "TDepartService");
		try {
			bean.setDepart(dService.findTDepartById(tUser.getYhbm()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		HttpSession session = request.getSession(true);
		bean.setYhqx(initYhqx(bean, request));
		bean.setYhjs(initYhjs(bean, request));

		// 使用到yhjs和gxbm
		bean.setCxjbfx(initPortalShowCxjb(bean, request));

		bean.setFydm(tUser.getDwdm());
		bean.setYhkl(request.getParameter("j_password"));
		//add 增加Rygh 持久信息 2013-4-22
		bean.setRygh(tUser.getRygh());

		session.setAttribute("user", bean);
		if ("1".equals(type)) {
			IAppMethod appmethod = (IAppMethod) SpringBeanUtils.getBean(
					request, this.getInitParameter("AppMethod"));
			
		}
	}

	public void initSuperAdmin(String j_username, HttpServletRequest request) {
		HttpSession session = request.getSession(true);
		UserBean bean = new UserBean();
		bean.setYhdm(j_username);
		bean.setYhxm("通达海超级管理员");
		session.setAttribute("user", bean);
	}

	public void initNormalAdmin(String fydm, String j_username,
			HttpServletRequest request) {
		HttpSession session = request.getSession(true);
		UserBean bean = new UserBean();
		bean.setYhdm(j_username); // 用户代码 = 单位代码 + 用户账号 //bug酱,第3次
		bean.setYhid(j_username.substring(6)); // 用户账号
		bean.setLoginIp(request.getRemoteAddr()); // 登录的IP
		bean.setLoginTime(new Date()); // 登录的时间
		bean.setYhxm("系统管理员"); // 用户姓名
		CommonService service = (CommonService) SpringBeanUtils.getBean(
				request, "FrameCommonService");
		TsFymc fy = service.getFymc(fydm);
		bean.setFy(fy); // 单位信息.
		//调整一下admin 登录时候需要取fydm的问题
		bean.setFydm(fy.getFydm());

		TDepart depart = new TDepart();
		depart.setBmmc("");
		bean.setDepart(depart);
		session.setAttribute("user", bean);
	}

	/**
	 * 初始化用户的权限串信息.
	 * 
	 * @param yhdm
	 */
	public String initYhqx(UserBean user, HttpServletRequest request) {
		StringBuffer sb = new StringBuffer();
		// 获取用户权限
		TUserAuthDAO uaDao = (TUserAuthDAO) SpringBeanUtils.getBean(request,
				"TUserAuthDAO");
		List<TUserAuth> uaList = uaDao
				.findByHql("from TUserAuth where id.yhdm='" + user.getYhdm()
						+ "'");
		if (uaList.size() > 0) {
			sb.append("/");
		}
		for (TUserAuth auth : uaList) {
			sb.append(auth.getId().getGndm());
			if (auth.getFlag() != null && !auth.getFlag().trim().equals("")) {
				sb.append("_" + auth.getFlag());
			}
			sb.append("/");
		}
		if (sb.length() == 0) {
			sb.append("/");
		}
		Map<String, TModule> moduleMap = new HashMap<String, TModule>();
		TRoleDAO roleDao = (TRoleDAO) SpringBeanUtils.getBean(request,
				"TRoleDAO");
		// 获取角色权限
		QxglJdbcDAO raDao = (QxglJdbcDAO) SpringBeanUtils.getBean(request,
				"QxglJdbcDAO");
		List<TRole> roleList = roleDao.getUserRoleList(user.getYhdm());
		if (roleList.size() > 0) {
			TModuleDao tmdao = (TModuleDao) SpringBeanUtils.getBean(request,
					"TModuleDao");
			List<TModule> mlist = tmdao.findAll();
			for (TModule tm : mlist) {
				moduleMap.put(tm.getGndm(), tm);
			}
		}
		for (TRole role : roleList) {
			List<TRoleAuth> raList = raDao
					.getBySql("select * from T_ROLEAUTH a where a.FYDM='"
							+ user.getFy().getFydm() + "' and a.JSDM = '"
							+ role.getJsdm() + "'");
			int size = raList.size();
			String jsflag = role.getFlag();
			if (size > 0) {
				for (TRoleAuth ruth : raList) {
					String auStr = ruth.getId().getGndm();
					if (ruth.getFlag() != null
							&& !ruth.getFlag().trim().equals("")) {
						auStr += "_" + ruth.getFlag();
					} else { // 如果没有范围,且为各案功能从角色获取
						TModule tm = moduleMap.get(auStr);
						if (tm != null) {
							if ("2".equals(tm.getLb())) {
								//修正BUG
								if (!"".equals(UtilComm.trim(jsflag))) {
									auStr += "_" + jsflag;
								}
							}
						}
					}
					if (sb.indexOf("/" + auStr + "/") < 0) {
						sb.append(auStr);
						sb.append("/");
					}
				}
			}
		}
		return sb.toString();
	}

	/**
	 * 初始化用户的角色信息.
	 * 
	 * @param yhdm
	 */
	public String initYhjs(UserBean user, HttpServletRequest request) {
		StringBuffer sb = new StringBuffer();
		TUserRoleDAO urDao = (TUserRoleDAO) SpringBeanUtils.getBean(request,
				"TUserRoleDAO");
		List<TUserRole> urList = urDao
				.findByHql("from TUserRole where id.yhdm='" + user.getYhdm()
						+ "'");
		if (urList.size() > 0) {
			sb.append("/");
		}
		for (TUserRole uRole : urList) {
			sb.append(uRole.getId().getJsdm());
			sb.append("/");
		}
		return sb.toString();
	}

	/**
	 * 初始化门户频道中的查看等级
	 * @param user
	 * @param request
	 * @return
	 */
	public String initPortalShowCxjb(UserBean user, HttpServletRequest request) {
		String cxjb = "";
		String yhjs = UtilComm.trim(user.getYhjs());
		String gxbm = UtilComm.trim(user.getGxbm());

		yhjs = yhjs.toLowerCase();
		if ((yhjs.indexOf("/qyyz/") >= 0) || (yhjs.indexOf("/qyfyz/") >= 0)
				|| (yhjs.indexOf("/qyajgl/") >= 0)) {
			cxjb = "1";
		} else if (gxbm.length() > 6 && yhjs.indexOf("/gxbmaj/") >= 0) {
			cxjb = "2";
		} else if ((yhjs.indexOf("/bm1ldfz/") >= 0)
				|| (yhjs.indexOf("/bm1ldzz/") >= 0)
				|| (yhjs.indexOf("/bmnq/") >= 0)) {
			cxjb = "3";
		} else {
			cxjb = "4";
		}
		return cxjb;
	}

	/**
	 * 成功登录后进入系统首页面.
	 * @param response
	 * @param request
	 * @throws IOException
	 */
	public void loginSuccess(HttpServletResponse response,
			HttpServletRequest request) throws IOException {

		WebConfig conf = (WebConfig) request.getSession().getServletContext()
				.getAttribute(WebConfig.WEBKEY);
		if (conf.isLog()) {
			Log2DB(request);
		}
		String url = "courtext.jsp";
		
		PrintWriter pw = response.getWriter();
		pw.print("<script>window.location='" + url + "'</script>");
	}

	/**
	 * 记载对应的日志信息到TU_XTJK表内.
	 * @param request 
	 */
	public void Log2DB(HttpServletRequest request) {
		Connection conn = null;
		PreparedStatement pst = null;
		String beiz = "";
		try {
			UserBean user = (UserBean) request.getSession()
					.getAttribute("user");
			if (user.isAdmin()) {
				beiz = "管理员(选定)";
			}
			conn = WebAppContext.getFrameConn();
			pst = conn
					.prepareStatement("insert into TU_XTJK(YHDM,JRSJ,IP,CZLX,YYDM,BEIZ,FYDM) values(?,getdate(),?,?,?,?,?)");
			pst.setString(1, user.getYhdm());
			pst.setString(2, this.getIpAddr(request));//WebAppContext.getUserIpAddr());
			pst.setString(3, "登录");
			pst.setString(4, WebAppContext.getAppIDEx());
			pst.setString(5, beiz);
			pst.setString(6, user.getFydm());
			pst.executeUpdate();
			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
		} finally {
			DBUtils.closeStatement(pst);
			DBUtils.closeConnection(conn);
		}
	}
	
	/**
	** 获取客户端IP值
	** 2014.05.27
	**/
	private String getIpAddr(HttpServletRequest request) { 
		String ip = request.getHeader("x-forwarded-for"); 
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getHeader("Proxy-Client-IP"); 
		}else {
			if(ip.contains(",")){//"x-forwarded-for"存在多个IP，取第一个非unkown的IP值
				String[] ipArr = ip.split("\\,");
				for(String str : ipArr){
					if(str != null && str.length() > 0 && !"unknown".equalsIgnoreCase(str.trim())) { 
						ip = str;
						break;
					}
				}
			}
		}
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getHeader("WL-Proxy-Client-IP"); 
		} 
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) { 
			ip = request.getRemoteAddr(); 
		} 
		return ip; 
	} 
}
