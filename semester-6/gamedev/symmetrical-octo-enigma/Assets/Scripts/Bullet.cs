using UnityEngine;

public class Bullet : MonoBehaviour
{
    public Rigidbody2D body;
    public float speed = 100f;
    public int damage = 50;

    void Start()
    {
        body.velocity = transform.right * speed;
    }

    private void OnTriggerEnter2D(Collider2D hitInfo)
    {
        var enemy = hitInfo.GetComponent<Enemy>();

        if (enemy != null)
        {
            enemy.TakeDamage(damage);
        }

        Destroy(gameObject);
    }

}