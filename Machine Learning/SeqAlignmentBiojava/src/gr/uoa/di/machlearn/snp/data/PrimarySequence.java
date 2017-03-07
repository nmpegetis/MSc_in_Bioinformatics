package gr.uoa.di.machlearn.snp.data;

public class PrimarySequence {
	public final Integer dbSnpBuild;
	public final String gi;
	public final String source;
	public final String accession;
	public final MapLoc mapLoc;
	
	public PrimarySequence(Integer dbSnpBuild, String gi, String source,
			String accession, MapLoc mapLoc) {
		super();
		this.dbSnpBuild = dbSnpBuild;
		this.gi = gi;
		this.source = source;
		this.accession = accession;
		this.mapLoc = mapLoc;
	}

	public Integer getDbSnpBuild() {
		return dbSnpBuild;
	}

	public String getGi() {
		return gi;
	}

	public String getSource() {
		return source;
	}

	public String getAccession() {
		return accession;
	}

	public MapLoc getMapLoc() {
		return mapLoc;
	}
	
}
