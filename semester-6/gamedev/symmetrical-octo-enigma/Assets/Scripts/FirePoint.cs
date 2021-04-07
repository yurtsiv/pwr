
using UnityEngine;
using UnityEngine.InputSystem;

public class FirePoint : MonoBehaviour
{

    public Transform firePoint;
    public GameObject bulletPrefab;

    public void Shoot(InputAction.CallbackContext ctx)
    {
        if (ctx.performed)
        {
            Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
        }
    }
}