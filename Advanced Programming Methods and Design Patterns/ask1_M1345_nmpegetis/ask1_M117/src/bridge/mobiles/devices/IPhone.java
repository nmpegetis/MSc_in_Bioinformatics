package bridge.mobiles.devices;

import bridge.mobiles.os.OpSys;

/**
 * @author Nikolas Begetis
 */

public class IPhone extends Device {

	public IPhone(OpSys os) {
		super(os);
	}

	@Override
	public void turnOn() {
		System.out.println("**iPhone\tTurning ON phone");
		impl.on();
	}

	@Override
	public void turnOff() {
		System.out.println("**iPhone\tTurning OFF phone");
		impl.off();
	}

	@Override
	public void call() {
		System.out.println("**iPhone\tCalling a number");
		impl.call();
	}

	@Override
	public void text() {
		System.out.println("**iPhone\tTexting a message");
		impl.text();
	}

	@Override
	public void downloadApp() {
		System.out.println("**iPhone\tDownloading and application");
		impl.downloadApp();
	}
	
	@Override
	public void open() {
		System.out.println("**iPhone\tOpening an application");
		impl.openApp();
	}
	@Override
	public void close() {
		System.out.println("**iPhone\tClosing an application");
		impl.closeApp();
	}
	
	@Override
	public void camera() {
		System.out.println("**iPhone\tPressing Camera button");
		impl.photoShoot();
	}

}
