using UnityEngine;
using System.Collections;

public class Turret_AI : MonoBehaviour {
	

	private GameObject closest;
	GameObject[] targets;
	private bool isBeam;
	private GameObject laserSource;
	private LineRenderer laser;

	// Use this for initialization
	void Start () {
		targets = GameObject.FindGameObjectsWithTag("Enemies");
		isBeam = false;
	}
	
	// Update is called once per frame
	void Update () {
		targets = GameObject.FindGameObjectsWithTag("Enemies");
		float distance = Mathf.Infinity;
		Vector3 position = transform.position;
        // Check distance to all enemies and target closest one
		foreach (GameObject target in targets){
			float curDistance = Vector3.Distance(target.transform.position, position);
			if(curDistance < distance){
				closest = target;
				distance = curDistance;
			}
		}
		//Debug.Log("Enemy Distance: " + distance.ToString());

        // Render 'weapon active' object and send damage amounts to closest enemy
		if ((targets.Length > 0) && (distance < 7)){
			if(isBeam == false){
				laserSource = (GameObject)Instantiate(Resources.Load ("Laser"));
				isBeam = true;
			}

			laser = laserSource.GetComponent<LineRenderer>();
			laser.SetPosition (0, transform.position);
			laser.SetPosition (1, closest.transform.position);
			closest.SendMessage("takeDamage",(10f * Time.deltaTime));
		}

        // Remove 'weapon active' object when all enemies out of range
		else {
			if (isBeam == true){
				Destroy(laserSource);
				isBeam = false;
			}
		}
	}
}
