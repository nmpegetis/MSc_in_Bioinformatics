import java.util.ArrayList;

/**
 * Created by nmpegetis on 25/11/15.
 */

public class Stack {
    private ArrayList<Integer> stack = null;


    public Stack() {
        stack = new ArrayList<Integer>();
    }


    public synchronized void print () {
        System.out.print("[");
        for (int i=0 ; i<stack.size() ; i++){
            System.out.print(stack.get(i)+" ");
        }
        System.out.print("]");
    }

    public synchronized Integer top (){
        if (!stack.isEmpty())
            return stack.get(0);
        else
            return null;
    }

    public synchronized Integer pop (){
        if (!stack.isEmpty())
            return stack.remove(0);
        else
            return null;
    }
    public synchronized void push (Integer i){
        stack.add(0,i);
    }

    public synchronized boolean empty(){
        System.out.println("*** Stack is empty!");
        return stack.isEmpty();
    }
}
