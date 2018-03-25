using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombinedUnlitScript : MonoBehaviour {

	private Material material;
	private Shader shader;

	public GameObject light1;

	void Awake () {

		material = GetComponent<MeshRenderer>().material;

		shader = material.shader;

	}

	void Update() {

		Vector3 light1_pos = light1.transform.position;

		material.SetVector( "_Light1_Pos", new Vector4( light1_pos.x, light1_pos.y, light1_pos.z, 0.0f ) );

	}

}
