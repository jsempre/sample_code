using UnityEngine;
using System.Collections;

public class DashBoard : MonoBehaviour {

	public GUISkin skin = null;

	public float widthPercent = 0.25f;
	public float heightPercent = 0.3f;

	public GameObject player;
	bool guiOn = false;

	void OnGUI() {

		if (guiOn) {	
			GUI.skin = skin;  
			// Calculate the menu size
			Rect r = new Rect (Screen.width * (1 - widthPercent),
			Screen.height * (1 - heightPercent) / 2,
			Screen.width * widthPercent,
			Screen.height * heightPercent); 
			GUILayout.BeginArea (r);
			GUILayout.BeginVertical ("box");   
			
            // Basic menu of available weapons
			if (GUILayout.Button ("Spray Bottle")){
				GameManager.jarvis.createWeapon("spray_bottle");
			}

			if (GUILayout.Button ("Fireball Turret")){
				GameManager.jarvis.createWeapon("Turret_fireball");
			}

			if (GUILayout.Button ("Wall")){
				Instantiate(Resources.Load ("prewall"), new Vector3(0,0,0), Quaternion.Euler(270,90,90));
			}			
			GUILayout.EndVertical ();        
			GUILayout.EndArea (); 

		}
	}

	void Update(){
		if(Input.GetKeyDown(KeyCode.LeftShift)) guiOn = !guiOn;
	}
	
}
