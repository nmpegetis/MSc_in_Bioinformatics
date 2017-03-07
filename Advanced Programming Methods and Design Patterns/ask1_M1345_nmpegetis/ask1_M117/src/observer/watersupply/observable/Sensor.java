package observer.watersupply.observable;

import java.util.ArrayList;
import java.util.List;

import observer.watersupply.observers.Observer;

/**
 * @author Nikolas Begetis
 */

public class Sensor implements WaterSupplyRoutines {

	private List<Observer> observers = new ArrayList<Observer>();
	private boolean changed = false;
	private int barium = 10;
	private int chromium = 70;
	private int copper = 30;
	private int cyanide = 20;
	private int nickel = 10;
	
	public void checkValues() {
		double perc = Math.random();
		System.out.println("***Sensor info: Checking for changes in water supply");
		
		if (perc <= 0.1) {
			if (Math.random() > 0.5) {
				barium++;
			} else {
				barium--;
			}
			this.changed = true;
			System.out.println("***Sensor info: BARIUM just changed!");
		} 
		else if (perc > 0.1 && perc <= 0.2) {
			if (Math.random() > 0.5) {
				chromium++;
			} else {
				chromium--;
			}
			this.changed = true;
			System.out.println("***Sensor info: CHROMIUM just changed!");
		} 
		else if (perc > 0.2 && perc <= 0.3) {
			if (Math.random() > 0.5) {
				copper++;
			} else {
				copper--;
			}
			this.changed = true;
			System.out.println("***Sensor info: COPPER just changed!");
		} 
		else if (perc > 0.3 && perc <= 0.4) {
			if (Math.random() > 0.5) {
				cyanide++;
			} else {
				cyanide--;
			}
			this.changed = true;
			System.out.println("***Sensor info: CYANIDE just changed!");
		} 
		else if (perc > 0.4 && perc <= 0.5) {
			if (Math.random() > 0.5) {
				nickel++;
			} else {
				nickel--;
			}
			this.changed = true;
			System.out.println("***Sensor info: NICKEL just changed!");
		} 
		else {
			System.out.println("***Sensor info: Nothing changed!");
		}

	}

	@Override
	public void addObserver(Observer o) {
		System.out.println("$$ Adding an observer...");
		observers.add(o);
	}

	@Override
	public void deleteObserver(Observer o) {
		System.out.println("$$ Deleting an observer...");
		observers.remove(o);
	}

	@Override
	public void notifyObservers() {
		System.out.println("***Sensor info: Sending Notification to observers for the change in Water Supply...");
		for (Observer observer : observers) {
			observer.updateValues(this.barium, this.chromium, this.copper, this.cyanide, this.nickel);
		}
	}

	@Override
	public int countObservers() {
		return observers.size();
	}

	@Override
	public boolean isChanged() {
		return this.changed;
	}

	@Override
	public void reinitialize() {
		this.changed = false;
	}
}
