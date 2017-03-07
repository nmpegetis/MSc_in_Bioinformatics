package gr.uoa.di.machlearn.snp.data;

import java.util.HashSet;
import java.util.Set;

public class MapLoc {
	private final Integer asnFrom;
	private final Integer asnTo;
	private final String locType;
	private final String alnQuality;
	private final String orient;
	private final String physMapInt;
	private final Integer leftContigNeighborPos;
	private final Integer rightContigNeighborPos;
	private final String refAllele;
	private Set<FxnSet> fxnSets;
	
	

	public MapLoc(Integer asnFrom, Integer asnTo, String locType,
			String alnQuality, String orient, String physMapInt,
			Integer leftContigNeighborPos, Integer rightContigNeighborPos,
			String refAllele, Set<FxnSet> fxnSets) {
		super();
		this.asnFrom = asnFrom;
		this.asnTo = asnTo;
		this.locType = locType;
		this.alnQuality = alnQuality;
		this.orient = orient;
		this.physMapInt = physMapInt;
		this.leftContigNeighborPos = leftContigNeighborPos;
		this.rightContigNeighborPos = rightContigNeighborPos;
		this.refAllele = refAllele;
		this.fxnSets = new HashSet<FxnSet>();
		this.fxnSets = fxnSets;
	}

	public Integer getAsnFrom() {
		return asnFrom;
	}

	public Integer getAsnTo() {
		return asnTo;
	}

	public String getLocType() {
		return locType;
	}

	public String getAlnQuality() {
		return alnQuality;
	}

	public String getOrient() {
		return orient;
	}

	public String getPhysMapInt() {
		return physMapInt;
	}

	public Integer getLeftContigNeighborPos() {
		return leftContigNeighborPos;
	}

	public Integer getRightContigNeighborPos() {
		return rightContigNeighborPos;
	}

	public String getRefAllele() {
		return refAllele;
	}

	public Set<FxnSet> getFxnSets() {
		return fxnSets;
	}

	public void setFxnSets(Set<FxnSet> fxnSets) {
		this.fxnSets = fxnSets;
	}
	
}
