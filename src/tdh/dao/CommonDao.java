/**   
 * @Title: CommonDao.java
 * @Package org.easyweb.fgkp.dao
 * @Description: TODO
 * @author gezy   
 * @date 2011-5-4 上午08:47:52
 * @version V1.0   
 */
package tdh.dao;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * @ClassName: CommonDao
 * @Description: 通用DAO
 * @author gezy
 * @date 2011-5-4 上午08:47:52
 * 
 */
public class CommonDao extends HibernateDaoSupport {
	
	private JdbcTemplate jdbcTemplate;
	

	public List<Map> selectBySql(String sql, Object[] params) {
		Session session = getSession();
		Query query = null;
		query = session.createSQLQuery(sql);
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}

	public List<Map> selectBySql(String sql, Object[] params, String[] replace,
			String[] repParams) {
		sql = replaceSql(sql, replace, repParams);
		Session session = getSession();
		Query query = null;
		query = session.createSQLQuery(sql);
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}
	
	//NEW
	public List<Map> selectBySql(String sql, String[] replace_old,
			String[] repParams_old, String[] replace,
			String[] repParams) {
		sql = replaceSql(sql, replace_old, repParams_old);
		sql = replaceSql(sql, replace, repParams);
		Session session = getSession();
		Query query = null;
		query = session.createSQLQuery(sql);
		/*if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}*/
		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}

	public List selectByHql(String sql, Object[] params) {
		Session session = getSession();
		Query query = null;
		query = session.createQuery(sql);
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		return query.list();
	}

	public List selectByHql(String sql, Object[] params, String[] replace,
			String[] repParams) {
		sql = replaceSql(sql, replace, repParams);
		Session session = getSession();
		Query query = null;
		query = session.createQuery(sql);
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		return query.list();
	}

	public int excuteBySql(String sql, Object[] params) {
		Session session = getSession();
		Query query = null;
		query = session.createSQLQuery(sql);
		// 带有参数
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.executeUpdate();
	}

	public int excuteByHql(String sql, Object[] params) {
		Session session = getSession();
		Query query = null;
		query = session.createQuery(sql);
		// 带有参数
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		return query.executeUpdate();
	}

	/**
	 * 执行带有替换的SQL
	 * 
	 * @param sql
	 *            配置的SQL
	 * @param params
	 *            SQL 中的参数
	 * @param replace
	 *            需要替换的
	 * @param repStr
	 *            替换的参数
	 * @param isHql
	 *            是否HQL
	 * @return
	 */
	public int excuteBySql(String sql, Object[] params, String[] replace,
			String[] repParams) {
		Session session = getSession();
		Query query = null;
		// 需要替换
		sql = replaceSql(sql, replace, repParams);
		query = session.createSQLQuery(sql);
		// 带有参数
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		return query.executeUpdate();
	}

	public int excuteByHql(String sql, Object[] params, String[] replace,
			String[] repParams) {
		Session session = getSession();
		Query query = null;
		// 需要替换
		sql = replaceSql(sql, replace, repParams);
		query = session.createQuery(sql);
		// 带有参数
		if (params != null) {
			for (int i = 0, len = params.length; i < len; i++) {
				query.setParameter(i, params[i]);
			}
		}
		return query.executeUpdate();
	}

	private String replaceSql(String sql, String[] replace, String[] repParams) {
		if (replace != null) {
			for (int i = 0, len = replace.length; i < len; i++) {
				sql = sql.replace(replace[i], repParams[i]);
			}
		}
		return sql;
	}

	public boolean existsBySql(String sql, Object[] values) throws Exception {
		Session session = getSession();
		Query query = session.createQuery(sql);
		if (values != null) {
			for (int i = 0; i < values.length; i++) {
				query.setParameter(i, values[i]);
			}
		}
		List<?> list = query.list();
		if (list == null || list.size() == 0) {
			return false;
		}
		return true;
	}

	public boolean existsByHql(String sql, Object[] values) throws Exception {
		Session session = getSession();
		Query query = session.createSQLQuery(sql);
		if (values != null) {
			for (int i = 0; i < values.length; i++) {
				query.setParameter(i, values[i]);
			}
		}
		List<?> list = query.list();
		if (list == null || list.size() == 0) {
			return false;
		}
		return true;
	}

