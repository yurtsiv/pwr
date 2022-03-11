using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameOverText : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var controller = GameObject.FindGameObjectWithTag("GameController");
        GetComponent<Text>().text = controller.GetComponent<GameController>().Won() ? "You won" : "Game over";        
    }

}
