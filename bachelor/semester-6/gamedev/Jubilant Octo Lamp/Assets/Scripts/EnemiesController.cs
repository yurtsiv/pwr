using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemiesController : MonoBehaviour
{
    public GameController gameController;
    public GameObject enemy;
    public Transform[] spawnPoints;
    public int numOfEnemies = 10;
    int currNumOfEnemies;

    // Start is called before the first frame update
    void Start()
    {
        currNumOfEnemies = numOfEnemies;
        SpawnEnemies();
    }

    public void OnEnemyDie()
    {
        currNumOfEnemies--;

        if (currNumOfEnemies == 0)
        {
            gameController.OnWin();
        }
    }

    public int CurrNumOfEnemies()
    {
        return currNumOfEnemies;
    }

    void SpawnEnemies()
    {
        var remainingEnemies = numOfEnemies - 1;
        var spawnIdx = 0;
        while (remainingEnemies > 0)
        {
            Instantiate(enemy, spawnPoints[spawnIdx].position, spawnPoints[spawnIdx].rotation);
            spawnIdx = (spawnIdx + 1) % spawnPoints.Length;
            remainingEnemies--;
        }
    }

}
