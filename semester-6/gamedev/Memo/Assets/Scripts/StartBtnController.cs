using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace Memo
{
  public class StartBtnController : MonoBehaviour, IPointerClickHandler
  {
    public Button btn;
    private GameController gameController;

    void Awake()
    {
      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();
    }

    public void OnPointerClick(PointerEventData d)
    {
      int selectedOpt = GameObject.FindWithTag("BoardSizeDropdown").GetComponent<Dropdown>().value;

      Board board = null;
      switch (selectedOpt)
      {
        case 0:
          board = new Board { Width = 4, Height = 4 };
          break;
        case 1:
          board = new Board { Width = 4, Height = 2 };
          break;
        case 2:
          board = new Board { Width = 2, Height = 2 };
          break;
      }

      gameController.board = board;
      SceneManager.LoadScene("GameScene", LoadSceneMode.Single);
    }
  }
}