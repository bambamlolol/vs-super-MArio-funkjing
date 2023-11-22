#pragma header

uniform vec2 iResolution;
uniform float iTime;

#define time iTime

#define PI 3.14159265

uniform bool chromaKey;

uniform float offset = 0;
uniform float uTime = 0;

vec3 tex2D( sampler2D _tex, vec2 _p ){
    vec3 col = texture2D( _tex, _p ).xyz;
    if ( 0.5 < abs( _p.x - 0.5 ) ) {
        col = vec3( 0.1 );
    }
    return col;
}

float hash( vec2 _v ){
    return fract( sin( dot( _v, vec2( 89.44, 19.36 ) ) ) * 22189.22 );
}

float iHash( vec2 _v, vec2 _r ){
    float h00 = hash( vec2( floor( _v * _r + vec2( 0.0, 0.0 ) ) / _r ) );
    float h10 = hash( vec2( floor( _v * _r + vec2( 1.0, 0.0 ) ) / _r ) );
    float h01 = hash( vec2( floor( _v * _r + vec2( 0.0, 1.0 ) ) / _r ) );
    float h11 = hash( vec2( floor( _v * _r + vec2( 1.0, 1.0 ) ) / _r ) );
    vec2 ip = vec2( smoothstep( vec2( 0.0, 0.0 ), vec2( 1.0, 1.0 ), mod( _v*_r, 1. ) ) );
    return ( h00 * ( 1. - ip.x ) + h10 * ip.x ) * ( 1. - ip.y ) + ( h01 * ( 1. - ip.x ) + h11 * ip.x ) * ip.y;
}

float noise( vec2 _v ){
    float sum = 0.;
    for( int i=1; i<9; i++ )
    {
        sum += iHash( _v + vec2( i ), vec2( 2. * pow( 2., float( i ) ) ) ) / pow( 2., float( i ) );
    }
    return sum;
}

void main() {
    float sinus = sin(uTime * 30);
    vec2 offsetGen = vec2(sin(uTime * 80) * offset * 0.125, 0);

    vec4 colorR = flixel_texture2D(bitmap, openfl_TextureCoordv + vec2(offset + (sinus * offset * 0.125), 0) + offsetGen);
    vec4 colorG = flixel_texture2D(bitmap, openfl_TextureCoordv + vec2(0, 0) + offsetGen);
    vec4 colorB = flixel_texture2D(bitmap, openfl_TextureCoordv + vec2(-offset + (sinus * offset * 0.125), 0) + offsetGen);

    gl_FragColor = vec4(colorR.r, colorG.g, colorB.b, (colorG.a + colorB.a + colorR.a) / 3);

vec2 fragCoord = openfl_TextureCoordv;
    vec2 uv = openfl_TextureCoordv;
    vec2 uvn = uv;
    vec3 col = vec3( 0.0 );

    // tape wave
    uvn.x += ( noise( vec2( uvn.y, time ) ) - 0.5 )* 0.005;
    uvn.x += ( noise( vec2( uvn.y * 100.0, time * 10.0 ) ) - 0.5 ) * 0.01;

    // tape crease
    float tcPhase = clamp( ( sin( uvn.y * 8.0 - time * PI * 1.2 ) - 0.92 ) * noise( vec2( time ) ), 0.0, 0.01 ) * 10.0;
    float tcNoise = max( noise( vec2( uvn.y * 100.0, time * 10.0 ) ) - 0.5, 0.0 );
    uvn.x = uvn.x - tcNoise * tcPhase;

    // switching noise
    float snPhase = smoothstep( 0.03, 0.0, uvn.y );
    uvn.y += snPhase * 0.3;
    uvn.x += snPhase * ( ( noise( vec2( uv.y * 100.0, time * 10.0 ) ) - 0.5 ) * 0.2 );

    col = tex2D( bitmap, uvn );
    col *= 1.0 - tcPhase;
    col = mix(
        col,
        col.yzx,
        snPhase
    );

    // bloom
    for( float x = -4.0; x < 2.5; x += 1.0 ){
        col.xyz += vec3(
            tex2D(bitmap, uvn + vec2( x - 0.0, 0.0 ) * 7E-3 ).x,
            tex2D(bitmap, uvn + vec2( x - 2.0, 0.0 ) * 7E-3 ).y,
            tex2D(bitmap, uvn + vec2( x - 4.0, 0.0 ) * 7E-3 ).z
        ) * 0.1;
    }
    col *= 0.75;

    // ac beat
    col *= 1.0 + clamp( noise( vec2( 0.0, uv.y + time * 0.2 ) ) * 0.6 - 0.25, 0.0, 0.1 );

    vec4 a = texture2D(bitmap, uv);

    for( float x = -4.0; x < 2.5; x += 1.0 ){
        a += vec4(
            tex2D(bitmap, uvn + vec2( x - 0.0, 0.0 ) * 7E-3 ).x,
            tex2D(bitmap, uvn + vec2( x - 2.0, 0.0 ) * 7E-3 ).y,
            tex2D(bitmap, uvn + vec2( x - 4.0, 0.0 ) * 7E-3 ).z,
            0
        ) * 0.1;
    }
        gl_FragColor = vec4(col, 1.0 );
}