using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

namespace Memo
{
  public class RestartBtnController : MonoBehaviour, IPointerClickHandler
  {
    public InputActionMap actions;

    public Button btn;
    private GameController gameController;

    public void OnPointerClick(PointerEventData d)
    {
      gameController.Reset();
      SceneManager.LoadScene("StartScene", LoadSceneMode.Single);
    }

    void OnRestart(InputAction.CallbackContext obj)
    {
      gameController.Reset();
      SceneManager.LoadScene("StartScene", LoadSceneMode.Single);
    }

    void Awake()
    {
      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();


      actions["restart"].performed += OnRestart;
      actions.Enable();
    }
  }
}