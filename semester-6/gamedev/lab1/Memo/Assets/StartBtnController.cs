using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class StartBtnController : MonoBehaviour, IPointerClickHandler
{
  // Start is called before the first frame update
  public Button btn;

  public void OnPointerClick(PointerEventData d)
  {
    Debug.Log("HORRAY");
  }

  void Start()
  {

  }

  // Update is called once per frame
  void Update()
  {

  }
}
