using UnityEngine;
using UnityEngine.InputSystem;

public class Player : MonoBehaviour
{
    public int gems = 0;
    public GameObject settingsPanel;

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
}