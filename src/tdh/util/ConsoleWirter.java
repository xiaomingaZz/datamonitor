package tdh.util;

public class ConsoleWirter {
	
	public static void info(String message){
		System.out.println("[TDH] "+ CalendarUtil.getNowStr()+" "+message);
	}
	
	public static void error(String message,Throwable error){
		info(message);
		error.printStackTrace();
	}

}
