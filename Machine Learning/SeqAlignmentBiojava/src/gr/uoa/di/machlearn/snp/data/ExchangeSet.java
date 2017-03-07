package gr.uoa.di.machlearn.snp.data;

import java.util.HashMap;
import java.util.Map;

public class ExchangeSet {

	private final Map<Integer, RS> rs;

	public ExchangeSet (Map<Integer, RS> rs) {
		rs = new HashMap<Integer, RS>();
		this.rs = rs;
	}
	
	public RS getRS(int id) {
		return rs.get(id);
	}

	public Map<Integer, RS> getExchangeSet() {
		return rs;
	}

}

