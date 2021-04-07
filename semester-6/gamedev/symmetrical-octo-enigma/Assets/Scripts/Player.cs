using UnityEngine;

public class Player : MonoBehaviour
{
    public int gems = 0;

    public void ReceiveGem() {
        gems++;
    }
}