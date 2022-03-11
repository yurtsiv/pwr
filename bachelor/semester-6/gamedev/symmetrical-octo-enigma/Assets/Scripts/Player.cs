using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class Player : MonoBehaviour
{
    public int gems = 0;
    public GameObject settingsPanel;
    public Transform respawnPoint;

    public GameState gameState;

    int numOfScenes = 2;
    int currentScene = 0;

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
            gameState.paused = !gameState.paused;
            settingsPanel.SetActive(!settingsPanel.active);
        }
    }

    void Respawn()
    {
        gameObject.transform.position = respawnPoint.position;
    }

    void OnTriggerEnter2D(Collider2D hitInfo)
    {
        if (
            hitInfo.gameObject.tag == "DeathZone"
        )
        {
            Respawn();
        }

        if (hitInfo.gameObject.tag == "Finish")
        {
            currentScene = (currentScene + 1) % numOfScenes;

            SceneManager.LoadScene($"Level{currentScene}", LoadSceneMode.Single);
        }
    }

    void OnCollisionEnter2D(Collision2D info)
    {
        if (info.gameObject.tag == "Enemy")
        {
            Respawn();
        }
    }
}