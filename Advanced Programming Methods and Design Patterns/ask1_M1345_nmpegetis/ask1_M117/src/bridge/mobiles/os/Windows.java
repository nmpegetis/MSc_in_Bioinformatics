package bridge.mobiles.os;

/**
 * @author Nikolas Begetis
 */

public class Windows implements OpSys {

	@Override
	public void on() {
		System.out.println("##Windows:\tWelcome!");
	}

	@Override
	public void off() {
		System.out.println("##Windows:\tGoodbye!");
	}

	@Override
	public void call() {
		System.out.println("##Windows:\tDialing number...");
	}

	@Override
	public void text() {
		System.out.println("##Windows:\tSending message...");
	}

	@Override
	public void downloadApp() {
		System.out.println("##Windows:\tDownloading app...");
	}

	@Override
	public void openApp() {
		System.out.println("##Windows:\tOpening app...");
	}

	@Override
	public void closeApp() {
		System.out.println("##Windows:\tClosing app...");
	}
	
	@Override
	public void photoShoot() {
		System.out.println("##Windows:\tShooting a photo...");
	}
	
}
