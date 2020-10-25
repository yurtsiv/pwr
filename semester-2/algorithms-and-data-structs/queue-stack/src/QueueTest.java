package lab2;

import org.junit.*;
import static org.junit.Assert.*;

public class QueueTest {
    Queue<String> queue;

    @Before
    public void setUp() {
        queue = new Queue<>();
    }

    @Test
    public void enqueueDequeueSize() {
        assertEquals(0, queue.size());
        queue.enqueue("John");
        queue.enqueue("Fred");
        assertEquals(2, queue.size());
        assertEquals("John", queue.dequeue());
        assertEquals("Fred", queue.dequeue());
        assertEquals(0, queue.size());
    }

    @Test
    public void peek() {
        queue.enqueue("John");
        assertEquals("John", queue.peek());
        assertEquals(1, queue.size());
    }

    @Test
    public void isEmpty() {
        assertTrue(queue.isEmpty());
        queue.enqueue("John");
        assertFalse(queue.isEmpty());
        queue.dequeue();
        assertTrue(queue.isEmpty());
    }

    @Test
    public void clear() {
        queue.enqueue("John");
        queue.enqueue("Fred");
        queue.clear();
        assertTrue(queue.isEmpty());
    }

    @Test
    public void contains() {
        assertFalse(queue.contains("John"));
        queue.enqueue("Fred");
        queue.enqueue("John");
        assertTrue(queue.contains("John"));
    }

    @Test
    public void indexOf() {
        queue.enqueue("Fred");
        assertEquals(-1, queue.indexOf("John"));

        queue.enqueue("John");
        queue.enqueue("Mike");
        assertEquals(0, queue.indexOf("Fred"));
        assertEquals(1, queue.indexOf("John"));
        assertEquals(2, queue.indexOf("Mike"));

    }
}
