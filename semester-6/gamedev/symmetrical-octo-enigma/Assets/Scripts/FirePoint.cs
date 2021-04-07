
using UnityEngine;
using UnityEngine.InputSystem;

public class FirePoint : MonoBehaviour
{

    public Transform firePoint;
    public GameObject bulletPrefab;

    public AudioSource shootSound;

    public void Shoot(InputAction.CallbackContext ctx)
    {
        if (ctx.performed)
        {
            shootSound.Play();
            Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
        }
    }
}