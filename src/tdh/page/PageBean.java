package tdh.page;

import java.util.ArrayList;
import java.util.List;


/**
 * 分页设置对象.
 * @author 施健伟 2010-6-28
 *
 */
public class PageBean {
	
	
    public PageBean(){
    }
	/**
	 * 构造方法.
	 * @param currentPage 当前页.
	 * @param pageSize    每页数.
	 */
	public PageBean(int currentPage,int pageSize){
		setCurrentPage(currentPage);
		setLen(pageSize);
	}
	

	/**
	 * 总行数.
	 */
	private int totalRows = 0;

	/**
	 * 起始行.
	 */
	private int startRow = 0;

	/**
	 * 每页行数.
	 */
	private int len = 20;

	/**
	 * 当前页.
	 */
	private int currentPage = 1;
	
	/**
	 * 总页数.
	 */
	private int totalPage = 0;
	
	/**
	 * 返回结果集.
	 */
	@SuppressWarnings("unchecked")
	private List  result;
	
	/**
	 * 查询语句.
	 */
	private String hql;;
	
	/**
	 * 获取记录数sql语句.
	 */
	private String counthql;


	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getLen() {
		return len;
	}

	public void setLen(int len) {
		this.len = len;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
		this.setStartRow((this.currentPage - 1)* len); //设置startRow
	}

	@SuppressWarnings("unchecked")
	public List getResult() {
		return result;
	}

	@SuppressWarnings("unchecked")
	public void setResult(List result) {
		this.result = result;
	}

	
	public String getHql() {
		return hql;
	}

	public void setHql(String hql) {
		this.hql = hql;
	}

	public String getCounthql() { 
	    if (this.counthql == null){   
	        counthql = ""; 
	    } 
	    if ("".equals(counthql.trim())){ 
    	    String tmp = this.hql;
	    	int form_N =  getSQLFromPS(tmp);
	    	int ps = 0;
	    	tmp =  tmp.toLowerCase();
	        int index = tmp.indexOf(" from ");
	        int i = 0;
	    	while(index >=0){
	    		i ++;
	    		ps += index + 6;
	    		tmp = tmp.substring(index+6);
	    		index = tmp.indexOf(" from ");
	    		if( i == form_N){
	    			index = -1;
	    		}
	    	}
	    	counthql =  "select count(*) as cnt from "+ hql.substring(ps);
	    	if(counthql.toLowerCase().lastIndexOf(" order ")!=-1){ //去除掉
	    		counthql =  counthql.substring(0,counthql.toLowerCase().lastIndexOf(" order "));
	    	}
	    } 
	  return counthql; 
	}
	
	
	private   int  getSQLFromPS(String hql){
		if(hql.length() == 0) return 0;
		hql = " " + hql.toLowerCase();
		hql = hql.replace("(select","( select" );
		List<String> stack = new ArrayList<String>();
	    int index = hql.indexOf(" select ");
	    String flag ="0"; 
	    hql = hql.substring(index+8);
		while( index >= 0 ){
			if("0".equals(flag)){
			   stack.add("select");
			}else if("1".equals(flag)){
		        stack.add("from");
			}
			int index1 =  hql.indexOf(" select ");
			int index2 =  hql.indexOf(" from ");
			if (index1 !=-1 && index2 !=-1){
				if(index1< index2 && index1 !=-1){
				    flag ="0";
				    index =  index1;
				    hql = hql.substring(index+8);
				}else if(index2<index1 && index2!=-1){
					flag = "1";
					index = index2;
					hql = hql.substring(index+6);
				}
			}else{
				index = -1;
			}
			
		}
		int from_N = 0;
		int select_N =0;
		for(String str : stack){
			if("select".equals(str)){
				select_N ++;
			}
			if("from".equals(str)){
				from_N ++;
			}
			if (select_N == from_N){
				break;
			}
		}
		return from_N;
	}
	
	//大写转小写
	 public static String shift(String str) {
	   int size = str.length();
	   char[] chs = str.toCharArray();
	   for (int i = 0; i < size; i++) {
	    if (chs[i] <= 'Z' && chs[i] >= 'A') {
	     chs[i] = (char) (chs[i] + 32);
	    }
	   }
	   return new String(chs);
	  }
	

	public void setCounthql(String counthql) {
		this.counthql = counthql;
	}

	
	
	public int getTotalRows() {
		return totalRows;
	}

	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
		if (len > 0) {
			totalPage = totalRows / len;
			if (totalRows % len > 0) {
				totalPage ++;
			}
		}
		if (totalPage == 0) { //如果总页数小于等于0的话，设置总行数为1
			totalPage = 1;
		}
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

}
