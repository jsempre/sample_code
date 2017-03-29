using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelInitialization : MonoBehaviour {

    // Define objects in the inspector to hold tower build sites and enemy waypoints
    private string buildSite = "build_site";
    private string wayPoint = "waypoint";
    public GameObject buildSiteGroup;
    public GameObject wayPointGroup;

	// Use this for initialization
	void Start () {
        int counter = 0;
        // Create grid of build sites spaced every 2 units.
        for (int i =-24; i < 24; i+=2)
        {
            // Testing more complex build site patterns
            // Debug.Log("sin(i): " + Mathf.Round(Mathf.Abs(24 * Mathf.Tan(i/24))) );
            for (int j = -24; j < 24; j+=2)
            {
                // Leave clear path down center for enemies
                if (j != 0 )
                {
                    createBuildSite(j, i);
                }
                // Create waypoints for enemy navigation on clear path
                else
                {
                    createWaypoint(j, i, counter);
                    counter++;
                }
            }
        }

    }
	
	// Update is called once per frame
	void Update () {
		
	}

    private static LevelInitialization levelInitialization;

    public static LevelInitialization Instance()
    {
        if (!levelInitialization)
        {
            levelInitialization = FindObjectOfType(typeof(LevelInitialization)) as LevelInitialization;
            if (!levelInitialization)
                Debug.LogError("There needs to be one active LevelInitialization script on a GameObject in your scene.");
        }

        return levelInitialization;
    }

    public static LevelInitialization Initialize()
    {
        levelInitialization.createBuildSite(0, 0);
        return levelInitialization;
    }

    public void createBuildSite(int x, int z)
    {
        // Spawn buildsite prefab at indicated x,z coordinate
        Instantiate(Resources.Load(buildSite), new Vector3(x, 0, z), Quaternion.Euler(0, 0, 0), buildSiteGroup.transform);
    }

    public void createWaypoint(int x, int z, int counter)
    {
        // Spawn waypoint prefab at indicated x,z coordinate
        Object wayPointClone = new Object();
        wayPointClone = Instantiate(Resources.Load(wayPoint), new Vector3(x, 0, z), Quaternion.Euler(0, 0, 0), wayPointGroup.transform);
        wayPointClone.name = "waypoint" + counter;
    }

}
