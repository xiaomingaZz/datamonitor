package tdh.cxfx;

/**
 * TsBzdmId entity.
 * 标准代码主键.
 * @author MyEclipse Persistence Tools
 * 
 */

public class TsBzdmId implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String kind;
	private String code;

	// Constructors

	/** default constructor */
	public TsBzdmId() {
	}

	/** full constructor */
	public TsBzdmId(String kind, String code) {
		this.kind = kind;
		this.code = code;
	}

	// Property accessors

	public String getKind() {
		return this.kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TsBzdmId))
			return false;
		TsBzdmId castOther = (TsBzdmId) other;

		return ((this.getKind() == castOther.getKind()) || (this.getKind() != null
				&& castOther.getKind() != null && this.getKind().equals(
				castOther.getKind())))
				&& ((this.getCode() == castOther.getCode()) || (this.getCode() != null
						&& castOther.getCode() != null && this.getCode()
						.equals(castOther.getCode())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getKind() == null ? 0 : this.getKind().hashCode());
		result = 37 * result
				+ (getCode() == null ? 0 : this.getCode().hashCode());
		return result;
	}

}