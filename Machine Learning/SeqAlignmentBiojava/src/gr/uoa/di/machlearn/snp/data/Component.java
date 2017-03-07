package gr.uoa.di.machlearn.snp.data;

public class Component {
	private final String componentType;
	private final String accession;
	private final String chromosome;
	private final Integer start;
	private final Integer end;
	private final String orientation;
	private final Integer gi;
	private final String groupTerm;
	private final String contiglabel;
	private final MapLoc mapLoc;
	
	public Component(String componentType, String accession, String chromosome,
			Integer start, Integer end, String orientation, Integer gi,
			String groupTerm, String contiglabel, MapLoc mapLoc) {
		super();
		this.componentType = componentType;
		this.accession = accession;
		this.chromosome = chromosome;
		this.start = start;
		this.end = end;
		this.orientation = orientation;
		this.gi = gi;
		this.groupTerm = groupTerm;
		this.contiglabel = contiglabel;
		this.mapLoc = mapLoc;
	}

	public String getComponentType() {
		return componentType;
	}

	public String getAccession() {
		return accession;
	}

	public String getChromosome() {
		return chromosome;
	}

	public Integer getStart() {
		return start;
	}

	public Integer getEnd() {
		return end;
	}

	public String getOrientation() {
		return orientation;
	}

	public Integer getGi() {
		return gi;
	}

	public String getGroupTerm() {
		return groupTerm;
	}

	public String getContiglabel() {
		return contiglabel;
	}

	public MapLoc getMapLoc() {
		return mapLoc;
	}

}
