package gr.uoa.di.machlearn.snp.data;


public class Ss {
	
	
	private final String ssId;
	private final String handle;
	private final String batchId;
	private final String locSnpId;
	private final String subSnpClass;
	private final String orient;
	private final String strand;
	private final String molType;
	private final String buildId;
	private final String methodClass;
	private final String validated;
	private final Sequence sequence;

	public Ss(String ssId, String handle, String batchId, String locSnpId,
			String subSnpClass, String orient, String strand, String molType,
			String buildId, String methodClass, String validated,
			Sequence sequence) {
		super();
		this.ssId = ssId;
		this.handle = handle;
		this.batchId = batchId;
		this.locSnpId = locSnpId;
		this.subSnpClass = subSnpClass;
		this.orient = orient;
		this.strand = strand;
		this.molType = molType;
		this.buildId = buildId;
		this.methodClass = methodClass;
		this.validated = validated;
		this.sequence = sequence;
	}

	public String getSsId() {
		return ssId;
	}

	public String getHandle() {
		return handle;
	}

	public String getBatchId() {
		return batchId;
	}

	public String getLocSnpId() {
		return locSnpId;
	}

	public String getSubSnpClass() {
		return subSnpClass;
	}

	public String getOrient() {
		return orient;
	}

	public String getStrand() {
		return strand;
	}

	public String getMolType() {
		return molType;
	}

	public String getBuildId() {
		return buildId;
	}

	public String getMethodClass() {
		return methodClass;
	}

	public String getValidated() {
		return validated;
	}

	public Sequence getSequence() {
		return sequence;
	}
	

}
