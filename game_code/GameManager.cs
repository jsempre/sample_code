using UnityEngine;
using System.Collections;
using System;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

public class GameManager : MonoBehaviour {
	
    // Singleton style game manager class, define all variables and functions at the global/scene level. 
	public static GameManager jarvis;
	
	public int health;
	public float speed;
	public int experience;
	public int lives;
    public int sprayBottleCost;
	private bool firstTower;
	public GameObject buildSites;
	private string weaponType;
	public GameObject player;
	public GameObject enemySpawner;
	private DisplayManager displayManager;
    private LevelInitialization levelInitialization;

	// Use this for initialization
	void Awake () {
		if (jarvis == null) {
			DontDestroyOnLoad (gameObject);
			jarvis = this;
		} else if (jarvis != this) {
			Destroy (gameObject);
		}
		displayManager = DisplayManager.Instance ();
        levelInitialization = LevelInitialization.Instance();
	}

	void Start () {
		firstTower = true;
	}

	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI(){
		GUI.Label (new Rect (10, 60, 100, 20), "Health: " + health);
		GUI.Label (new Rect (10, 80, 100, 20), "Experience: " + experience);
		GUI.Label (new Rect (10, 100, 100, 20), "Lives: " + lives);
	}

	public void save(){
		BinaryFormatter bf = new BinaryFormatter ();
		FileStream file = File.Create(Application.persistentDataPath + "/00Basenji.sav");

        // Define all data needed to restore gameplay
		PlayerData data = new PlayerData ();
		data.health = health;
		data.experience = experience;
		bf.Serialize (file, data);
		file.Close ();
	}

	public void load(){
		if (File.Exists (Application.persistentDataPath + "/00Basenji.sav")) {
			BinaryFormatter bf = new BinaryFormatter ();
			FileStream file = File.Open (Application.persistentDataPath + "/00Basenji.sav", FileMode.Open);
			PlayerData data = (PlayerData)bf.Deserialize(file);
			file.Close();

            // Define all data from above save function
			health = (int) data.health;
			experience = (int) data.experience;
		}
	}

	[Serializable]
	class PlayerData
	{
		public float health;
		public float experience;
	}

	public void setBuildSite( bool buildSiteState){
		buildSites.SetActive (buildSiteState);
	}

	public void createWeapon(string type){
		weaponType = type;
        if (getWeaponCost() <= experience) {
            Instantiate(Resources.Load(weaponType + "_pre"), new Vector3(0, 0, 0), Quaternion.Euler(0, 0, 0));
        }
        else
        {
            broadcast("Not enough experience");
        }
	}

	public string getWeapon{ get { return weaponType; } }

    public int getWeaponCost()
    {
        switch (weaponType)
        {
            case "spray_bottle":
                return sprayBottleCost;
            default:
                return 100;
        }
        
    }

	public GameObject getPlayer{ get { return player; } }

	public bool isFirstTower{ get { return firstTower; } }

	public void setFirstTower(){
		firstTower = false;
		enemySpawner.SetActive(true);
	}

	public void broadcast(string message){
		displayManager.DisplayMessage (message);
	}

	public void decreaseLives(){
		lives--;
        if(lives <= 0)
        {
            broadcast("Game Over");
            Time.timeScale = 0;
        }
	}

	public void increaseExperience(int xp){
		experience += xp;
	}

    public void decreaseExperience(int xp)
    {
        experience -= xp;
    }

    public int getExperiene { get { return experience; } }

}
