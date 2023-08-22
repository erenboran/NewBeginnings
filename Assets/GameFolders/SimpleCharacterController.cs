using UnityEngine;

public class SimpleCharacterController : MonoBehaviour
{
    public float moveSpeed = 5f; // Karakterin hareket h�z�
    public float rotationSpeed = 300f; // Karakterin d�n�� h�z�

    private CharacterController characterController; // Karakterin Character Controller bile�eni

    private void Awake()
    {
        // Gerekli bile�enleri al
        characterController = GetComponent<CharacterController>();
    }

    private void Update()
    {
        // Hareket kontrolleri
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector3 movement = new Vector3(horizontal, 0f, vertical);

        // Fare ile karakteri d�n
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit))
        {
            Vector3 lookAtPosition = new Vector3(hit.point.x, transform.position.y, hit.point.z);
            transform.LookAt(lookAtPosition);
        }

        // Karakteri d�n
        if (movement != Vector3.zero)
        {
            Quaternion targetRotation = Quaternion.LookRotation(movement);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, targetRotation, rotationSpeed * Time.deltaTime);
        }

        // Karakteri hareket ettir
        characterController.SimpleMove(movement * moveSpeed);
    }
}
