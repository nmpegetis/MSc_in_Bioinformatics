package gr.uoa.di.machlearn.snp.data;

public class FxnSet {
	public final Integer geneId;
	public final String symbol;
	public final String mrnaAcc;
	public final String mrnaVer;
	public final String protAcc;
	public final String protVer;
	public final String fxnClass;
	public final String readingFrame;
	public final String allele;
	public final String residue;
	public final String aaPosition;
	public final String soTerm;
	public FxnSet(Integer geneId, String symbol, String mrnaAcc,
			String mrnaVer, String protAcc, String protVer, String fxnClass,
			String readingFrame, String allele, String residue,
			String aaPosition, String soTerm) {
		super();
		this.geneId = geneId;
		this.symbol = symbol;
		this.mrnaAcc = mrnaAcc;
		this.mrnaVer = mrnaVer;
		this.protAcc = protAcc;
		this.protVer = protVer;
		this.fxnClass = fxnClass;
		this.readingFrame = readingFrame;
		this.allele = allele;
		this.residue = residue;
		this.aaPosition = aaPosition;
		this.soTerm = soTerm;
	}
	public Integer getGeneId() {
		return geneId;
	}
	public String getSymbol() {
		return symbol;
	}
	public String getMrnaAcc() {
		return mrnaAcc;
	}
	public String getMrnaVer() {
		return mrnaVer;
	}
	public String getProtAcc() {
		return protAcc;
	}
	public String getProtVer() {
		return protVer;
	}
	public String getFxnClass() {
		return fxnClass;
	}
	public String getReadingFrame() {
		return readingFrame;
	}
	public String getAllele() {
		return allele;
	}
	public String getResidue() {
		return residue;
	}
	public String getAaPosition() {
		return aaPosition;
	}
	public String getSoTerm() {
		return soTerm;
	}

	
}
