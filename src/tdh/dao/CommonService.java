package tdh.dao;

import tdh.dao.CommonDao;

public abstract class CommonService {
	
	protected CommonDao commDao;

	public void setCommDao(CommonDao commDao) {
		this.commDao = commDao;
	}
}
