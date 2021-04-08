using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMovement : MonoBehaviour
{
    public CharacterController2D controller;
    public float runSpeed = 110f;
    public Animator animator;
    public GameState gameState;

    float horizontalMove = 0f;
    bool jump = false;
    bool crouch = false;

    void Update()
    {
    }

    void FixedUpdate()
    {
        controller.Move(horizontalMove * Time.fixedDeltaTime, crouch, jump);
    }

    public void OnMove(InputAction.CallbackContext ctx)
    {
        if (gameState.paused)
        {
            return;
        }

        Vector2 movement = ctx.ReadValue<Vector2>();


        horizontalMove = movement.x * runSpeed;

        animator.SetFloat("speed", Mathf.Abs(horizontalMove));

        if (movement.y > 0)
        {
            jump = true;
            animator.SetBool("jumping", true);
        }
        else
        {
            crouch = movement.y < 0;
        }
    }

    public void OnLanding()
    {
        jump = false;
        animator.SetBool("jumping", false);
    }

    public void OnCrouching(bool isCrouching)
    {
        animator.SetBool("crouching", isCrouching);
    }
}
