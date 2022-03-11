using UnityEngine;

public class MovingPlatform : MonoBehaviour
{
    public float speed = 10;
    public Rigidbody2D body;

    float initialX;
    Vector2 velocity;

    void Start()
    {
        initialX = transform.position.x;
        velocity = new Vector2(speed, 0);
    }

    void Update()
    {
        velocity.x = speed * Mathf.Sign(velocity.x);

        body.velocity = velocity;
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.tag == "PlatformStop")
        {
            velocity.x = -velocity.x;
        }
    }
}