/**
 * Created by nmpegetis on 25/11/15.
 */
public class Examiner implements Runnable {
    private Stack stack = null;

    public Examiner(Stack s) {
        this.stack=s;
        System.out.println("*** Examiner Created!");
    }

    @Override
    public void run() {     //push and pop
        stack.push(1);
        stack.print();
        stack.pop();
        stack.print();
        stack.pop();
        stack.print();
        stack.push(2);
        stack.print();
        stack.push(3);
        stack.print();
        stack.pop();
        stack.print();
        stack.pop();
        stack.print();
        stack.pop();
        stack.print();
        stack.push(4);

    }

}