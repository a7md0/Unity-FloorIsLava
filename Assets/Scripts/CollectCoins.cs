using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectCoins : MonoBehaviour
{
    private int score = 0;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Coin") {
            score++;
            print("Score " + score);
            Destroy(other.gameObject);
        }
    }
}
