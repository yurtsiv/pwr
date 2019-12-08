public class EmptyException extends Exception {
    EmptyException() {
        super("Queue is empty");
    }
}
