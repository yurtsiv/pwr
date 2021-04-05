using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace Memo
{
  public class GameOverController : MonoBehaviour
  {
    public GameObject text;
    private TMPro.TextMeshProUGUI textMesh;
    private GameController gameController;

    void Awake()
    {
      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();
      textMesh = text.GetComponent<TMPro.TextMeshProUGUI>();
    }

    void Start()
    {
      if (gameController.gameWon)
      {
        textMesh.text = "YOU WIN\n\nSCORE: " + gameController.score.ToString();
      }
      else
      {
        textMesh.text = "YOU LOOSE";
      }
    }
  }
}
