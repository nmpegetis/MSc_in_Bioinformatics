/**
 * Created by nmpegetis on 25/11/15.
 */

public class RWLock {
    int readers;
    public RWLock() { readers = 0; }
    public synchronized void enter_read() {
        while (readers == -1)
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        readers++;
    }
    public synchronized void exit_read() {
        readers--;
        if (readers == 0)
            notify();
    }
    public synchronized void enter_write() {
        while (readers != 0)
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        readers = -1;
    }
    public synchronized void exit_write() {
        readers = 0;
        notifyAll();
    }
}
