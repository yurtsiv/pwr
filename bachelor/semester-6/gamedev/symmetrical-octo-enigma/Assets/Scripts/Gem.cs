using UnityEngine;

public class Gem : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D hitInfo)
    {
        var player = hitInfo.GetComponent<Player>();

        if (player != null)
        {
            player.ReceiveGem();
            Destroy(gameObject);
        }
    }
}