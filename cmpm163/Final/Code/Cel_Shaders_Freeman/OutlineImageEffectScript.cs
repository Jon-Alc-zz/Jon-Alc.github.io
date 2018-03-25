using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlineImageEffectScript : MonoBehaviour {

	private Material material;

	void Awake() {

		material = new Material( Shader.Find( "Hidden/OutlineImageEffect") );

	}

	void OnRenderImage( RenderTexture source, RenderTexture destination ) {

		Graphics.Blit( source, destination, material );

	}

}
