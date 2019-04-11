package tdh.cxfx;

/**
 * TsBzdm entity.
 * 标准代码.
 * @author MyEclipse Persistence Tools
 */

public class TsBzdm implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private TsBzdmId id;
	private String mc;
	private String fdm;
	private String sfjy;
	private Integer pxh;
	private String bt;
	private String codenow;
	private String ver;
	private String kin09;

	// Constructors

	public String getKin09() {
	    return kin09;
	  }

	  public void setKin09(String kin09) {
	    this.kin09 = kin09;
	  }

	  public String getCodenow() {
		    return codenow;
		  }

		  public void setCodenow(String codenow) {
		    this.codenow = codenow;
		  }

  public String getVer() {
    return ver;
  }

  public void setVer(String ver) {
    this.ver = ver;
  }

  /** default constructor */
	public TsBzdm() {
	}

	/** minimal constructor */
	public TsBzdm(TsBzdmId id) {
		this.id = id;
	}

	/** full constructor */
	public TsBzdm(TsBzdmId id, String mc, String fdm, String sfjy,String bt, String codenow, String ver,String kin09) {
		this.id = id;
		this.mc = mc;
		this.fdm = fdm;
		this.sfjy = sfjy;
		this.bt = bt;
		this.codenow = codenow;
		this.ver = ver;
		this.kin09 = kin09;
	}

	// Property accessors

	public TsBzdmId getId() {
		return this.id;
	}

	public void setId(TsBzdmId id) {
		this.id = id;
	}

	public String getMc() {
		return this.mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getFdm() {
		return this.fdm;
	}

	public void setFdm(String fdm) {
		this.fdm = fdm;
	}

	public String getSfjy() {
		return this.sfjy;
	}

	public void setSfjy(String sfjy) {
		this.sfjy = sfjy;
	}

	public Integer getPxh() {
		return pxh;
	}

	public void setPxh(Integer pxh) {
		this.pxh = pxh;
	}

	public String getBt() {
		return bt;
	}

	public void setBt(String bt) {
		this.bt = bt;
	}

}