using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttachCamera : MonoBehaviour
{
    public GameObject player;
    public Vector3 offset = new Vector3(0f, 1.3f, -3.3f);

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 playerPosition = player.transform.position;
        transform.position = playerPosition + offset;
    }
}
