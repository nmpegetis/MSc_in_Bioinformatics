package bridge.mobiles.devices;

import bridge.mobiles.os.OpSys;

/**
 * @author Nikolas Begetis
 */

public abstract class Device {

	protected OpSys impl;

	protected Device(OpSys os) {
		this.impl = os;
	}

	public void turnOn() {
		impl.on();
	}

	public void turnOff() {
		impl.off();
	}

	public void call() {
		impl.call();
	}

	public void text() {
		impl.text();
	}


	public void downloadApp() {
		impl.downloadApp();
	}

	public void open() {
		impl.openApp();
	}

	public void close() {
		impl.closeApp();
	}

	public void camera() {
		impl.photoShoot();
	}

}
