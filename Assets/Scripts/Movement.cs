using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour {
    public float speed = 2f;
    public float jumpSpeed = 1f;

    private Rigidbody rb;

    private Vector3 forward = new Vector3(0, 0, 1);
    private Vector3 backward = new Vector3(0, 0, -1);
    private Vector3 right = new Vector3(1, 0, 0);
    private Vector3 left = new Vector3(-1, 0, 0);

    private Vector3 jump = new Vector3(0, 5, 0);

    private bool playerOnGround = true;

    // Start is called before the first frame update
    void Start() {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update() {
        if (Input.GetKey(KeyCode.W))
            rb.AddForce(forward * speed);
        if (Input.GetKey(KeyCode.A))
            rb.AddForce(left * speed);
        if (Input.GetKey(KeyCode.S))
            rb.AddForce(backward * speed);
        if (Input.GetKey(KeyCode.D))
            rb.AddForce(right * speed);

        /*float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        transform.Translate(new Vector3(horizontal, 0, vertical) * speed);*/

        if (Input.GetButtonDown("Jump") && playerOnGround) {
            rb.AddForce(jump * jumpSpeed, ForceMode.Impulse);
            playerOnGround = false;
        }
    }

    private void OnCollisionEnter(Collision collision) {
        if (collision.gameObject.tag == "Ground") {
            playerOnGround = true;
        }
    }
}
