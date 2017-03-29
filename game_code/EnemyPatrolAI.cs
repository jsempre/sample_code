using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Linq;

public class EnemyPatrolAI : BaseEntity {

	private Vector3 playerPos;
	public Slider enemyHealthBar;
	private int goalTag = 0;
	private GameObject[] goal;
	private GameObject targetPlayer;

	// Use this for initialization
	void Start () {
        // Build goal array once (per enemy) at start of script and order by name
		goal = GameObject.FindGameObjectsWithTag("Goal").OrderBy(go => go.name).ToArray();
        // Set player target to current player of the scene
		targetPlayer = GameObject.FindWithTag ("Player");
	}

	// Update is called once per frame
	void Update () {
		playerPos = targetPlayer.transform.position;
		float distanceToPlayer = Vector3.Distance(transform.position, playerPos);
		float distanceToGoal = Vector3.Distance (transform.position, goal[goalTag].transform.position);
        // Set enemy nav agent to player if closer than 5 units
        if (distanceToPlayer < 5) {
			GetComponent<UnityEngine.AI.NavMeshAgent> ().destination = playerPos;
			} 
        // Set enemy nav agent back to the next waypoint, move to next waypoint upon reaching.
		else {
			if ((distanceToGoal < 1) && (goalTag < (goal.Length-1))){
				goalTag++;
                // Logging to watch enemy path
				Debug.Log(goal[goalTag].name);
				Debug.Log("goalTag: " + goalTag + " goal Length: " + goal.Length);
			}
			GetComponent<UnityEngine.AI.NavMeshAgent> ().destination = goal[goalTag].transform.position;
			}
        // Ensure health bar is current
		enemyHealthBar.value = currentHealth;
	}
}
