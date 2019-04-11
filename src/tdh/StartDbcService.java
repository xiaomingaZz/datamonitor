package tdh;

import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import tdh.util.ConsoleWirter;
import tdh.util.MyUtils;
import tdh.frame.common.DBUtils;
import tdh.frame.web.context.WebAppContext;
import tdh.framework.util.StringUtils;
import tdh.spring.SpringContextHolder;

public class StartDbcService implements ServletContextListener{

	public void contextDestroyed(ServletContextEvent event) {
		ConsoleWirter.info("服务器已关闭!");
	}

	public void contextInitialized(ServletContextEvent event) {
		SpringContextHolder.initContext(event.getServletContext());
		Constant.fjm = event.getServletContext().getInitParameter("FJM");
		Constant.fymc = event.getServletContext().getInitParameter("FYMC");
		Constant.dqmc = event.getServletContext().getInitParameter("DQMC");
		System.out.println("数据监控范围："+Constant.fjm+"|"+Constant.fymc+"|"+Constant.dqmc);
		loadFjmMap();
		loadFcConfig(event);
		loadXfFcConfig(event);
	}

	public void loadFcConfig(ServletContextEvent event){
		String configFile = event.getServletContext().getRealPath("/")
		+"/WEB-INF/config/fc.properties";
		Properties properties = new Properties(); 
		try {
			properties.load(new FileInputStream(configFile));
			for(Object obj : properties.keySet()){
				Constant.fcmap.put(StringUtils.trim(obj), StringUtils.trim(properties.getProperty(StringUtils.trim(obj))));
			}
		} catch (Exception e) {
			try {
				ConsoleWirter.error("加载服务配置文件失败："+configFile, e);
			} catch (Throwable e1) {
				e1.printStackTrace();
			}
		}
	}
	
	public void loadXfFcConfig(ServletContextEvent event){
		String configFile = event.getServletContext().getRealPath("/")
		+"/WEB-INF/config/fc_xf.properties";
		Properties properties = new Properties(); 
		try {
			properties.load(new FileInputStream(configFile));
			for(Object obj : properties.keySet()){
				Constant.xfFcMap.put(StringUtils.trim(obj), StringUtils.trim(properties.getProperty(StringUtils.trim(obj))));
			}
		} catch (Exception e) {
			try {
				ConsoleWirter.error("加载服务配置文件失败："+configFile, e);
			} catch (Throwable e1) {
				e1.printStackTrace();
			}
		}
	}
	
	public void loadFjmMap(){
		Connection conn = null;
		Statement st = null;
		ResultSet rs = null;
		try{
			conn = WebAppContext.getNewConn("HbsjjzdataSource");
			st = conn.createStatement();
			rs = st.executeQuery("select FJM,FYMC,DM from TS_FYMC where FJM like '"+Constant.fjm.substring(0,1)+"%'");
			while(rs.next()){
				Constant.fjmMap.put(rs.getString("FJM"),rs.getString("FYMC"));
				Constant.fyDMtoFjmMap.put(MyUtils.numToStr(rs.getString("DM"),4),rs.getString("FJM"));
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtils.close(conn, st, rs);
		}
	}

}
