using UnityEngine;
using System.Collections;

public class Fireball : MonoBehaviour {

	private float startTime;
	private float journeyLength;
	public Vector3 source;
	public Vector3 target;
	public float speed;
	// Use this for initialization
	void Start () {
		startTime = Time.time;
		journeyLength = Vector3.Distance (source, target);
	}
	
	// Update is called once per frame
	void Update () {
        // Only keep fireball object active until it reaches original target position
		float distCovered = (Time.time - startTime) * speed;
		float journeyProgress = distCovered / journeyLength;
		transform.position = Vector3.Lerp (source, target, journeyProgress);
		if (transform.position == target) {
			Destroy (gameObject);
		}
	}

	void OnCollisionEnter(Collision other) {
        // If collision with enemy send damage amount
		if (other.gameObject.tag == "Enemies") {
			other.gameObject.SendMessage("takeDamage",(50f));
			Destroy(gameObject);
		}
	}
}
