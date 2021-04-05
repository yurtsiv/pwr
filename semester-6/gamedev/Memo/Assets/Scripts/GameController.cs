using UnityEngine;
using UnityEngine.SceneManagement;

namespace Memo
{
  public class Board
  {
    public int Width { get; set; }
    public int Height { get; set; }
  }

  public class GameController : MonoBehaviour
  {
    public Board board { get; set; }

    private TMPro.TextMeshPro scoreTextMesh;
    public bool gameWon = false;
    public int score = 0;

    private int cardsGuessed = 0;

    private void GameOver()
    {
      SceneManager.LoadScene("GameOver");
    }

    public void OnGuessed()
    {
      cardsGuessed += 2;

      if (cardsGuessed == board.Width * board.Height)
      {
        gameWon = true;
        GameOver();
      }
      else
      {
        score += 10;
      }
    }

    public void OnNotGuessed()
    {
      score -= 2;

      if (score <= -10)
      {
        gameWon = false;
        GameOver();
      }
    }

    public void Reset()
    {
      board = null;
      gameWon = false;
      cardsGuessed = 0;
      score = 0;
    }

    void Awake()
    {
      GameObject[] objs = GameObject.FindGameObjectsWithTag("GameController");

      if (objs.Length > 1)
      {
        Destroy(this.gameObject);
      }

      DontDestroyOnLoad(this.gameObject);
    }

    void Start()
    {
    }

    void Update()
    {
    }
  }
}