	public <T> T get(Class<T> clazz, Serializable id) {
		return (T) getHibernateTemplate().get(clazz, id);
	}

	public <T> T load(Class<T> clazz, Serializable id) {
		return (T) getHibernateTemplate().load(clazz, id);
	}

	public Serializable save(Object entity) {
		return getHibernateTemplate().save(entity);
	}

	public void saveOrUpdateAll(List entities) {
		getHibernateTemplate().saveOrUpdateAll(entities);
	}

	public void update(Object entity) {
		getSession().update(entity);
	}

	public void delete(Object entity) {
		getHibernateTemplate().delete(entity);
	}

	public void saveOrUpdate(Object o) {
		getSession().saveOrUpdate(o);
	}

	public Map findUniqueBySql(final String sql, Object[] values) {
		Session sess = getSession();
		SQLQuery query = sess.createSQLQuery(sql);
		if (values != null && values.length > 0) {
			for (int i = 0; i < values.length; i++) {
				query.setParameter(i, values[i]);
			}
		}
		query.setMaxResults(1);
		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		List list = query.list();
		if (list == null || list.size() == 0) {
			return null;
		}
		Object obj = list.get(0);
		if (obj == null) {
			return null;
		}
		return (Map) obj;
	}

	public <T> T findUniqueByHql(Class<T> clazz, final String sql,
			Object[] values) {
		Session sess = getSession();
		Query query = sess.createQuery(sql);
		if (values != null && values.length > 0) {
			for (int i = 0; i < values.length; i++) {
				query.setParameter(i, values[i]);
			}
		}
		query.setMaxResults(1);
		List list = query.list();
		if (list == null || list.size() == 0) {
			return null;
		}
		Object obj = list.get(0);
		if (obj == null) {
			return null;
		}
		return (T) obj;
	}

	public <T> T findUniqueByHql(Class<T> clazz, String sql, Object[] values,
			String[] replace, String[] repParams) {
		sql = replaceSql(sql, replace, repParams);
		Session sess = getSession();
		Query query = sess.createQuery(sql);
		if (values != null && values.length > 0) {
			for (int i = 0; i < values.length; i++) {
				query.setParameter(i, values[i]);
			}
		}
		query.setMaxResults(1);
		List list = query.list();
		if (list == null || list.size() == 0) {
			return null;
		}
		Object obj = list.get(0);
		if (obj == null) {
			return null;
		}
		return (T) obj;
	}

	/**
	 * 分页数据
	 * 
	 * @param sql
	 * @param start
	 * @param limit
	 * @param values
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> findByPageBySql(final String sql, final int start,
			final int limit, final Object[] values) {
		return getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException, SQLException {
				Query q = session.createSQLQuery(sql);
				if (values != null && values.length > 0) {
					for (int i = 0; i < values.length; i++) {
						q.setParameter(i, values[i]);
					}
				}
				q.setFirstResult(start).setMaxResults(limit);
				q.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
				return q.list();
			}
		});
	}

	/**
	 * 获取count 值得
	 * 
	 * @param sql
	 * @param values
	 * @return
	 * @throws Exception
	 */
	public Integer getCountBySql(String sql, final Object[] values) {
		Map map = findUniqueBySql(sql, values);
		if (map == null) {
			return -1;
		}
		Collection coll = map.values();
		for (Object obj : coll) {
			if (obj instanceof Number) {
				return ((Number) obj).intValue();
			}
		}
		return -1;
	}

	public Integer getCountBySql(String sql, Object[] values, String[] replace,
			String[] repParams) {
		sql = replaceSql(sql, replace, repParams);
		Map map = findUniqueBySql(sql, values);
		if (map == null) {
			return -1;
		}
		Collection coll = map.values();
		for (Object obj : coll) {
			if (obj instanceof Number) {
				return ((Number) obj).intValue();
			}
		}
		return -1;
	}
	/**
	 * 获取count 值得
	 * 
	 * @param sql
	 * @param values
	 * @return
	 * @throws Exception
	 */
	// public Long getCountByHql(String hql, final Object[] values) {
	// Map map = findUniqueByHql(hql, values);
	// if (map == null) {
	// return -1L;
	// }
	// Collection coll = map.values();
	// for (Object obj : coll) {
	// if (obj instanceof Number) {
	// return ((Number) obj).longValue();
	// }
	// }
	// return -1L;
	//
	// }

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
}
