package tdh.page;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import tdh.frame.common.DBUtils;



/**
 * 现实JDBC2 分页算法.
 * @author 施健伟
 */
public class Jdbc2PageDAO {
	
	private Connection conn ;
	private PageBean  pb;
	
	public Jdbc2PageDAO(Connection conn){
		this.conn = conn;
	}
	
	public Jdbc2PageDAO(Connection conn ,PageBean pb)
	{
		this.conn = conn;
		this.pb = pb;
	}
	
	public List<Map<String,Object>> execSql(String sql){
		List<Map<String,Object>> result =  new ArrayList<Map<String,Object>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			 ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				result.add(toMap(rs,rsmd));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtils.closeResultSet(rs);
			DBUtils.closeStatement(pstmt);
		}
		return result;
	}

	
	
	public PageBean getListBySQLMeta(){

		List<Map<String,Object>> result =  new ArrayList<Map<String,Object>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			String sql = pb.getHql();
			int rowcount = getRowcount();
			pb.setTotalRows(rowcount);
			if(rowcount >0){
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				rs = pstmt.executeQuery();
				if (pb.getStartRow() > 0) {
					rs.absolute(pb.getStartRow());
				}
				int i = 0;
				  ResultSetMetaData rsmd = rs.getMetaData();
				while (rs.next() && (i < pb.getLen() || pb.getLen() < 1)) {
					i++;
					result.add(toMap(rs,rsmd));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtils.closeResultSet(rs);
			DBUtils.closeStatement(pstmt);
		}
		pb.setResult(result);
		return this.pb;
	}
	
	
	
	
	private int getRowcount(){
		Statement stmt = null;
		ResultSet rs = null;
		int rowcount = 0;
		try{
			stmt = conn.createStatement();
			rs = stmt.executeQuery(pb.getCounthql());
			if(rs.next()){
				rowcount =  rs.getInt(1);
			}
		}catch(Exception e){
			e.printStackTrace();
			rowcount =  0;
		}finally{
			DBUtils.closeResultSet(rs);
			DBUtils.closeStatement(stmt);
		}
		return rowcount;
	}
	
	private  Map<String, Object> toMap(ResultSet rs,ResultSetMetaData rsmd ) throws SQLException {
		Map<String, Object> result = new HashMap<String,Object>();
        int cols = rsmd.getColumnCount();
        for (int i = 1; i <= cols; i++) {
            result.put(rsmd.getColumnLabel(i), rs.getString(i));
        }
        return result;
	}

}
