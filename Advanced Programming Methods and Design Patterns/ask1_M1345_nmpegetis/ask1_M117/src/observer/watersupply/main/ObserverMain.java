package observer.watersupply.main;

import observer.watersupply.observable.Sensor;
import observer.watersupply.observers.MobileApp;
import observer.watersupply.observers.Observer;
import observer.watersupply.observers.WebApp;

/**
 * @author Nikolas Begetis
 */

public class ObserverMain {

	public static void main(String[] args) {
		Sensor sensor = new Sensor();
		Observer mobileApp = new MobileApp();
		Observer webApp = new WebApp();
		sensor.addObserver(mobileApp);
		sensor.addObserver(webApp);
		System.out.println("-------------------------------------------\n" + sensor.countObservers()
				+ " Observers just Created and are connected to the Water supply sensors...");
		for (int i = 0; i < 10; i++) {
			System.out.println("Check #"+i+":");
			sensor.checkValues();
			if (sensor.isChanged()) {
				sensor.notifyObservers();
				sensor.reinitialize();
			}
			System.out.println("-------------------------------------------");
		}

		sensor.deleteObserver(mobileApp);
		System.out.println("-------------------------------------------\n" + sensor.countObservers()
				+ " Observers are connected to the Water supply sensors...");

		for (int i = 0; i < 10; i++) {
			System.out.println("Check #"+i+":");
			sensor.checkValues();
			if (sensor.isChanged()) {
				sensor.notifyObservers();
				sensor.reinitialize();
			}
			System.out.println("-------------------------------------------");
		}
		System.out.println("End of program");
	}
}
