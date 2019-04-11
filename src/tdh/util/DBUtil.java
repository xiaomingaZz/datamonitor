package tdh.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import tdh.frame.web.context.WebAppContext;

public class DBUtil {
	
	
	/**
	 * 获取前置交换库的连接XDB
	 * @return
	 */
	 public static Connection getXdbConnection(){
		 return getPropertiesFileDBConnection("xdb");
	 }
	 
	 /**
	  * 获取华宇的接口日志库连接TDH
	  * @return
	  */
	 public static Connection getExpLogConnection(){
		 return getPropertiesFileDBConnection("log");
	 }
	 
	 public static Connection getPropertiesFileDBConnection(String name){
		 String configFile = WebAppContext.getServletContextEx().getRealPath("/")
			+ "WEB-INF/config/jdbc.properties";
		Properties p = new Properties();
		String driver = "", url = "", user = "", password = "";
		Connection conn = null;
		InputStream in = null;
		try {
			in = new FileInputStream(configFile);
			p.load(in);
			driver = p.getProperty(name+".driverClassName");
			url = p.getProperty(name+".url");
			user = p.getProperty(name+".username");
			password = p.getProperty(name+".password");
			Class.forName(driver);
			conn = DriverManager.getConnection(url, user, password);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(in!=null)
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return conn;
	 }
	
	  /**
	   * 关闭数据库资源.
	   * @param conn Connection
	   * @param pstmt PreparedStatement
	   * @param st Statement
	   * @param rs ResultSet
	   * 如果部分资源不存在，传入null
	   */
	  public static void close(Connection conn , PreparedStatement pstmt, Statement st, ResultSet rs) {
	    closeRs(rs);
	    closePst(pstmt);
	    closeSt(st);
	    closeConn(conn);
	  }
	  
	  public static void closeConn(Connection conn) {
	    try {
	      if (conn != null && !conn.isClosed()) {
	        conn.close();
	        conn = null;
	      }
	    } catch (Exception e) {
	    		e.printStackTrace();
	    }
	  }
	  
	  public static void closeSt(Statement st) {
	    try {
	      if (st != null) {
	        st.close();
	        st = null;
	      }
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	  }
	  
	  public static void closePst(PreparedStatement pstmt) {
	    try {
	      if (pstmt != null) {
	        pstmt.close();
	        pstmt = null;
	      }
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	  }
	  
	  public static void closeRs(ResultSet rs) {
	    try {
	      if (rs != null) {
	        rs.close();
	        rs = null;
	      }
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	  }
}
