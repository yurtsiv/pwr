using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameController : MonoBehaviour
{
    bool won = false;

    void Start()
    {
        DontDestroyOnLoad(this);
    }

    private void GameOver()
    {
        Cursor.lockState = CursorLockMode.None;
        SceneManager.LoadScene("GameOver");
    }

    public void OnLoose()
    {
        won = false;
        GameOver();

    }

    public void OnWin()
    {
        won = true;
        GameOver();
    }

    public bool Won()
    {
        return won;
    }
}
