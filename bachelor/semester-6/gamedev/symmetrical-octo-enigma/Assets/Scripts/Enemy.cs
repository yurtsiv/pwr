using UnityEngine;
using UnityEngine.Events;

public class Enemy : MonoBehaviour
{
    public int health = 100;
    public GameObject deathEffect;
    public GameObject gem;
    public GameObject explosion;

    public int gemsDrop = 3;


    public void TakeDamage(int damage)
    {
        health -= damage;

        if (health <= 0)
        {
            Die();
        }
    }

    void SpawnGems()
    {
        for (int i = 0; i < gemsDrop; i++)
        {
            Instantiate(
                gem,
                new Vector2(
                    transform.position.x + Random.Range(-1f, 1f),
                    transform.position.y + Random.Range(0f, 1f)
                ),
                Quaternion.identity
            );
        }
    }

    void Die()
    {
        Instantiate(deathEffect, transform.position, Quaternion.identity);
        SpawnGems();
        Instantiate(explosion, transform.position, Quaternion.identity);
        Destroy(gameObject);
    }
}