using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace Memo
{
  public class RestartBtnController : MonoBehaviour, IPointerClickHandler
  {
    public Button btn;
    private GameController gameController;

    public void OnPointerClick(PointerEventData d)
    {
      gameController.Reset();
      SceneManager.LoadScene("StartScene", LoadSceneMode.Single);
    }

    void Awake()
    {
      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();
    }
  }
}