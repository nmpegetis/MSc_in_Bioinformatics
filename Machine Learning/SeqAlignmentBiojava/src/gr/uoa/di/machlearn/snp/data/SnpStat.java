package gr.uoa.di.machlearn.snp.data;

public class SnpStat {
	public final String mapWeight;
	public final Integer chromCount;
	public final Integer placedContigCount;
	public final Integer unplacedContigCount;
	public final Integer seqlocCount;
	public final Integer hapCount;

	public SnpStat(String mapWeight, Integer chromCount,
			Integer placedContigCount, Integer unplacedContigCount,
			Integer seqlocCount, Integer hapCount) {
		super();
		this.mapWeight = mapWeight;
		this.chromCount = chromCount;
		this.placedContigCount = placedContigCount;
		this.unplacedContigCount = unplacedContigCount;
		this.seqlocCount = seqlocCount;
		this.hapCount = hapCount;
	}

	public String getMapWeight() {
		return mapWeight;
	}

	public Integer getChromCount() {
		return chromCount;
	}

	public Integer getPlacedContigCount() {
		return placedContigCount;
	}

	public Integer getUnplacedContigCount() {
		return unplacedContigCount;
	}

	public Integer getSeqlocCount() {
		return seqlocCount;
	}

	public Integer getHapCount() {
		return hapCount;
	}

}
