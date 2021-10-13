cbuffer ModelViewProjectionConstantBuffer : register(b0)
{
	matrix model;
	matrix view;
	matrix projection;
};

struct VertexShaderInput
{
	float3 pos : POSITION;
	//float3 color : COLOR0;
	float3 color : NORMAL;
};

struct PixelShaderInput
{
	float4 pos : SV_POSITION;
	float3 color : COLOR0;
};

struct PixelShaderInput_2
{
	float4 pos : SV_POSITION;
	float3 normal : NORMAL;
	float4 pos3D  : POSITION;
};

//función de iluminación
float4 PhongModel(float4 Pos, float3 Normal)
{
	float4 Color = float4(0.2, 0.1, 0.3, 1);
	float3 EyeToPos = normalize(Pos - float4(0, 0.7, 1.5, 1.0));
	float3 LightToPos = float3(0, 0, 0), Reflected = float3(0, 0, 0);
	float4 LightPos = float4(2, 20, 10, 1);
	float DiffuseIntensity = 0, Spec = 0;
	float3 g_vLightPos[3] = { float3(0, 6, 0), float3(10, 0, 0),
	float3(-10, -10, 0) };
	float4 g_vLightColor[3] = { float4(0.6, 0.6, 0.6, 1), float4(0, 0.2, 0.7, 1), float4(1, 0.3, 0, 1) };

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
		float g_Specular = 0.3;
		Color = Color + g_vLightColor[i] * ((DiffuseIntensity * g_Diffuse) + (Spec * g_Specular));
	}



	return Color;
}


/*
PixelShaderInput main(VertexShaderInput input)
{
	PixelShaderInput output;
	float4 pos = float4(input.pos, 1.0f);
	pos = mul(pos, model);
	pos = mul(pos, view);

	float4 pos2 = pos;
	pos = mul(pos, projection);
	output.pos = pos;
	float4 normal = mul(float4(input.color,0), model);
	normal = mul(normal, view);
	output.color = PhongModel(pos2,normal);
	//output.color = input.color;

	return output;
}
*/


PixelShaderInput_2 main(VertexShaderInput input)
{
	PixelShaderInput_2 output;
	float4 pos = float4(input.pos, 1.0f);
	pos = mul(pos, model);
	pos = mul(pos, view);

	float4 pos2 = pos;
	pos = mul(pos, projection);
	output.pos = pos;
	float4 normal = mul(float4(input.color, 0), model);
	normal = mul(normal, view);
	//output.color = PhongModel(pos2, normal);
	//output.color = input.color;
	output.pos3D = pos2;
	output.normal = normal;
	return output;
}

