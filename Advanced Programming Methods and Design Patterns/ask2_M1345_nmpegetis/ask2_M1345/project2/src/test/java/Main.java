/**
 * Created by nmpegetis on 25/11/15.
 */
public class Main {

    public static void main(String[] args) {
        Stack stack;
        Thread e1,e2,e3,o1,o2,o3;

        stack = new Stack();
        e1 = new Thread(new Examiner(stack));
        e2 = new Thread(new Examiner(stack));
        e3 = new Thread(new Examiner(stack));
        o1 = new Thread(new Observer(stack));
        o2 = new Thread(new Observer(stack));
        o3 = new Thread(new Observer(stack));

        e1.start();
        e2.start();
        e3.start();
        o1.start();
        o2.start();
        o3.start();

        // do the job
        try {
            e1.join();
            e2.join();
            e3.join();
            o1.join();
            o2.join();
            o3.join();
        } catch (InterruptedException e) {
            System.out.println("Main InterruptedException: ");
            e.printStackTrace();
        }
        System.out.println("\n ***End of program***");
    }
}
