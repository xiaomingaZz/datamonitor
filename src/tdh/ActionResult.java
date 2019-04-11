package tdh;

/**
 * 请求返回值情况.
 * @author 施健伟
 */
public class ActionResult {	
	
	public static final String SUCCESS="success";//成功
	public static final String ERROR = "error";//出错
	public static final String PASSWORD_ERROR = "pwderror"; //密码错误
	public static final String FAIL = "fail"; //失败
	public static final String EXECPTION = "execption"; //异常
	public static final String NONE = ""; //空结果
	public static final String DUPLICATE = "duplicate"; //重复	
	public static final String EXIST = "exist"; //存在	
	public static final String NOEXIST = "noexist"; //不存在
	public static final boolean  TRUE = true;
	public static final boolean  FALSE = false;
	public static final String  STRING_TRUE = "true";
	public static final String  STRING_FALSE = "false";
	public static final String  STRING_NUMERIC_TRUE = "1.0";
	public static final String  STRING_NUMERIC_FALSE = "0.0";
	public static final String  CONTEXT_TYPE_HTML="text/html;charset=utf-8";
	public static final String  CONTEXT_TYPE_JSON="application/json";
}
