package tdh.spring;

import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.support.WebApplicationContextUtils;


public class SpringContextHolder implements ApplicationContextAware {
	
	private static final Log log = LogFactory.getLog(SpringContextHolder.class);
	
	private static ServletContext  webcxt;
	
	private static ApplicationContext appcxt;
	
	public static void initContext(ServletContext sc){
		webcxt = sc;
	}

	public static ServletContext getWebcxt() {
		return webcxt;
	}
	
	public static ApplicationContext getAppcxt() {
		return appcxt;
	}
	public void setWebcxt(ServletContext webcxt1) {
		webcxt = webcxt1;
	}

	
	public void setApplicationContext(ApplicationContext cxt1)
			throws BeansException {
		appcxt = cxt1;
	}
	
    public static  Object getBean(String beanName){
    	return WebApplicationContextUtils.getRequiredWebApplicationContext(
    			webcxt).getBean(beanName);
    }
    
    public static DataSource getDatasource(String datasouceName ){
    	return (DataSource)getBean(datasouceName);
    }
    
    public static Connection  getConnection(String datasouceName){
    	DataSource source = getDatasource(datasouceName);
    	if(source!=null){
    		try {
				return source.getConnection();
			} catch (SQLException e) {
				log.error("--->>>>获取数据库练级失败!"+datasouceName,e);
				return null;
			}
    	}else{
    		log.error("--->>>>指定的数据源不存在!"+datasouceName);
    		return null;
    	}
    }
}
