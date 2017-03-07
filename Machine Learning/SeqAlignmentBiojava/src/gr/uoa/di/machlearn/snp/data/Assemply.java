package gr.uoa.di.machlearn.snp.data;

public class Assemply {
	private final Integer dbSnpBuild;
	private final Double genomeBuild;
	private final String groupLabel;
	private final String current;
	private final String reference;
	private final Component component;
	private final SnpStat snpStat;


	public SnpStat getSnpStat() {
		return snpStat;
	}

	public Assemply(Integer dbSnpBuild, Double genomeBuild, String groupLabel,
			String current, String reference, Component component,
			SnpStat snpStat) {
		super();
		this.dbSnpBuild = dbSnpBuild;
		this.genomeBuild = genomeBuild;
		this.groupLabel = groupLabel;
		this.current = current;
		this.reference = reference;
		this.component = component;
		this.snpStat = snpStat;
	}

	public Integer getDbSnpBuild() {
		return dbSnpBuild;
	}

	public Double getGenomeBuild() {
		return genomeBuild;
	}

	public String getGroupLabel() {
		return groupLabel;
	}

	public String getCurrent() {
		return current;
	}

	public String getReference() {
		return reference;
	}

	public Component getComponent() {
		return component;
	}

}
