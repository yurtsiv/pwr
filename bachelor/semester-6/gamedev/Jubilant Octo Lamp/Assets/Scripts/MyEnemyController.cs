using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class MyEnemyController : MonoBehaviour
{
    public EnemiesController enemiesController;
    public GameObject deathEffect;
    public Transform deathEffectPos;
    public Transform target;
    public float health = 0f;
    NavMeshAgent agent;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
    }

    private void Update()
    {
        agent.SetDestination(target.position);
    }

    public void ReceiveDamage(float damage)
    {
        health -= damage;

        if (health <= 0)
        {
            Die();
        }
    }


    void Die()
    {
        enemiesController.OnEnemyDie();
        Destroy(Instantiate(deathEffect, deathEffectPos.position, deathEffectPos.rotation), 1f);
        Destroy(gameObject);
    }
}
