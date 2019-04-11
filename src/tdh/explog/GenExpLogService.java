package tdh.explog;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import tdh.frame.system.TsFymc;
import tdh.util.DBUtil;


public class GenExpLogService {
	
	public static boolean ISRUN =  false;
	
	private static final Log log = LogFactory.getLog(GenExpLogService.class);

	/**
	 * 统计日志信息，仅当天的.
	 */
	public void genernate(){
		ISRUN = true;
		Connection logConn = null;
		Connection xdbConn = null;
		try{
			xdbConn = DBUtil.getXdbConnection();
			logConn = DBUtil.getExpLogConnection();
			Map<String,String> dmtoFjm= new HashMap<String,String>();
			List<TsFymc> fylist = getFyList(xdbConn,dmtoFjm);
			String yymmdd = getyymmdd(logConn);
			//yymmdd = "20150209";
			if(yymmdd == null || "".equals(yymmdd.trim())) {
				log.error("交换库EXP_LOG表中无记录");
				return;
			}
			Map<String,Integer>  bssMap = tjBss(logConn,dmtoFjm);
			Map<String,Integer>  map1 = tjFiles(xdbConn,yymmdd,"1");
			Map<String,Integer>  map2 = tjFiles(xdbConn,yymmdd,"2");
			Map<String,Integer>  map3 = tjFiles(xdbConn,yymmdd,"3");
			Map<String,Integer>  map4 = tjFiles(xdbConn,yymmdd,"4");
			
			//Map<String,Integer>  ddsMap = tjDds(xdbConn,yymmdd);
			//Map<String,Integer>  jxsMap = tjJxs(xdbConn,yymmdd);
			//Map<String,Integer>  ycsMap = tjYcs(xdbConn,yymmdd);
			//保存到TR_EXP_LOG
			logToTrExLog2(xdbConn,yymmdd,fylist,bssMap,map1,map2,map3,map4);
			//分析到达和报送的差异
			ycqd_new(logConn,xdbConn,yymmdd,dmtoFjm);
		}catch(Exception e){
			log.error("genernate",e);
		}finally{
			DBUtil.closeConn(logConn);
			DBUtil.closeConn(xdbConn);
			ISRUN = false;
		}
	}
	
