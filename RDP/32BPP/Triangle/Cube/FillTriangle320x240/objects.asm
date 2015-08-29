// Object Triangle Vertices: X, Y, Z (Clockwise Winding), Triangle Color R8G8B8A8
CubeTri:
  // Cube Front Face
  float32 -10.0,  10.0, -10.0 // Triangle 0 Top Left
  float32  10.0,  10.0, -10.0 // Triangle 0 Top Right
  float32 -10.0, -10.0, -10.0 // Triangle 0 Bottom Left
  dd $FF0000FF // Triangle 0 Color (Red)
  float32  10.0,  10.0, -10.0 // Triangle 1 Top Right
  float32  10.0, -10.0, -10.0 // Triangle 1 Bottom Right
  float32 -10.0, -10.0, -10.0 // Triangle 1 Bottom Left
  dd $770000FF // Triangle 1 Color (Dark Red)

  // Cube Back Face
  float32  10.0,  10.0,  10.0 // Triangle 0 Top Right
  float32 -10.0,  10.0,  10.0 // Triangle 0 Top Left
  float32  10.0, -10.0,  10.0 // Triangle 0 Bottom Right
  dd $00FF00FF // Triangle 0 Color (Green)
  float32 -10.0,  10.0,  10.0 // Triangle 1 Top Left
  float32 -10.0, -10.0,  10.0 // Triangle 1 Bottom Left
  float32  10.0, -10.0,  10.0 // Triangle 1 Bottom Right
  dd $007700FF // Triangle 1 Color (Dark Green)

  // Cube Left Face
  float32 -10.0,  10.0,  10.0 // Triangle 0 Top Left
  float32 -10.0,  10.0, -10.0 // Triangle 0 Top Right
  float32 -10.0, -10.0,  10.0 // Triangle 0 Bottom Left
  dd $0000FFFF // Triangle 0 Color (Blue)
  float32 -10.0,  10.0, -10.0 // Triangle 1 Top Right
  float32 -10.0, -10.0, -10.0 // Triangle 1 Bottom Right
  float32 -10.0, -10.0,  10.0 // Triangle 1 Bottom Left
  dd $000077FF // Triangle 1 Color (Dark Blue)

  // Cube Right Face
  float32  10.0,  10.0, -10.0 // Triangle 0 Top Left
  float32  10.0,  10.0,  10.0 // Triangle 0 Top Right
  float32  10.0, -10.0, -10.0 // Triangle 0 Bottom Left
  dd $FFFFFFFF // Triangle 0 Color (White)
  float32  10.0,  10.0,  10.0 // Triangle 1 Top Right
  float32  10.0, -10.0,  10.0 // Triangle 1 Bottom Right
  float32  10.0, -10.0, -10.0 // Triangle 1 Bottom Left
  dd $777777FF // Triangle 1 Color (Gray)

  // Cube Top Face
  float32  10.0,  10.0, -10.0 // Triangle 0 Top Right
  float32 -10.0,  10.0, -10.0 // Triangle 0 Top Left
  float32 -10.0,  10.0,  10.0 // Triangle 0 Bottom Left
  dd $FF00FFFF // Triangle 0 Color (Purple)
  float32  10.0,  10.0, -10.0 // Triangle 1 Top Right
  float32 -10.0,  10.0,  10.0 // Triangle 1 Bottom Left
  float32  10.0,  10.0,  10.0 // Triangle 1 Bottom Right
  dd $770077FF // Triangle 1 Color (Dark Purple)

  // Bottom Face
  float32 -10.0, -10.0, -10.0 // Triangle 0 Top Left
  float32  10.0, -10.0, -10.0 // Triangle 0 Top Right
  float32  10.0, -10.0,  10.0 // Triangle 0 Bottom Right
  dd $00FFFFFF // Triangle 0 Color (Cyan)
  float32 -10.0, -10.0, -10.0 // Triangle 1 Top Left
  float32  10.0, -10.0,  10.0 // Triangle 1 Bottom Right
  float32 -10.0, -10.0,  10.0 // Triangle 1 Bottom Left
  dd $007777FF // Triangle 1 Color (Dark Cyan)
CubeTriEnd: