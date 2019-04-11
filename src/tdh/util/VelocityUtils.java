/**  
* Filename:    VelocityUtils.java  
* Description:   
* Copyright:   Copyright (c)2010  
* Company:     南京通达海信息科技有限公司
* @author:     gezy
* @version:    1.0  
* Create at:   2010-11-22 下午04:36:33  
*  
* Modification History:  
* Date         Author      Version     Description  
* ------------------------------------------------------------------  
* 2010-11-22    gezy             1.0        1.0 Version  
*/  
package tdh.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.runtime.RuntimeConstants;


/**
 * @ClassName: VelocityUtils
 * @Description: 
 * @author gezy
 * @date 2010-11-22 下午04:36:33
 * 
 */
public class VelocityUtils {
	/**
	 * TEMPLATE +  DATA = 输出 合并后的数据
	 * @param filePath  模板文件
	 * @param context   数据上下文（实际上就是一MAP）
	 * @param request   httprequest
	 * @param resp      httpresponse
	 * @throws Exception
	 */
    public static void write(String filePath,VelocityContext context,HttpServletRequest request,HttpServletResponse resp) 
                             throws Exception{
		String realPath = request.getSession().getServletContext().getRealPath("");
		//文件资源加载路径
		Velocity.setProperty(RuntimeConstants.FILE_RESOURCE_LOADER_PATH,realPath+"/template");
		//System.out.println(realPath+"\\template");
		// 初始化引擎
		Velocity.init();
		// 加载模板
		Template template = Velocity.getTemplate(filePath,"UTF-8");
		//合并VIEW 和  data
		template.merge(context, resp.getWriter());
		resp.getWriter().flush();
    }
    
    /**
	 * TEMPLATE +  DATA = 输出 合并后的数据
	 * @param filePath  模板文件
	 * @param context   数据上下文（实际上就是一MAP）
	 * @param request   httprequest
	 * @param resp      httpresponse
	 * @throws Exception
	 */
    public static String write(String filePath,VelocityContext context,HttpServletRequest request) 
                             throws Exception{
		String realPath = request.getSession().getServletContext().getRealPath("");
		//文件资源加载路径
		Velocity.setProperty(RuntimeConstants.FILE_RESOURCE_LOADER_PATH,realPath+"/template");
		
		// 初始化引擎
		Velocity.init();
		// 加载模板
		Template template = Velocity.getTemplate(filePath,"UTF-8");
		StringWriter wirter = new StringWriter();
		//合并VIEW 和  data
		template.merge(context, wirter);
		return wirter.getBuffer().toString();
    }
}
