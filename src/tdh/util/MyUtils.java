package tdh.util;

public class MyUtils {
	 public static String numToStr(String val,int len){
		  StringBuilder sb = new StringBuilder();
		  for(int i = 0; i < len ; i++){
			  sb.append("0");
		  }
		  sb.append(val);
		  return sb.substring(sb.length()-len);
	  }
}
