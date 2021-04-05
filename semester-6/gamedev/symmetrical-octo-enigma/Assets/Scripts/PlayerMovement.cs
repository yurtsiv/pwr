using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMovement : MonoBehaviour
{
    public CharacterController2D controller;
    public float runSpeed = 110f;

    float horizontalMove = 0f;
    bool jump = false;
    bool crouch = false;

    void Update()
    {
        // horizontalMove = Input.GetAxisRaw("Horizontal");
    }

    void FixedUpdate()
    {
        controller.Move(horizontalMove * runSpeed * Time.fixedDeltaTime, crouch, jump);
        jump = false;
    }

    public void OnMove(InputAction.CallbackContext ctx)
    {
        Vector2 movement = ctx.ReadValue<Vector2>();


        horizontalMove = movement.x;

        if (movement.y > 0)
        {
            jump = true;
        }
        else if (movement.y < 0)
        {
            crouch = true;
        }
        else
        {
            crouch = false;
        }
    }
}
