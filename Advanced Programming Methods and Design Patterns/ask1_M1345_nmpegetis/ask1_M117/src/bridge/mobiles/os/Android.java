package bridge.mobiles.os;

/**
 * @author Nikolas Begetis
 */

public class Android implements OpSys {

	@Override
	public void on() {
		System.out.println("##Android:\tWelcome!");
	}

	@Override
	public void off() {
		System.out.println("##Android:\tGoodbye!");
	}

	@Override
	public void call() {
		System.out.println("##Android:\tDialing number...");
	}

	@Override
	public void text() {
		System.out.println("##Android:\tSending message...");
	}

	@Override
	public void downloadApp() {
		System.out.println("##Android:\tDownloading app...");
	}

	@Override
	public void openApp() {
		System.out.println("##Android:\tOpening app...");
	}

	@Override
	public void closeApp() {
		System.out.println("##Android:\tClosing app...");
	}
	
	@Override
	public void photoShoot() {
		System.out.println("##Android:\tShooting a photo...");
	}
	
}
