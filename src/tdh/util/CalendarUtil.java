package tdh.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class CalendarUtil {
	
	public static String  getNowStr(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss,SS");
		return sdf.format(Calendar.getInstance().getTime());
	}
	
	public static Long getNowLong(){
		return Calendar.getInstance().getTimeInMillis();
	}

}
