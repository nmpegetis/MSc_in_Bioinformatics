package gr.uoa.di.machlearn.snp.data;

public class AlleleOrigin {
	public final String allele;
	public final String alleleComp;
	public AlleleOrigin(String allele, String alleleComp) {
		super();
		this.allele = allele;
		this.alleleComp = alleleComp;
	}
	public String getAllele() {
		return allele;
	}
	public String getAlleleComp() {
		return alleleComp;
	}
	
}
