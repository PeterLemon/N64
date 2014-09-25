; Object Triangle Vertices: X, Y, Z (Clockwise Winding), Triangle Color R8G8B8A8
CubeTri:
  ; Cube Front Face
  IEEE32 -10.0,  10.0, -10.0 ; Triangle 0 Top Left
  IEEE32  10.0,  10.0, -10.0 ; Triangle 0 Top Right
  IEEE32 -10.0, -10.0, -10.0 ; Triangle 0 Bottom Left
  dw $FF0000FF ; Triangle 0 Color (Red)
  IEEE32  10.0,  10.0, -10.0 ; Triangle 1 Top Right
  IEEE32  10.0, -10.0, -10.0 ; Triangle 1 Bottom Right
  IEEE32 -10.0, -10.0, -10.0 ; Triangle 1 Bottom Left
  dw $770000FF ; Triangle 1 Color (Dark Red)

  ; Cube Back Face
  IEEE32  10.0,  10.0,  10.0 ; Triangle 0 Top Right
  IEEE32 -10.0,  10.0,  10.0 ; Triangle 0 Top Left
  IEEE32  10.0, -10.0,  10.0 ; Triangle 0 Bottom Right
  dw $00FF00FF ; Triangle 0 Color (Green)
  IEEE32 -10.0,  10.0,  10.0 ; Triangle 1 Top Left
  IEEE32 -10.0, -10.0,  10.0 ; Triangle 1 Bottom Left
  IEEE32  10.0, -10.0,  10.0 ; Triangle 1 Bottom Right
  dw $007700FF ; Triangle 1 Color (Dark Green)

  ; Cube Left Face
  IEEE32 -10.0,  10.0,  10.0 ; Triangle 0 Top Left
  IEEE32 -10.0,  10.0, -10.0 ; Triangle 0 Top Right
  IEEE32 -10.0, -10.0,  10.0 ; Triangle 0 Bottom Left
  dw $0000FFFF ; Triangle 0 Color (Blue)
  IEEE32 -10.0,  10.0, -10.0 ; Triangle 1 Top Right
  IEEE32 -10.0, -10.0, -10.0 ; Triangle 1 Bottom Right
  IEEE32 -10.0, -10.0,  10.0 ; Triangle 1 Bottom Left
  dw $000077FF ; Triangle 1 Color (Dark Blue)

  ; Cube Right Face
  IEEE32  10.0,  10.0, -10.0 ; Triangle 0 Top Left
  IEEE32  10.0,  10.0,  10.0 ; Triangle 0 Top Right
  IEEE32  10.0, -10.0, -10.0 ; Triangle 0 Bottom Left
  dw $FFFFFFFF ; Triangle 0 Color (White)
  IEEE32  10.0,  10.0,  10.0 ; Triangle 1 Top Right
  IEEE32  10.0, -10.0,  10.0 ; Triangle 1 Bottom Right
  IEEE32  10.0, -10.0, -10.0 ; Triangle 1 Bottom Left
  dw $777777FF ; Triangle 1 Color (Gray)

  ; Cube Top Face
  IEEE32  10.0,  10.0, -10.0 ; Triangle 0 Top Right
  IEEE32 -10.0,  10.0, -10.0 ; Triangle 0 Top Left
  IEEE32 -10.0,  10.0,  10.0 ; Triangle 0 Bottom Left
  dw $FF00FFFF ; Triangle 0 Color (Purple)
  IEEE32  10.0,  10.0, -10.0 ; Triangle 1 Top Right
  IEEE32 -10.0,  10.0,  10.0 ; Triangle 1 Bottom Left
  IEEE32  10.0,  10.0,  10.0 ; Triangle 1 Bottom Right
  dw $770077FF ; Triangle 1 Color (Dark Purple)

  ; Bottom Face
  IEEE32 -10.0, -10.0, -10.0 ; Triangle 0 Top Left
  IEEE32  10.0, -10.0, -10.0 ; Triangle 0 Top Right
  IEEE32  10.0, -10.0,  10.0 ; Triangle 0 Bottom Right
  dw $00FFFFFF ; Triangle 0 Color (Cyan)
  IEEE32 -10.0, -10.0, -10.0 ; Triangle 1 Top Left
  IEEE32  10.0, -10.0,  10.0 ; Triangle 1 Bottom Right
  IEEE32 -10.0, -10.0,  10.0 ; Triangle 1 Bottom Left
  dw $007777FF ; Triangle 1 Color (Dark Cyan)
CubeTriEnd: