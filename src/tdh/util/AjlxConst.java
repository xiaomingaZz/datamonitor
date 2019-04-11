package tdh.util;

import java.util.HashMap;
import java.util.Map;

public class AjlxConst {
	
	/**
	 * 案件类型编码和类型代码的对应关系
	 */
	public static final Map<String,String>  AJLX_DM_MAP = new HashMap<String,String>();
	
	public static final Map<String,String>  DM_AJLX_MAP = new HashMap<String,String>();
	public static final Map<String,String> dmMap = new HashMap<String,String>();
	public static final Map<String,String> ajlxbmMap = new HashMap<String,String>();
	
	/**
	 * 存入规范的交换XML_的案件类型以及5分钟的类型
	 */
	static{
		String[] wfzajlx = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
							"11","12","13","14","15","16","17","18","19","20",
							"21","22","23","24","25","26","27","28","29","30",
							"31","32","33","34","35","36","37","38","39","40",
							"41","42","43","44","45","46","47","48","49","50",
							"51","52","53","54","55","56","57","58","59","60",
							"61","62","63","64","65","66","67","68","69","70",
							"71","72","73","74","75","76"};
		
		String[] ajlxbm =  {"11","12","14","13","15","21","22","23","24","25",
				            "31","32","33","34","41","42","51","61","81","71",
				            "16","17","18","91","ZZ","1A","1B","1C","19","1D",
				            "1E","1F","1Z","26","27","2Z","3Z","4Z","A1","AZ",
				            "82","C1","D1","D2","D3","D4","5Z","28","29","1G",
				            "1H","1I","1J","2A","2B","2C","2D","2E","2F","B1",
				            "B2","B3","B4","B5","B6","B7","B8","B9","BA","43",
				            "44","45","46","47","48","4Z"}; 
		
		
		ajlxbmMap.put("11","刑事一审");
		ajlxbmMap.put("12","刑事二审");
		ajlxbmMap.put("14","刑事复核");
		ajlxbmMap.put("13","刑事再审");
		ajlxbmMap.put("15","刑罚变更");
		ajlxbmMap.put("21","民事一审");
		ajlxbmMap.put("22","民事二审");
		ajlxbmMap.put("23","民事再审");
		ajlxbmMap.put("24","民事特殊");
		ajlxbmMap.put("25","破产");
		ajlxbmMap.put("31","行政一审");
		ajlxbmMap.put("32","行政二审");
		ajlxbmMap.put("33","行政再审");
		ajlxbmMap.put("34","行政非诉执行审查");
		ajlxbmMap.put("41","赔偿确认");
		ajlxbmMap.put("42","司法赔偿");
		ajlxbmMap.put("51","执行");
		ajlxbmMap.put("61","再审审查与审判监督");
		ajlxbmMap.put("81","诉前保全");
		ajlxbmMap.put("71","信访");
		ajlxbmMap.put("16","强制医疗");
		ajlxbmMap.put("17","强制医疗复议");
		ajlxbmMap.put("18","解除强制医疗");
		ajlxbmMap.put("91","纪检监督");
		ajlxbmMap.put("ZZ","其他");
		ajlxbmMap.put("1A","没收违法所得申请审查");
		ajlxbmMap.put("1B","没收违法所得二审");
		ajlxbmMap.put("1C","没收违法所得再审");
		ajlxbmMap.put("19","强制医疗监督");
		ajlxbmMap.put("1D","停止执行死刑");
		ajlxbmMap.put("1E","刑罚与执行变更监督");
		ajlxbmMap.put("1F","刑罚与执行变更备案");
		ajlxbmMap.put("1Z","其他刑事");
		ajlxbmMap.put("26","第三人撤销之诉");
		ajlxbmMap.put("27","强制清算");
		ajlxbmMap.put("2Z","其他民事");
		ajlxbmMap.put("3Z","其他行政");
		ajlxbmMap.put("4Z","其他赔偿");
		ajlxbmMap.put("A1","司法救助");
		ajlxbmMap.put("AZ","其他司法救助");
		ajlxbmMap.put("82","非诉保全");
		ajlxbmMap.put("C1","司法制裁");
		ajlxbmMap.put("D1","刑事管辖");
		ajlxbmMap.put("D2","民事管辖");
		ajlxbmMap.put("D3","行政管辖");
		ajlxbmMap.put("D4","行政赔偿管辖");
		ajlxbmMap.put("5Z","其他执行");
		ajlxbmMap.put("28","人身安全保护令申请审查");
		ajlxbmMap.put("29","人身安全保护令变更");
		ajlxbmMap.put("1G","申请安置教育审查");
		ajlxbmMap.put("1H","解除安置教育审查");
		ajlxbmMap.put("1I","安置教育复议");
		ajlxbmMap.put("1J","安置教育监督");
		ajlxbmMap.put("2A","强制清算申请审查");
		ajlxbmMap.put("2B","破产申请审查");
		ajlxbmMap.put("2C","强制清算上诉");
		ajlxbmMap.put("2D","破产上诉");
		ajlxbmMap.put("2E","强制清算监督");
		ajlxbmMap.put("2F","破产监督");
		ajlxbmMap.put("B1","区际认可与执行申请审查");
		ajlxbmMap.put("B2","区际送达文书");
		ajlxbmMap.put("B3","区际调查取证");
		ajlxbmMap.put("B4","区际被判刑人移管");
		ajlxbmMap.put("B5","区际罪赃移交");
		ajlxbmMap.put("B6","国际承认与执行申请审查");
		ajlxbmMap.put("B7","国际送达文书");
		ajlxbmMap.put("B8","国际调查取证");
		ajlxbmMap.put("B9","国际被判刑人移管");
		ajlxbmMap.put("BA","国际引渡");
		ajlxbmMap.put("43","行政赔偿一审");
		ajlxbmMap.put("44","行政赔偿二审");
		ajlxbmMap.put("45","行政赔偿依职权再审审查");
		ajlxbmMap.put("46","行政赔偿申请再审审查");
		ajlxbmMap.put("47","行政赔偿抗诉再审审查");
		ajlxbmMap.put("48","行政赔偿再审");
		ajlxbmMap.put("4Z","其他行政赔偿");
		
		for(int i = 0 ; i < wfzajlx.length ; i ++) {
			AJLX_DM_MAP.put(ajlxbm[i] , wfzajlx[i]);
			DM_AJLX_MAP.put( wfzajlx[i] , ajlxbm[i]);
			dmMap.put(wfzajlx[i], ajlxbmMap.get(DM_AJLX_MAP.get(wfzajlx[i])));
		}
	}
}
