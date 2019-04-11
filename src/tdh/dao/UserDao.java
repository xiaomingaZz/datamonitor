package tdh.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;


public class UserDao extends HibernateDaoSupport{
	
	/*@SuppressWarnings("unchecked")
	public String find(String fydm,String xm,String limit,String start,Map map){
		
		List<WtYh> list = new ArrayList<WtYh>();
		String sql = "from WtYh where 1 = 1";
		if(!"".equals(fydm)){
			sql += " and fydm = '"+fydm+"' ";
		}
		if(!"".equals(xm)){
			sql += " and yhxm like '%"+xm + "%'";
		}
		Integer total= findCount(sql);
		list = findRows(sql,limit,start);
		
		
		JSONArray ja = new JSONArray();
		for(WtYh wy : list){
			JSONObject jo = new JSONObject();
			jo.put("RYPK", wy.getRypk());
			jo.put("YHZH", wy.getYhdm());
			jo.put("YHXM", wy.getYhxm());
			jo.put("FYDM", wy.getFydm());
			jo.put("FYDMMC", map.get(wy.getFydm()));
			jo.put("SFJY", wy.getSfjy());
			ja.add(jo);
		}
		JSONObject json = new JSONObject();
		json.put("root", ja);
		json.put("totalCount", total);
		
		
		return json.toString();
	}
	
	private List findRows(String sql,String start,String limit){
		List list = new ArrayList();
		Session se = this.getSession();
		try {
			Query query = se.createQuery(sql);
			
//			Integer totalRows = findCount(sql);
//			int totalPage = 0;
//			if (Integer.parseInt(limit) > 0) {
//				totalPage = totalRows / Integer.parseInt(limit);
//				if (totalRows % Integer.parseInt(limit) > 0) {
//					totalPage++;
//				}
//			}
//			if (totalPage == 0) { // 如果总页数小于等于0的话，设置总行数为1
//				totalPage = 1;
//			}
//			if (Integer.parseInt(limit) > 0) {
//				query.setFirstResult(Integer.parseInt(start));
//				query.setMaxResults(Integer.parseInt(limit));
//			}
//			list = query.list();
			
			
			//List list = query.list();//查询全部结果
			list = query.setFirstResult(Integer.parseInt(start)*Integer.parseInt(limit)).setMaxResults(Integer.parseInt(limit)).list();//根据页面查询需要的结果
			return list;
		} catch (RuntimeException re) {
			throw re;
		} finally {
			SessionFactoryUtils.releaseSession(se, this.getSessionFactory());
		}
	}
	
	private Integer findCount(String sql){
		List list = new ArrayList();
		Session se = this.getSession();
		try {
			Query query = se.createQuery(sql);
			list = query.list();//查询全部结果
			//list = query.setFirstResult(Integer.parseInt(start)*Integer.parseInt(limit)).setMaxResults(Integer.parseInt(limit)).list();//根据页面查询需要的结果
			return list.size();
		} catch (RuntimeException re) {
			throw re;
		} finally {
			SessionFactoryUtils.releaseSession(se, this.getSessionFactory());
		}
	}
	
	
	public WtYh findById(java.lang.String id) {
		try {
			//entity  要加上包名
			WtYh instance = (WtYh) getHibernateTemplate().get(
					"tdh.model.WtYh", id);
			return instance;
		} catch (RuntimeException re) {
			re.printStackTrace();
			throw re;
		}
	}
	
	
	public void delete(WtYh persistentInstance) {
		try {
			this.getHibernateTemplate().delete(persistentInstance);
		} catch (RuntimeException re) {
			throw re;
		}
	}
	
	@SuppressWarnings("unchecked")
	public WtYh findByFydmYhzhNJy(String fydm,String yhzh){
		Object[] obj = { fydm, yhzh };
		List<WtYh> list = null;
		try {
			list = this.getHibernateTemplate().find(
					"from WtYh where fydm=? and yhdm=?", obj);
			
			if (list == null || list.size() == 0) {
				return null;
			} else {
				return list.get(0);
			}
		} catch (RuntimeException re) {
			throw re;
		}
	}
	
	public void update(WtYh yh){
		try {
			this.getHibernateTemplate().update(yh);
		} catch (RuntimeException re) {
			re.printStackTrace();
			throw re;
		}
	}
	
	public void save(WtYh yh){
		try {
			this.getHibernateTemplate().save(yh);
		} catch (RuntimeException re) {
			re.printStackTrace();
			throw re;
		}
	}
	
	*/

}
