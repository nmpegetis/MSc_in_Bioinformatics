package observer.watersupply.observable;

import observer.watersupply.observers.Observer;

/**
 * @author Nikolas Begetis
 */

public interface WaterSupplyRoutines {

	public void addObserver(Observer o);
	public void deleteObserver(Observer o);
	public void notifyObservers();
	public int countObservers();
	public boolean isChanged();
	public void reinitialize();
	
}
