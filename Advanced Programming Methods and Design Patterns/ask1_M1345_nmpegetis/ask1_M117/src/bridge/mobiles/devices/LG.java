package bridge.mobiles.devices;

import bridge.mobiles.os.OpSys;

/**
 * @author Nikolas Begetis
 */

public class LG extends Device{

	public LG(OpSys os) {
		super(os);
	}

	@Override
	public void turnOn() {
		System.out.println("**LG:\tTurning ON phone");
		impl.on();
	}

	@Override
	public void turnOff() {
		System.out.println("**LG:\tTurning OFF phone");
		impl.off();
	}

	@Override
	public void call() {
		System.out.println("**LG:\tCalling a number");
		impl.call();
	}

	@Override
	public void text() {
		System.out.println("**LG:\tTexting a message");
		impl.text();
	}

	@Override
	public void downloadApp() {
		System.out.println("**LG:\tDownloading and application");
		impl.downloadApp();
	}
	
	@Override
	public void open() {
		System.out.println("**LG:\tOpening an application");
		impl.openApp();
	}
	@Override
	public void close() {
		System.out.println("**LG:\tClosing an application");
		impl.closeApp();
	}
	
	@Override
	public void camera() {
		System.out.println("**LG:\tPressing Camera button");
		impl.photoShoot();
	}
  
}
