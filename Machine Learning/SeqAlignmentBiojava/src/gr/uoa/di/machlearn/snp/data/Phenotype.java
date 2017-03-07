package gr.uoa.di.machlearn.snp.data;

public class Phenotype {
	public final String clinicalSignificance;

	public Phenotype(String clinicalSignificance) {
		super();
		this.clinicalSignificance = clinicalSignificance;
	}

	public String getClinicalSignificance() {
		return clinicalSignificance;
	}
	
}
