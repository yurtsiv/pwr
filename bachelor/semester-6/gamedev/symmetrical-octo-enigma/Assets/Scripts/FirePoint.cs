
using UnityEngine;
using UnityEngine.InputSystem;

public class FirePoint : MonoBehaviour
{

    public Transform firePoint;
    public GameObject bulletPrefab;

    public AudioSource shootSound;
    public GameState gameState;

    public void Shoot(InputAction.CallbackContext ctx)
    {
        if (ctx.performed && !gameState.paused)
        {
            shootSound.Play();
            Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
        }
    }
}