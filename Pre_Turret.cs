using UnityEngine;
using System.Collections;

public class Pre_Turret : MonoBehaviour
{

    private Vector3 builtSiteCenter;

    // Use this for initialization
    void Start()
    {
        // turn on build sites
        GameManager.jarvis.setBuildSite(true);
    }

    // Update is called once per frame
    void Update()
    {
        // Check if mouse is pointing at build site
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 100))
        {
            // Debug.Log("Mouse position: " + hit.point.ToString());
            // Check for mouse click while mouse is on build site, create currently selected weapon if true
            if (hit.transform.tag == "build_site")
            {
                builtSiteCenter = (hit.transform.position + new Vector3(0f, 1.5f, 0f));
                transform.position = builtSiteCenter;
                if (Input.GetButtonDown("Fire1"))
                {
                    Instantiate(Resources.Load(GameManager.jarvis.getWeapon), (builtSiteCenter - new Vector3(0f, 0.8f, 0f)), Quaternion.Euler(0, 0, 0));
                    GameManager.jarvis.decreaseExperience(GameManager.jarvis.getWeaponCost());
                    // Remove used build site and hide remaining build sites
                    Destroy(hit.transform.gameObject);
                    GameManager.jarvis.setBuildSite(false);
                    Destroy(gameObject);

                    // Trigger enemy spawning and inform player
                    if (GameManager.jarvis.isFirstTower == true)
                    {
                        GameManager.jarvis.setFirstTower();
                        GameManager.jarvis.broadcast("Incomming enemies, build a second tower");
                    }
                }

                if (Input.GetButtonDown("Cancel"))
                {
                    GameManager.jarvis.setBuildSite(false);
                    Destroy(gameObject);
                }
                }
                else
                {
                    gameObject.transform.position = hit.point + Vector3.up * 1.6f;
                }
            // Display weapon outline if valid build site
            gameObject.GetComponent<Renderer>().enabled = true;
            }

            // Hide weapon outline if not valid build site
            else
            {
                gameObject.GetComponent<Renderer>().enabled = false;
            }
        }
    }

