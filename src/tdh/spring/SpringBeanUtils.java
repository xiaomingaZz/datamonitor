/**   
 * 文件名：SpringBeanUtils.java   
 *   
 * 版本信息：  1.0
 * 日期：2011-9-14   
 * Copyright  Corporation 2011    
 * 版权所有   南京通达海思远软件有限公司
 * 作者：施健伟
 */
package tdh.spring;

import java.sql.Connection;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.web.context.support.WebApplicationContextUtils;

public final class SpringBeanUtils {

	private SpringBeanUtils(){};
	
	
	public static Object getBean(ServletContext context, String beanName) {
		return WebApplicationContextUtils.getRequiredWebApplicationContext(
				context).getBean(beanName);
	}
	
	public static Object getBean(HttpSession session,String beanName) {
		return getBean(session.getServletContext(),beanName);
	}	
	
	public static Object getBean(HttpServletRequest request,String beanName) {
		return getBean(request.getSession(),beanName);
	}
	
	public static DataSource getDataSource(ServletContext context,String datasourceName){
		return (DataSource) getBean(context,datasourceName);
	}
	
	public static DataSource getDataSource(HttpSession session,String datasourceName){
		return (DataSource) getBean(session,datasourceName);
	}
	
	public static DataSource getDataSource(HttpServletRequest request,String datasourceName){
		return (DataSource) getBean(request,datasourceName);
	}
	
	public static Connection getConnection(ServletContext context,String datasourceName){
		return DataSourceUtils.getConnection((DataSource) getBean(context,
				datasourceName));
	}
	
	public static Connection getConnection(HttpSession session,String datasourceName){
		return DataSourceUtils.getConnection((DataSource) getBean(session,
				datasourceName));
	}
	
	public static Connection getConnection(HttpServletRequest request,String datasourceName){
		return DataSourceUtils.getConnection((DataSource) getBean(request,
				datasourceName));
	}
		
}
