using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectGems : MonoBehaviour
{
    private int score = 0;

    private void OnTriggerEnter(Collider other)
    {
        score++;
        print("Score " + score);
        Destroy(other.gameObject);
    }
}
