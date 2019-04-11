package tdh.frame.web.context;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 启动将应用的上下文绑定到WebAppContext中。 
 * 这样WebAppContext的提供的***Ex方法才可以正常使用.
 * 
 * @author 施健伟 2012-12-19
 * @version 1.0.0
 */
public class WebInitContextListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent sce) {
		WebAppContext.removeServletContext();
	}

	public void contextInitialized(ServletContextEvent sce) {

		WebAppContext.bindServletContext(sce.getServletContext());

	}

}
