using UnityEngine;

namespace Memo
{
  public class ScoreController : MonoBehaviour
  {
    public GameObject scoreText;
    private TMPro.TextMeshProUGUI scoreTextMesh;

    private GameController gameController;

    void Awake()
    {
      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();
      scoreTextMesh = scoreText.GetComponent<TMPro.TextMeshProUGUI>();
    }

    void Update()
    {
      scoreTextMesh.text = gameController.score.ToString();
    }
  }
}