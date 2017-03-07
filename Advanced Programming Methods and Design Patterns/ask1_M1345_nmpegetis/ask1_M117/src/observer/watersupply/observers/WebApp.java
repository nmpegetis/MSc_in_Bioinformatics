package observer.watersupply.observers;

/**
 * @author Nikolas Begetis
 */
public class WebApp implements Observer {


	@Override
	public void updateValues(int barium, int chromium, int copper, int cyanide,int nickel) {
		System.out.println("##WebApp received a Change:");
		System.out.println("\t\tBarium: " + barium);
		System.out.println("\t\tChromium: " + chromium);
		System.out.println("\t\tCopper: " + copper);
		System.out.println("\t\tCyanide: " + cyanide);
		System.out.println("\t\tNickel: " + nickel);
		System.out.println();
	}

}
