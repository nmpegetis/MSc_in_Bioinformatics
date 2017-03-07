package bridge.mobiles.os;

/**
 * @author Nikolas Begetis
 */

public class IOS implements OpSys {
	@Override
	public void on() {
		System.out.println("##IOS:\tWelcome!");
	}

	@Override
	public void off() {
		System.out.println("##IOS:\tGoodbye!");
	}

	@Override
	public void call() {
		System.out.println("##IOS:\tDialing number...");
	}

	@Override
	public void text() {
		System.out.println("##IOS:\tSending message...");
	}

	@Override
	public void downloadApp() {
		System.out.println("##IOS:\tDownloading app...");
	}

	@Override
	public void openApp() {
		System.out.println("##IOS:\tOpening app...");
	}

	@Override
	public void closeApp() {
		System.out.println("##IOS:\tClosing app...");
	}
	
	@Override
	public void photoShoot() {
		System.out.println("##IOS:\tShooting a photo...");
	}
}
