using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour
{
    public int gems = 0;
    public GameObject settingsPanel;
    public Transform respawnPoint;

    void Start()
    {
        Respawn();
    }

    public void ReceiveGem()
    {
        gems++;
    }

    public void ToggleSettingsPanel(InputAction.CallbackContext ctx)
    {
        if (ctx.performed)
        {
            settingsPanel.SetActive(!settingsPanel.active);
        }
    }

    void Respawn()
    {
        gameObject.transform.position = respawnPoint.position;
    }

    void OnTriggerEnter2D(Collider2D hitInfo)
    {
        if (hitInfo.gameObject.tag == "DeathZone")
        {
            Respawn();
        }

        if (hitInfo.gameObject.tag == "Finish")
        {

        }
    }
}