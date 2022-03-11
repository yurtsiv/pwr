using UnityEngine;
using UnityEngine.UI;

public class Settings : MonoBehaviour
{
    public Button muteButton;
    public Slider volumeSlider;

    bool muted = false;

    void Start()
    {
        volumeSlider.onValueChanged.AddListener(delegate {OnVolumeSliderChange();});
        muteButton.onClick.AddListener(ToggleMute);
    }

    void OnVolumeSliderChange()
    {
        if (!muted) {
            AudioListener.volume = volumeSlider.value / 100;
        }
    }

    void ToggleMute()
    {
        muted = !muted;
        muteButton.GetComponentInChildren<TMPro.TextMeshProUGUI>().text = muted ? "Unmute" : "Mute";
        AudioListener.volume = muted ? 0 : volumeSlider.value / 100;
    }
}