	//分析清单
	/**
	 * 计算异常清单
	 * @param logconn
	 * @param xdbConn
	 * @param yymmdd
	 */
	public void ycqd_new(Connection logconn,Connection xdbConn,String yymmdd,Map<String,String> dmtoFjm){
		
		 Statement st = null;
		 ResultSet rs = null;
		 List<Map<String,String>> ycqdMap =  new ArrayList<Map<String,String>>();
		 try{
			 st  =  logconn.createStatement();
			 rs = st.executeQuery("select distinct N_AJBS,N_FYID from EXP_LOG");
			 while(rs.next()){
				 String ajbs = rs.getString("N_AJBS");
				 String fjm = dmtoFjm.get(rs.getString("N_FYID"));
				 if(countFileExits(xdbConn,yymmdd,ajbs) == 0){
					 Map<String,String> row = new HashMap<String,String>();
					 row.put("fjm", fjm);
					 row.put("ajbs", ajbs);
					 ycqdMap.add(row);
				 }
			 }
			 //保存到TR_EXP_LOG_QD
			 insertLogQd(xdbConn,yymmdd,ycqdMap);
		}catch(Exception e){
			log.error("ycqd",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
	}
	
	public int countFileExits(Connection xdbConn,String yymmdd,String ajbs){
		 Statement st = null;
		 ResultSet rs = null;
		 try{
			 st = xdbConn.createStatement();
			 rs = st.executeQuery("select count(*) from TR_FILES WHERE CJRQ='"+yymmdd+"' and AJBS='"+ajbs+"'");
			 if(rs.next())
				 return rs.getInt(1);
		 }catch(Exception e){
			 log.error("countFileExits",e);
		 }finally{
				DBUtil.closeRs(rs);
				DBUtil.closeSt(st);
		}
		 return 0;
	}
	
	
	
	
	/**
	 * 统计达到数
	 * @param conn  XDB
	 * @return
	 */
	public Map<String,Integer> tjFiles(Connection conn,String yymmdd,String type){
		Map<String,Integer> data = new HashMap<String,Integer>();
		Statement st = null;
		ResultSet rs = null;
		try{
			String sql = "";
			if("1".equals(type)){
				sql = "SELECT FJM,count(*) from TR_FILES where CJRQ = '"+yymmdd+"' group by FJM";
			}else if("2".equals(type)){
				sql = "SELECT FJM,count(*) from TR_FILES where CJRQ = '"+yymmdd+"' and XMLTYPE='ASS' group by FJM";
			}else if("3".equals(type)){
				sql = "SELECT FJM,count(*) from TR_FILES where CJRQ = '"+yymmdd+"' and XMLTYPE='ADL' group by FJM";
			}else if("4".equals(type)){
				sql = "SELECT FJM,count(*) from TR_FILES where CJRQ = '"+yymmdd+"' and XMLTYPE='AJG' group by FJM";
			}
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			while(rs.next()){
				String fjm = rs.getString(1);
				int cnt = rs.getInt(2);
				data.put(fjm, cnt);
			}
		}catch(Exception e){
			log.error("tjFiles",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return data;
	}
	

	/**
	 * 计算异常清单
	 * @param logconn
	 * @param xdbConn
	 * @param yymmdd
	 */
	public void ycqd(Connection logconn,Connection xdbConn,String yymmdd,Map<String,String> dmtoFjm){
		 Map<String,String> xmlNameMap =  getXdbNameMap(xdbConn,yymmdd);
		 Statement st = null;
		 ResultSet rs = null;
		 List<Map<String,String>> ycqdMap =  new ArrayList<Map<String,String>>();
		 try{
			 st  =  logconn.createStatement();
			 rs = st.executeQuery("select distinct N_AJBS,N_FYID from EXP_LOG");
			 while(rs.next()){
				 String ajbs = rs.getString("N_AJBS");
				 String fjm = dmtoFjm.get(rs.getString("N_FYID"));
				 if(xmlNameMap.get(ajbs) == null){
					 Map<String,String> row = new HashMap<String,String>();
					 row.put("fjm", fjm);
					 row.put("ajbs", ajbs);
					 ycqdMap.add(row);
				 }
			 }
			 //保存到TR_EXP_LOG_QD
			 //insertLogQd(xdbConn,yymmdd,ycqdMap);
		}catch(Exception e){
			log.error("ycqd",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
	}
	
	
	/**
	 * 插入日志清单
	 * @param xdbConn 
	 * @param yymmdd
	 * @param ycqdMap
	 */
	public void insertLogQd(Connection xdbConn, String yymmdd,
			List<Map<String, String>> ycqdMap) {
		Statement st = null;
		try {
			st = xdbConn.createStatement();
			st.executeUpdate("delete from TR_EXP_LOG_QD where YYMMDD='"+yymmdd+"'");
			for(Map<String, String> row : ycqdMap){
				String fjm  =  row.get("fjm");
				String ajbs =  row.get("ajbs");
				st.executeUpdate("insert into TR_EXP_LOG_QD(YYMMDD,FJM,AJBS) values('"+yymmdd+"','"+fjm+"','"+ajbs+"')");
			}
			//统计异常清单数据导记录表
			String sql = "UPDATE TR_EXP_LOG "
			 +" SET BCZS = (SELECT COUNT(*) FROM TR_EXP_LOG_QD WHERE TR_EXP_LOG_QD.YYMMDD = TR_EXP_LOG.YYMMDD "
			 +" AND TR_EXP_LOG_QD.FJM = TR_EXP_LOG.FJM) "
			 +" WHERE YYMMDD='"+yymmdd+"'";
			st.executeUpdate(sql);
			xdbConn.commit();
		} catch (Exception e) {
			log.error("insertLogQd", e);
		} finally {
			DBUtil.closeSt(st);
		}
	}
	
	/**
	 * 获取具体某天的到达的交换文件数ASS
	 * @param xdbConn
	 * @param yymmdd
	 * @return
	 */
	public Map<String,String> getXdbNameMap(Connection xdbConn,String yymmdd){
		Map<String,String> xmlNameMap = new HashMap<String,String>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = xdbConn.createStatement();
			rs = st.executeQuery("select XMLNAME from TR_DD where XMLTYPE='ASS' AND DDSJ>= '"+yymmdd+" 00:00:00' AND DDSJ<='"+yymmdd+" 23:59:59'  ");
			while(rs.next()){
				String fileName = rs.getString("XMLNAME");
				if(fileName == null) fileName = "";
				int pos = fileName.indexOf(".");
				if(pos>-1){
					String ajbs = fileName.substring(0,pos).split("\\_")[2];
					xmlNameMap.put(ajbs,fileName);
				}
			}
		}catch(Exception e){
			log.error("getXdbNameMap",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return xmlNameMap;
	}
	
	
	/**
	 * 将统计数据保存到TR_EXP_LOG
	 * @param conn xdb
	 * @param yymmdd 年月
	 * @param fylist 法院
	 * @param bssMap 报送数
	 * @param ddsMap 达到数
	 * @param jxsMap 解析数
	 * @param ycsMap 异常数
	 */
	public void logToTrExLog(Connection conn,String yymmdd,List<TsFymc> fylist,Map<String,Integer>  bssMap,
			Map<String,Integer>  ddsMap,Map<String,Integer>  jxsMap,Map<String,Integer>  ycsMap){
		Statement st = null;
		try{
			st = conn.createStatement();
			st.executeUpdate("delete from TR_EXP_LOG where YYMMDD='"+yymmdd+"'");
			for(TsFymc fy : fylist){
				Integer bss = bssMap.get(fy.getFjm());
				if(bss == null) bss = 0;
				
				Integer dds = ddsMap.get(fy.getFjm());
				if(dds == null) dds = 0;
				
				Integer jxs = jxsMap.get(fy.getFjm());
				if(jxs == null) jxs = 0;
		
				Integer ycs = ycsMap.get(fy.getFjm());
				if(ycs == null) ycs = 0;
				
				st.executeUpdate("insert into TR_EXP_LOG(YYMMDD,FJM,BSS,DDS,JXS,YCS) values('"+yymmdd+"','"
						+fy.getFjm()+"',"+bss+","+dds+","+jxs+","+ycs+")");
			}
			conn.commit();
		}catch(Exception e){
			log.error("logToTrExLog",e);
		}finally{
			DBUtil.closeSt(st);
		}
	}
	
	/**
	 * 将统计数据保存到TR_EXP_LOG
	 * @param conn xdb
	 * @param yymmdd 年月
	 * @param fylist 法院
	 * @param bssMap 报送数
	 * @param ddsMap 达到数
	 * @param jxsMap 解析数
	 * @param ycsMap 异常数
	 */
	public void logToTrExLog2(Connection conn,String yymmdd,List<TsFymc> fylist,Map<String,Integer>  bssMap,
			Map<String,Integer>  map1,Map<String,Integer>  map2,Map<String,Integer>  map3,Map<String,Integer>  map4){
		Statement st = null;
		try{
			st = conn.createStatement();
			st.executeUpdate("delete from TR_EXP_LOG where YYMMDD='"+yymmdd+"'");
			for(TsFymc fy : fylist){
				Integer bss = bssMap.get(fy.getFjm());
				if(bss == null) bss = 0;
				
				Integer v1 = map1.get(fy.getFjm());
				if(v1 == null) v1 = 0;
				
				Integer v2 = map2.get(fy.getFjm());
				if(v2 == null) v2 = 0;
				
				Integer v3 = map3.get(fy.getFjm());
				if(v3 == null) v3 = 0;
				
				Integer v4 = map4.get(fy.getFjm());
				if(v4 == null) v4 = 0;
				
				st.executeUpdate("insert into TR_EXP_LOG(YYMMDD,FJM,BSS,XMLZS,AJZS,DLZS,JGZS) values('"+yymmdd+"','"
						+fy.getFjm()+"',"+bss+","+v1+","+v2+","+v3+","+v4+")");
			}
			conn.commit();
		}catch(Exception e){
			log.error("logToTrExLog",e);
		}finally{
			DBUtil.closeSt(st);
		}
	}
	
	
	public List<TsFymc> getFyList(Connection conn,Map<String,String> dmtoFjm){
		List<TsFymc>  fylist = new ArrayList<TsFymc>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = conn.createStatement();
			rs = st.executeQuery("select FYDM,FJM,DM,FYMC FROM TS_FYMC WHERE FJM like '3%' order by FJM");
			while(rs.next()){
				TsFymc fy = new TsFymc();
				fy.setFydm(rs.getString("FYDM"));
				fy.setFjm(rs.getString("FJM"));
				fy.setDm(rs.getShort("DM"));
				fy.setFymc(rs.getString("FYMC"));
				fylist.add(fy);
				dmtoFjm.put(String.valueOf(fy.getDm()), fy.getFjm());
			}
		}catch(Exception e){
			log.error("getFyList",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return fylist;
	}
	
	/**
	 * 获取TDH库中的EXP_LOG表的当前日志
	 * @param conn  logDb
	 * @return  yyyyMMddd
	 */
	public String getyymmdd(Connection conn){
		Statement st = null;
		ResultSet rs = null;
		String yymmdd = "";
		try{
			st = conn.createStatement();
			rs = st.executeQuery("select convert(char,max(DT_ZHDCSJ),112) from EXP_LOG");
			if(rs.next()){
				yymmdd = rs.getString(1);
			}
		}catch(Exception e){
			log.error("getyymmdd",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return yymmdd;
	}
	
	/**
	 * 报送数统计
	 * @param conn logDb
	 * @return
	 */
	public Map<String,Integer> tjBss(Connection conn,Map<String,String> dmtoFjm){
		Map<String,Integer> data = new HashMap<String,Integer>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = conn.createStatement();
			rs = st.executeQuery("select N_FYID,count(N_AJBS) from EXP_LOG group by N_FYID");
			while(rs.next()){
				String fyid = rs.getString(1);
				int cnt = rs.getInt(2);
				data.put(dmtoFjm.get(fyid), cnt);
			}
		}catch(Exception e){
			log.error("tjBss",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return data;
	}
	
	
	/**
	 * 统计达到数
	 * @param conn  XDB
	 * @return
	 */
	public Map<String,Integer> tjDds(Connection conn,String yymmdd){
		Map<String,Integer> data = new HashMap<String,Integer>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = conn.createStatement();
			rs = st.executeQuery("SELECT FY,count(*) from TR_DD where DDSJ>= '"+yymmdd+" 00:00:00' AND DDSJ<='"+yymmdd+" 23:59:59' group by FY");
			while(rs.next()){
				String fjm = rs.getString(1);
				int cnt = rs.getInt(2);
				data.put(fjm, cnt);
			}
		}catch(Exception e){
			log.error("tjdds",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return data;
	}
	
	
	/**
	 * 统计入库数
	 * @param conn  XDB
	 * @return
	 */
	public Map<String,Integer> tjJxs(Connection conn,String yymmdd){
		Map<String,Integer> data = new HashMap<String,Integer>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = conn.createStatement();
			rs = st.executeQuery("SELECT FY,count(*) from TR_DD where ZT='3' AND  DDSJ>= '"+yymmdd+" 00:00:00' AND DDSJ<='"+yymmdd+" 23:59:59' group by FY");
			while(rs.next()){
				String fjm = rs.getString(1);
				int cnt = rs.getInt(2);
				data.put(fjm, cnt);
			}
		}catch(Exception e){
			log.error("tjjxs",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return data;
	}
	
	/**
	 * 统计入库数
	 * @param conn  XDB
	 * @return
	 */
	public Map<String,Integer> tjYcs(Connection conn,String yymmdd){
		Map<String,Integer> data = new HashMap<String,Integer>();
		Statement st = null;
		ResultSet rs = null;
		try{
			st = conn.createStatement();
			rs = st.executeQuery("SELECT FY,count(*) from TR_DD where ZT='4' AND  DDSJ>= '"+yymmdd+" 00:00:00' AND DDSJ<='"+yymmdd+" 23:59:59' group by FY");
			while(rs.next()){
				String fjm = rs.getString(1);
				int cnt = rs.getInt(2);
				data.put(fjm, cnt);
			}
		}catch(Exception e){
			log.error("tjjxs",e);
		}finally{
			DBUtil.closeRs(rs);
			DBUtil.closeSt(st);
		}
		return data;
	}

}
