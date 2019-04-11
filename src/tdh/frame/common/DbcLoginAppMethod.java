package tdh.frame.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import tdh.dbc.bi22.DbcLoginConstant;
//import tdh.dbc.bi22.MasterLogin;

public class DbcLoginAppMethod implements IAppMethod {

	/**
	 * 获取访问的IP地址.
	 * @param request 
	 * @return
	 */
	 private String getIpAddr(HttpServletRequest request) {
			String ip = request.getHeader("x-forwarded-for");
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("WL-Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getRemoteAddr();
			}

			if (ip != null) {
				ip = ip.split(",")[0];
			}
			return ip;
   }
	  
	/**
	 * 扩展额外的登录信息.
	 */
	 public void appMethod(HttpServletRequest request,HttpServletResponse response){
		 
	 }
	/*public void appMethod(HttpServletRequest request) {
		//用于初始化bi2.2需要的登录信息
		HttpSession session = request.getSession();
		UserBean user = (UserBean)session.getAttribute("user");
		MasterLogin masterLogin = new MasterLogin(user.getYhdm(),user.getYhkl());
		masterLogin.setIp(getIpAddr(request));
		masterLogin.setFydm(user.getFy().getFjm());	//使用法院分级码
		session.setAttribute(DbcLoginConstant.LOGINED_WEBKEY, masterLogin);
	}*/
	
}
