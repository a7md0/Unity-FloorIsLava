using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    public float lavaDamageInterval = 2;
    public float maxHP = 50;

    private float nextLavaDamage;
    private float currentHP;

    // Start is called before the first frame update
    void Start() {
        nextLavaDamage = Time.time;
        currentHP = maxHP;
    }

    // Update is called once per frame
    void Update() {
        
    }

    private void OnTriggerStay(Collider other) {
        if (other.gameObject.tag == "Lava") {
            if (nextLavaDamage < Time.time) {
                currentHP -= 5;
                nextLavaDamage = Time.time + lavaDamageInterval;

                Debug.Log($"Took damage from lava; HP: {currentHP}");

                if (currentHP <= 0f) {
                    Destroy(this.gameObject);

                    Debug.Log($"Died from lava; HP: {currentHP}");
                }
            }
        }
    }

    /*private void OnCollisionStay(Collision col) {
        if (col.gameObject.tag == "Lava") {
            if (nextLavaDamage < Time.time) {
                currentHP -= 5;
                nextLavaDamage = Time.time + lavaDamageInterval;

                Debug.Log($"Took damage from lava; HP: {currentHP}");

                if (currentHP <= 0f) {
                    Destroy(this.gameObject);

                    Debug.Log($"Died from lava; HP: {currentHP}");
                }
            }
        }
    }*/
}
