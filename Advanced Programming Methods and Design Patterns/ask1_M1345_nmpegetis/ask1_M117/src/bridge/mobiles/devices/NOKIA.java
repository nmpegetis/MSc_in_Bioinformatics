package bridge.mobiles.devices;

import bridge.mobiles.os.OpSys;

/**
 * @author Nikolas Begetis
 */

public class NOKIA extends Device {

	public NOKIA(OpSys os) {
		super(os);
	}

	@Override
	public void turnOn() {
		System.out.println("**NOKIA:\tTurning ON phone");
		impl.on();
	}

	@Override
	public void turnOff() {
		System.out.println("**NOKIA:\tTurning OFF phone");
		impl.off();
	}

	@Override
	public void call() {
		System.out.println("**NOKIA:\tCalling a number");
		impl.call();
	}

	@Override
	public void text() {
		System.out.println("**NOKIA:\tTexting a message");
		impl.text();
	}

	@Override
	public void downloadApp() {
		System.out.println("**NOKIA:\tDownloading and application");
		impl.downloadApp();
	}
	
	@Override
	public void open() {
		System.out.println("**NOKIA:\tOpening an application");
		impl.openApp();
	}
	@Override
	public void close() {
		System.out.println("**NOKIA:\tClosing an application");
		impl.closeApp();
	}
	
	@Override
	public void camera() {
		System.out.println("**NOKIA:\tPressing Camera button");
		impl.photoShoot();
	}

}
