package gr.uoa.di.machlearn.snp.data;

public class Het {

	private final String type;
	private final Integer value;
	private final Integer stdError;
	
	public String getType() {
		return type;
	}

	public Integer getValue() {
		return value;
	}

	public Integer getStdError() {
		return stdError;
	}

	public Het(String type, Integer value, Integer stdError) {
		super();
		this.type = type;
		this.value = value;
		this.stdError = stdError;
	}


}
