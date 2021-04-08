using UnityEngine;

public class GameState : MonoBehaviour
{
    public bool paused = false;

    void Start()
    {
        DontDestroyOnLoad(gameObject);
    }
}