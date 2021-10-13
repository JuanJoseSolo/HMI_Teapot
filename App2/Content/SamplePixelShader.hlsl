struct PixelShaderInput
{
	float4 pos : SV_POSITION;
	float3 color : COLOR0;
};

/*
float4 main(PixelShaderInput input) : SV_TARGET
{
	 return float4(input.color, 3.0f);
	//return float4(1.0,0,0,1.0);
}
*/


//////////////////////////////////

struct PixelShaderInput_2
{
	float4 pos : SV_POSITION;
	float3 normal : NORMAL;
	float4 pos3D  : POSITION;
};


//funci�n de iluminaci�n
float4 PhongModel(float4 Pos, float3 Normal)
{
	float4 Color = float4(0.2, 0.1, 0.3, 1);
	float3 EyeToPos = normalize(Pos - float4(0, 0.7, 1.5, 1.0));
	float3 LightToPos = float3(0, 0, 0), Reflected = float3(0, 0, 0);
	float4 LightPos = float4(2, 20, 10, 1);
	float DiffuseIntensity = 0, Spec = 0;
	float3 g_vLightPos[3] = { float3(0, 6, 0), float3(10, 0, 0),
	float3(-10, -10, 0) };
	float4 g_vLightColor[3] = { float4(0.6, 0.6, 0.6, 1), float4(0.1, 0.9, 0.1, 1), float4(1, 0.3, 0, 1) };

	for (int i = 0; i < 3; i++)
	{
		LightPos = float4(g_vLightPos[i], 1);
		LightToPos = normalize(Pos - LightPos);

		// Compute the diffuse component
		DiffuseIntensity = saturate(dot(-LightToPos, Normal));

		// Compute the specular component
		Reflected = normalize(LightToPos - 2 * dot(Normal, LightToPos) * Normal);
		Spec = saturate(dot(-Reflected, EyeToPos));
		Spec = pow(max(Spec, 0), 120);
		float g_Diffuse = 0.6;
		float g_Specular = 0.8;
		Color = Color + g_vLightColor[i] * ((DiffuseIntensity * g_Diffuse) + (Spec * g_Specular));
	}
	return Color;
}

float4 main(PixelShaderInput_2 input) : SV_TARGET
{
	 return PhongModel(input.pos3D, input.normal);//float4(input.color, 3.0f);
	//return float4(1.0,0,0,1.0);
}
