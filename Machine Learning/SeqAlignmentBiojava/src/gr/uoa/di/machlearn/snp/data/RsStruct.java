package gr.uoa.di.machlearn.snp.data;

public class RsStruct {
	public final String protAcc;
	public final Integer protGi;
	public final Integer protLoc;
	public final String protResidue;
	public final String rsResidue;
	public final String structGi;
	public final String structLoc;
	public final String structResidue;
	
	public RsStruct(String protAcc, Integer protGi, Integer protLoc,
			String protResidue, String rsResidue, String structGi,
			String structLoc, String structResidue) {
		super();
		this.protAcc = protAcc;
		this.protGi = protGi;
		this.protLoc = protLoc;
		this.protResidue = protResidue;
		this.rsResidue = rsResidue;
		this.structGi = structGi;
		this.structLoc = structLoc;
		this.structResidue = structResidue;
	}

	public String getProtAcc() {
		return protAcc;
	}

	public Integer getProtGi() {
		return protGi;
	}

	public Integer getProtLoc() {
		return protLoc;
	}

	public String getProtResidue() {
		return protResidue;
	}

	public String getRsResidue() {
		return rsResidue;
	}

	public String getStructGi() {
		return structGi;
	}

	public String getStructLoc() {
		return structLoc;
	}

	public String getStructResidue() {
		return structResidue;
	}
	
}
