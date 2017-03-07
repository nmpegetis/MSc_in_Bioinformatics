/**
 * Created by nmpegetis on 25/11/15.
 */
public class Observer implements Runnable {
    private Stack stack = null;

    public Observer(Stack s) {
        this.stack=s;
        System.out.println("*** Observer Created!");
    }

    @Override
    public void run() { //top
        stack.top();
        stack.print();
    }

}