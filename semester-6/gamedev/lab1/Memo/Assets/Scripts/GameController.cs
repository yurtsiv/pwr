using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
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