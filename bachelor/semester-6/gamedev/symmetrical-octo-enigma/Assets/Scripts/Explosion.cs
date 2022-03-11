using UnityEngine;
using System.Collections;

public class Explosion : MonoBehaviour
{
    void Start()
    {
        Invoke("RemoveObject", 0.5f);
    }

    void RemoveObject()
    {
        Destroy(gameObject);
    }
}