using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlackLightScript : MonoBehaviour
{
    public Transform centerObject;
    public float radius = 10f;

    // Update is called once per frame
    void Update()
    {
        if(centerObject!=null)
        {
            Renderer[] renderers = FindObjectsOfType<Renderer>();
            foreach(Renderer renderer in renderers)
            {
                foreach(Material material in renderer.materials)
                {
                    if(material.shader.name=="Unlit/BlackLight")
                    {
                        material.SetVector("_Center", new Vector4(centerObject.position.x, centerObject.position.y, centerObject.position.z, 0));

                        material.SetFloat("_Radius", radius);
                    }
                }
            }
        }
    }
}
