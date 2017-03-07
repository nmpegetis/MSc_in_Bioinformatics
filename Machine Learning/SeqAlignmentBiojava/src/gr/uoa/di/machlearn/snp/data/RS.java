package gr.uoa.di.machlearn.snp.data;

import java.util.Set;

public class RS {

	private final Het het;
	private final Validation validation;
	private final Sequence sequence;
	private final Set<Ss> sss;
	private final Set<Assemply> assemplies;
	private final Set<PrimarySequence> primarySequences;
	private final RsStruct rsStruct;
	private final Hgvs hgvs;
	private final Set<AlleleOrigin> alleleOrigin;
	private final Phenotype phenotype;

	public RS (	Het het, Validation validation, Sequence sequence, Set<Ss> sss, Set<Assemply> assemplies, Set<PrimarySequence> primarySequences, RsStruct rsStruct, Hgvs hgvs,Set<AlleleOrigin> alleleOrigin, Phenotype phenotype) {
		this.het = het;
		this.validation = validation;
		this.sequence = sequence;
		this.sss = sss;
		this.assemplies = assemplies;
		this.primarySequences = primarySequences;
		this.rsStruct = rsStruct;
		this.hgvs = hgvs;
		this.alleleOrigin = alleleOrigin;
		this.phenotype = phenotype;

	}
	
	public Het getHet() {
		return het;
	}

	public Validation getValidation() {
		return validation;
	}

	public Sequence getSequence() {
		return sequence;
	}

	public Set<Ss> getSss() {
		return sss;
	}

	public Set<Assemply> getAssemplies() {
		return assemplies;
	}

	public Set<PrimarySequence> getPrimarySequences() {
		return primarySequences;
	}

	public RsStruct getRsStruct() {
		return rsStruct;
	}

	public Hgvs getHgvs() {
		return hgvs;
	}

	public Set<AlleleOrigin> getAlleleOrigin() {
		return alleleOrigin;
	}

	public Phenotype getPhenotype() {
		return phenotype;
	}

}
