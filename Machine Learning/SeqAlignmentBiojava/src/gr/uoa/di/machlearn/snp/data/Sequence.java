package gr.uoa.di.machlearn.snp.data;

public class Sequence {
	private final org.biojava.bio.seq.Sequence seq5;
	private final String observed;
	private final org.biojava.bio.seq.Sequence seq3;

	public Sequence(org.biojava.bio.seq.Sequence seq5, String observed,
			org.biojava.bio.seq.Sequence seq3) {
		super();
		this.seq5 = seq5;
		this.observed = observed;
		this.seq3 = seq3;
	}

	public org.biojava.bio.seq.Sequence getSeq5() {
		return seq5;
	}

	public String getObserved() {
		return observed;
	}

	public org.biojava.bio.seq.Sequence getSeq3() {
		return seq3;
	}

	
}
