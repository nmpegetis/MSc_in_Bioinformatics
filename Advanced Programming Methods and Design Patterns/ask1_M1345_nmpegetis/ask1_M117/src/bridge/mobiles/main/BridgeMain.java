package bridge.mobiles.main;

import bridge.mobiles.devices.Device;
import bridge.mobiles.devices.IPhone;
import bridge.mobiles.devices.LG;
import bridge.mobiles.devices.NOKIA;
import bridge.mobiles.os.Android;
import bridge.mobiles.os.IOS;
import bridge.mobiles.os.Windows;

public class BridgeMain {

	/**
	 * @author Nikolas Begetis
	 */
	
	public static void main(String[] args) {
		
		System.out.println("NOKIA Lumia 930: Windows");
		Device lumia = new NOKIA(new Windows());
		lumia.turnOn();
		lumia.call();
		lumia.text();
		lumia.downloadApp();
		lumia.open();
		lumia.close();
		lumia.camera();
		lumia.turnOff();
		System.out.println("--------------------------------------------");

		System.out.println("Nokia C1: Android");		
		Device c1 = new NOKIA(new Android());
		c1.turnOn();
		c1.call();
		c1.text();
		c1.downloadApp();
		c1.open();
		c1.close();
		c1.camera();
		c1.turnOff();
		System.out.println("--------------------------------------------");

		System.out.println("LG G4: Android");
		Device g4 = new LG(new Android());
		g4.turnOn();
		g4.call();
		g4.text();
		g4.downloadApp();
		g4.open();
		g4.close();
		g4.camera();
		g4.turnOff();
		System.out.println("--------------------------------------------");

		System.out.println("LG Lancet: Windows");
		Device lancet = new LG(new Windows());
		lancet.turnOn();
		lancet.call();
		lancet.text();
		lancet.downloadApp();
		lancet.open();
		lancet.close();
		lancet.camera();
		lancet.turnOff();
		System.out.println("--------------------------------------------");
		
		System.out.println("iPhone 6: IOS");
		Device iphone6 = new IPhone(new IOS());
		iphone6.turnOn();
		iphone6.call();
		iphone6.text();
		iphone6.downloadApp();
		iphone6.open();
		iphone6.close();
		iphone6.camera();
		iphone6.turnOff();
		System.out.println("--------------------------------------------");
		
		System.out.println("iPhone 0: Windows");
		Device iphone0 = new IPhone(new Windows());
		iphone0.turnOn();
		iphone0.call();
		iphone0.text();
		iphone0.downloadApp();
		iphone0.open();
		iphone0.close();
		iphone0.camera();
		iphone0.turnOff();
		System.out.println("--------------------------------------------");
	}

}
