/**
 * Created by nmpegetis on 25/11/15.
 */
public aspect AspectJStack {
    // variables and pointcuts referred before
    RWLock Stack.lock = new RWLock();


    pointcut reading(Stack s): target(s) && (call(* Stack.top()) || call(* Stack.print())) ;
    pointcut writing(Stack s): target(s) && (call(* Stack.pop())||call(* Stack.push(*)));

    before(Stack s): reading(s) { s.lock.enter_read();}
    after(Stack s): reading(s) { s.lock.exit_read();}

    before(Stack s): writing(s) { s.lock.enter_write();}
    after(Stack s): writing(s) { s.lock.exit_write();}


    ///http://o7planning.org/web/fe/default/en/document/18642/java-aspect-oriented-programming-tutorial-with-aspectj

    // Define a Pointcut is //http://o7planning.org/web/fe/default/en/document/18642/java-aspect-oriented-programming-tutorial-with-aspectj
    // collection of JoinPoint call top/pop/push of class Stack.
//    pointcut callStackTop(): call(* Stack.top());
//    pointcut callStackPop(): call(* Stack.Pop());
//    pointcut callStackPush(): call(* Stack.Push());

//    before() : callStackTop() {
//        lock.enter_top();
//    }
//    after() : callStackTop() {
//        lock.exit_top();
//    }
//
//    before() : callStackPop() {
//        lock.enter_pop();
//    }
//    after() : callStackPop() {
//        lock.exit_pop();
//    }
//
//    before() : callStackPush() {
//        lock.enter_push();
//    }
//    after() : callStackPush() {
//        lock.exit_push();
//    }

}
