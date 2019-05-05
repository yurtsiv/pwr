package lab2;


import org.junit.*;
import static org.junit.Assert.*;


public class StackTest {
    Stack<String> stack;

    @Before
    public void setUp() {
        stack = new Stack<>();
    }

    @Test
    public void pushPopPeekSize() {
        assertEquals(0, stack.size());
        String elem = "some str";
        stack.push(elem);
        assertEquals(1, stack.size());
        assertEquals(elem, stack.peek());
        assertEquals(1, stack.size());
        assertEquals(elem, stack.pop());
        assertEquals(0, stack.size());
    }

    @Test
    public void isEmpty() {
        assertTrue(stack.isEmpty());
        stack.push("Elem 1");
        assertFalse(stack.isEmpty());
    }

    @Test
    public void indexOf() {
        stack.push("elem1");
        stack.push("elem2");
        stack.push("elem3");

        assertEquals(0, stack.indexOf("elem3"));
        assertEquals(1, stack.indexOf("elem2"));
        assertEquals(2, stack.indexOf("elem1"));
        assertEquals(-1, stack.indexOf("random str"));
    }

    @Test
    public void contains() {
        assertFalse(stack.contains("random string"));
        stack.push("elem1");
        assertTrue(stack.contains("elem1"));
        stack.push("elem2");
        assertTrue(stack.contains("elem2"));
        assertFalse(stack.contains("random string"));
    }

    @Test
    public void clear() {
        stack.push("elem1");
        stack.push("elem2");
        stack.clear();
        assertEquals(0, stack.size());
    }
}