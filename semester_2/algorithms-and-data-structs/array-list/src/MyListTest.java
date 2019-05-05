package lab1;

import org.junit.*;

import java.util.Iterator;

import static org.junit.Assert.*;

public class MyListTest {
    MyList<String> list = new MyList<>();

    @Before
    public void setUp() {
        list.add("Lorem");
        list.add("ipsum");
        list.add("dolor");
        list.add("sit");
        list.add("amet");
    }

    @Test
    public void isEmptySizeClear() {
        assertFalse(list.isEmpty());

        list.clear();

        assertEquals(0, list.size());
        assertTrue(list.isEmpty());
    }

    @Test
    public void getSetRemove() {
        assertEquals("ipsum", list.get(1));
        String newElem = "muspi";
        list.set(1, newElem);
        assertEquals(newElem, list.get(1));
        list.remove(1);
        assertEquals("dolor", list.get(1));
        list.remove("dolor");
        assertEquals("sit", list.get(1));
    }

    @Test
    public void contains() {
        assertFalse(list.contains("random string"));
        assertTrue(list.contains("amet"));
    }

    @Test
    public void indexOf() {
        assertEquals(1, list.indexOf("ipsum"));
        assertEquals(-1, list.indexOf("random string"));
    }

    @Test
    public void add() {
        int initialSize = list.size();
        String endElem = "string at the end";
        String middleElem = "string in the middle";

        list.add(endElem);
        assertEquals(endElem, list.get(list.size() - 1));
        assertEquals(initialSize + 1, list.size());

        list.add(2, middleElem);
        assertEquals(middleElem, list.get(2));
        assertEquals(initialSize + 2, list.size());
    }

    @Test
    public void iterator() {
        int initialSize = list.size();
        Iterator<String> iter = list.iterator();
        assertTrue(iter.hasNext());
        assertEquals(list.get(0), iter.next());
        iter.remove();
        assertEquals(initialSize - 1, list.size());

        iter.next();
        iter.next();
        iter.next();
        iter.next();

        assertFalse(iter.hasNext());
    }
}