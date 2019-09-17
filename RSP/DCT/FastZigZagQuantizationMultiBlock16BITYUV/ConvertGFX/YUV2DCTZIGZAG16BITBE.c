#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

unsigned char yuv_file[16777216];
unsigned char dct_file[16777216];
unsigned int i, u, v, x, y, width, height;

unsigned char quality = 50; // Quality Level (1..100 = Poor..Best)

double clut[8] = {1/(2*sqrt(2)),0.5,0.5,0.5,0.5,0.5,0.5,0.5}; // C Look Up Table (/2 Applied)

double coslut[64]; // COS Look Up Table

double ql50[64] = {16,11,10,16,24,40,51,61, // JPEG Standard Luminance Quantization 8x8 Matrix (Quality = 50)
                  12,12,14,19,26,58,60,55,
                  14,13,16,24,40,57,69,56,
                  14,17,22,29,51,87,80,62,
                  18,22,37,56,68,109,103,77,
                  24,35,55,64,81,104,113,92,
                  49,64,78,87,103,121,120,101,
                  72,92,95,98,112,100,103,99};

double qc50[64] = {17,18,24,47,99,99,99,99, // JPEG Standard Chrominance Quantization 8x8 Matrix (Quality = 50)
                   18,21,26,66,99,99,99,99,
                   24,26,56,99,99,99,99,99,
                   47,66,99,99,99,99,99,99,
                   99,99,99,99,99,99,99,99,
                   99,99,99,99,99,99,99,99,
                   99,99,99,99,99,99,99,99,
                   99,99,99,99,99,99,99,99};

double ql[64];  // JPEG Standard Luminance Quantization 8x8 Matrix Set By Quality Level
double qc[64];  // JPEG Standard Chrominance Quantization 8x8 Matrix Set By Quality Level
double dct[64]; // DCT Block 8x8 Matrix

signed short dctq[64];  // DCT Quantization Block 8x8 Matrix
signed short dctqz[64]; // DCT Quantization Zig-Zag Block 8x8 Matrix

unsigned char image[64]; // Image Data 8x8 Matrix

// Show Program Banner
static void banner(void) {
  fprintf(stderr,
    "YUV To DCT Converter\n"
    "By Peter Lemon (krom) 2019\n"
  );
}

// Show Usage Info
static void usage(const char *prgname) {
  fprintf(stderr,
    "Usage:\n"
    "Convert Planar YUV 4:2:2 To 16-Bit DCT ZigZag Quantization Block File:\n"
    "  %s Width Height YUV_File DCT_File Quality\n"
    "  (Width:     Input) *Required\n"
    "  (Height:    Input) *Required\n"
    "  (YUV_File:  Input) *Required\n"
    "  (DCT_File: Output) *Required\n"
    "  (Quality: 1..100 = Poor..Best, Default = 50)\n"
    , prgname
  );
}

// Wrapper For Fopen
static FILE *my_fopen(const char *filename, const char *mode, int *size) {
  FILE *f = fopen(filename, mode);
  if(!f) {
    perror(filename);
    return NULL;
  }
  if(size) {
    fseek(f, 0, SEEK_END);
    *size = ftell(f);
    fseek(f, 0, SEEK_SET);
  }
  return f;
}

// Convert Planar YUV 4:2:2 To 16-Bit DCT Quantization Zig-Zag Block File (Y Channel)
static void convert_y() {
  // Loop Blocks
  int ofs = 0;
  int wofs = 0;
  int block_row = 0; // Block Row Counter
  while(wofs < (width * height * 4) - 2048) {

    // Load Image Block (Y Channel)
    for(y=0; y < 8; y++) {
      for(x=0; x < 8; x++) {
        image[y*8 + x] = yuv_file[ofs];
        ofs ++;
      }
      ofs += (width - 8); // Next Scanline In Block
    }

    block_row++;
    if(block_row == (width / 8)) {
      block_row = 0; // Next Block Row
      ofs -= (width - 8);
    }
    else ofs -= ((width * 8) - 8) ; // Next Block Column

    // Clear DCT Block
    for(i=0; i < 64; i++) dct[i] = 0.0;

    // Write DCT Block
    for(u=0; u < 8; u++) {
      for(v=0; v < 8; v++) {
        for(x=0; x < 8; x++) {
          for(y=0; y < 8; y++) {
            dct[v*8 + u] += (
              image[y*8 + x]
              * clut[u]
              * clut[v]
              * coslut[u*8 + x] // cos((2*x + 1) * u * pi / 16)
              * coslut[v*8 + y] // cos((2*y + 1) * v * pi / 16)
            );
          }
        }
      }
    }

    // Write DCTQ Block (Quantization)
    for(i=0; i < 64; i++) dctq[i] = dct[i] / ql[i];

    // Write DCTQZ Block (Zig-Zag)
    dctqz[0] = dctq[0];
    dctqz[1] = dctq[1];
    dctqz[2] = dctq[8];
    dctqz[3] = dctq[16];
    dctqz[4] = dctq[9];
    dctqz[5] = dctq[2];
    dctqz[6] = dctq[3];
    dctqz[7] = dctq[10];

    dctqz[8] = dctq[17];
    dctqz[9] = dctq[24];
    dctqz[10] = dctq[32];
    dctqz[11] = dctq[25];
    dctqz[12] = dctq[18];
    dctqz[13] = dctq[11];
    dctqz[14] = dctq[4];
    dctqz[15] = dctq[5];

    dctqz[16] = dctq[12];
    dctqz[17] = dctq[19];
    dctqz[18] = dctq[26];
    dctqz[19] = dctq[33];
    dctqz[20] = dctq[40];
    dctqz[21] = dctq[48];
    dctqz[22] = dctq[41];
    dctqz[23] = dctq[34];

    dctqz[24] = dctq[27];
    dctqz[25] = dctq[20];
    dctqz[26] = dctq[13];
    dctqz[27] = dctq[6];
    dctqz[28] = dctq[7];
    dctqz[29] = dctq[14];
    dctqz[30] = dctq[21];
    dctqz[31] = dctq[28];

    dctqz[32] = dctq[35];
    dctqz[33] = dctq[42];
    dctqz[34] = dctq[49];
    dctqz[35] = dctq[56];
    dctqz[36] = dctq[57];
    dctqz[37] = dctq[50];
    dctqz[38] = dctq[43];
    dctqz[39] = dctq[36];

    dctqz[40] = dctq[29];
    dctqz[41] = dctq[22];
    dctqz[42] = dctq[15];
    dctqz[43] = dctq[23];
    dctqz[44] = dctq[30];
    dctqz[45] = dctq[37];
    dctqz[46] = dctq[44];
    dctqz[47] = dctq[51];

    dctqz[48] = dctq[58];
    dctqz[49] = dctq[59];
    dctqz[50] = dctq[52];
    dctqz[51] = dctq[45];
    dctqz[52] = dctq[38];
    dctqz[53] = dctq[31];
    dctqz[54] = dctq[39];
    dctqz[55] = dctq[46];

    dctqz[56] = dctq[53];
    dctqz[57] = dctq[60];
    dctqz[58] = dctq[61];
    dctqz[59] = dctq[54];
    dctqz[60] = dctq[47];
    dctqz[61] = dctq[55];
    dctqz[62] = dctq[62];
    dctqz[63] = dctq[63];

    // Write DCTQZ To Output File
    for(i=0; i < 64; i++) {
      dct_file[wofs] = dctqz[i] >> 8;
      wofs++;
      dct_file[wofs] = dctqz[i] & 0xFF;
      wofs++;
    }

    if((wofs & 0x7FF) == 0) wofs += 2048;
  }
}

// Convert Planar YUV 4:2:2 To 16-Bit DCT Quantization Zig-Zag Block File (U Channel)
static void convert_u() {
  // Loop Blocks
  int ofs = width * height;
  int wofs = 2048;
  int block_row = 0; // Block Row Counter
  while(wofs < (width * height * 4) - 1024) {

    // Load Image Block (U Channel)
    for(y=0; y < 8; y++) {
      for(x=0; x < 8; x++) {
        image[y*8 + x] = yuv_file[ofs];
        ofs ++;
      }
      ofs += ((width/2) - 8); // Next Scanline In Block
    }

    block_row++;
    if(block_row == ((width/2) / 8)) {
      block_row = 0; // Next Block Row
      ofs -= ((width/2) - 8);
    }
    else ofs -= (((width/2) * 8) - 8) ; // Next Block Column

    // Clear DCT Block
    for(i=0; i < 64; i++) dct[i] = 0.0;

    // Write DCT Block
    for(u=0; u < 8; u++) {
      for(v=0; v < 8; v++) {
        for(x=0; x < 8; x++) {
          for(y=0; y < 8; y++) {
            dct[v*8 + u] += (
              image[y*8 + x]
              * clut[u]
              * clut[v]
              * coslut[u*8 + x] // cos((2*x + 1) * u * pi / 16)
              * coslut[v*8 + y] // cos((2*y + 1) * v * pi / 16)
            );
          }
        }
      }
    }

    // Write DCTQ Block (Quantization)
    for(i=0; i < 64; i++) dctq[i] = dct[i] / qc[i];

    // Write DCTQZ Block (Zig-Zag)
    dctqz[0] = dctq[0];
    dctqz[1] = dctq[1];
    dctqz[2] = dctq[8];
    dctqz[3] = dctq[16];
    dctqz[4] = dctq[9];
    dctqz[5] = dctq[2];
    dctqz[6] = dctq[3];
    dctqz[7] = dctq[10];

    dctqz[8] = dctq[17];
    dctqz[9] = dctq[24];
    dctqz[10] = dctq[32];
    dctqz[11] = dctq[25];
    dctqz[12] = dctq[18];
    dctqz[13] = dctq[11];
    dctqz[14] = dctq[4];
    dctqz[15] = dctq[5];

    dctqz[16] = dctq[12];
    dctqz[17] = dctq[19];
    dctqz[18] = dctq[26];
    dctqz[19] = dctq[33];
    dctqz[20] = dctq[40];
    dctqz[21] = dctq[48];
    dctqz[22] = dctq[41];
    dctqz[23] = dctq[34];

    dctqz[24] = dctq[27];
    dctqz[25] = dctq[20];
    dctqz[26] = dctq[13];
    dctqz[27] = dctq[6];
    dctqz[28] = dctq[7];
    dctqz[29] = dctq[14];
    dctqz[30] = dctq[21];
    dctqz[31] = dctq[28];

    dctqz[32] = dctq[35];
    dctqz[33] = dctq[42];
    dctqz[34] = dctq[49];
    dctqz[35] = dctq[56];
    dctqz[36] = dctq[57];
    dctqz[37] = dctq[50];
    dctqz[38] = dctq[43];
    dctqz[39] = dctq[36];

    dctqz[40] = dctq[29];
    dctqz[41] = dctq[22];
    dctqz[42] = dctq[15];
    dctqz[43] = dctq[23];
    dctqz[44] = dctq[30];
    dctqz[45] = dctq[37];
    dctqz[46] = dctq[44];
    dctqz[47] = dctq[51];

    dctqz[48] = dctq[58];
    dctqz[49] = dctq[59];
    dctqz[50] = dctq[52];
    dctqz[51] = dctq[45];
    dctqz[52] = dctq[38];
    dctqz[53] = dctq[31];
    dctqz[54] = dctq[39];
    dctqz[55] = dctq[46];

    dctqz[56] = dctq[53];
    dctqz[57] = dctq[60];
    dctqz[58] = dctq[61];
    dctqz[59] = dctq[54];
    dctqz[60] = dctq[47];
    dctqz[61] = dctq[55];
    dctqz[62] = dctq[62];
    dctqz[63] = dctq[63];

    // Write DCTQZ To Output File
    for(i=0; i < 64; i++) {
      dct_file[wofs] = dctqz[i] >> 8;
      wofs++;
      dct_file[wofs] = dctqz[i] & 0xFF;
      wofs++;
    }

    if((wofs & 0x3FF) == 0) wofs += 3072;
  }
}

// Convert Planar YUV 4:2:2 To 16-Bit DCT Quantization Zig-Zag Block File (V Channel)
static void convert_v() {
  // Loop Blocks
  int ofs = (width * height) + ((width/2) * height);
  int wofs = 3072;
  int block_row = 0; // Block Row Counter
  while(wofs < width * height * 4) {

    // Load Image Block (V Channel)
    for(y=0; y < 8; y++) {
      for(x=0; x < 8; x++) {
        image[y*8 + x] = yuv_file[ofs];
        ofs ++;
      }
      ofs += ((width/2) - 8); // Next Scanline In Block
    }

    block_row++;
    if(block_row == ((width/2) / 8)) {
      block_row = 0; // Next Block Row
      ofs -= ((width/2) - 8);
    }
    else ofs -= (((width/2) * 8) - 8) ; // Next Block Column

    // Clear DCT Block
    for(i=0; i < 64; i++) dct[i] = 0.0;

    // Write DCT Block
    for(u=0; u < 8; u++) {
      for(v=0; v < 8; v++) {
        for(x=0; x < 8; x++) {
          for(y=0; y < 8; y++) {
            dct[v*8 + u] += (
              image[y*8 + x]
              * clut[u]
              * clut[v]
              * coslut[u*8 + x] // cos((2*x + 1) * u * pi / 16)
              * coslut[v*8 + y] // cos((2*y + 1) * v * pi / 16)
            );
          }
        }
      }
    }

    // Write DCTQ Block (Quantization)
    for(i=0; i < 64; i++) dctq[i] = dct[i] / qc[i];

    // Write DCTQZ Block (Zig-Zag)
    dctqz[0] = dctq[0];
    dctqz[1] = dctq[1];
    dctqz[2] = dctq[8];
    dctqz[3] = dctq[16];
    dctqz[4] = dctq[9];
    dctqz[5] = dctq[2];
    dctqz[6] = dctq[3];
    dctqz[7] = dctq[10];

    dctqz[8] = dctq[17];
    dctqz[9] = dctq[24];
    dctqz[10] = dctq[32];
    dctqz[11] = dctq[25];
    dctqz[12] = dctq[18];
    dctqz[13] = dctq[11];
    dctqz[14] = dctq[4];
    dctqz[15] = dctq[5];

    dctqz[16] = dctq[12];
    dctqz[17] = dctq[19];
    dctqz[18] = dctq[26];
    dctqz[19] = dctq[33];
    dctqz[20] = dctq[40];
    dctqz[21] = dctq[48];
    dctqz[22] = dctq[41];
    dctqz[23] = dctq[34];

    dctqz[24] = dctq[27];
    dctqz[25] = dctq[20];
    dctqz[26] = dctq[13];
    dctqz[27] = dctq[6];
    dctqz[28] = dctq[7];
    dctqz[29] = dctq[14];
    dctqz[30] = dctq[21];
    dctqz[31] = dctq[28];

    dctqz[32] = dctq[35];
    dctqz[33] = dctq[42];
    dctqz[34] = dctq[49];
    dctqz[35] = dctq[56];
    dctqz[36] = dctq[57];
    dctqz[37] = dctq[50];
    dctqz[38] = dctq[43];
    dctqz[39] = dctq[36];

    dctqz[40] = dctq[29];
    dctqz[41] = dctq[22];
    dctqz[42] = dctq[15];
    dctqz[43] = dctq[23];
    dctqz[44] = dctq[30];
    dctqz[45] = dctq[37];
    dctqz[46] = dctq[44];
    dctqz[47] = dctq[51];

    dctqz[48] = dctq[58];
    dctqz[49] = dctq[59];
    dctqz[50] = dctq[52];
    dctqz[51] = dctq[45];
    dctqz[52] = dctq[38];
    dctqz[53] = dctq[31];
    dctqz[54] = dctq[39];
    dctqz[55] = dctq[46];

    dctqz[56] = dctq[53];
    dctqz[57] = dctq[60];
    dctqz[58] = dctq[61];
    dctqz[59] = dctq[54];
    dctqz[60] = dctq[47];
    dctqz[61] = dctq[55];
    dctqz[62] = dctq[62];
    dctqz[63] = dctq[63];

    // Write DCTQZ To Output File
    for(i=0; i < 64; i++) {
      dct_file[wofs] = dctqz[i] >> 8;
      wofs++;
      dct_file[wofs] = dctqz[i] & 0xFF;
      wofs++;
    }

    if((wofs & 0x3FF) == 0) wofs += 3072;
  }
}

// Create DCT From Source Filename & Target Filename (Return 0 On Success)
static int create_dct(const char *source_filename, const char *target_filename) {
  FILE *source_file = NULL;
  int source_size;
  FILE *target_file = NULL;
  int e = 0;
  source_file = NULL;

  // Open Source File
  source_file = my_fopen(source_filename, "rb", &source_size);
  if(!source_file) goto err;

  // Load Source File
  for(i=0; i < source_size; i++) yuv_file[i] = fgetc(source_file);

  float start_time = (float)clock()/CLOCKS_PER_SEC;

  // Fill JPEG Standard Luminance Quantization 8x8 Matrix Set By Quality Level
  for(i=0; i < 64; i++) {
    if(quality > 50) ql[i] = round(ql50[i] * (100-quality)/50);
    if(quality < 50) ql[i] = round(ql50[i] * 50/quality);
    if(quality == 50) ql[i] = ql50[i];
    if(ql[i] > 255) ql[i] = 255;
    if(ql[i] < 1) ql[i] = 1;
  }
  printf("Luminance Quantization 8x8 Matrix Result:\n");
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[0],ql[1],ql[2],ql[3],ql[4],ql[5],ql[6],ql[7]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[8],ql[9],ql[10],ql[11],ql[12],ql[13],ql[14],ql[15]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[16],ql[17],ql[18],ql[19],ql[20],ql[21],ql[22],ql[23]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[24],ql[25],ql[26],ql[27],ql[28],ql[29],ql[30],ql[31]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[32],ql[33],ql[34],ql[35],ql[36],ql[37],ql[38],ql[39]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[40],ql[41],ql[42],ql[43],ql[44],ql[45],ql[46],ql[47]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[48],ql[49],ql[50],ql[51],ql[52],ql[53],ql[54],ql[55]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", ql[56],ql[57],ql[58],ql[59],ql[60],ql[61],ql[62],ql[63]);

  // Fill JPEG Standard Chrominance Quantization 8x8 Matrix Set By Quality Level
  for(i=0; i < 64; i++) {
    if(quality > 50) qc[i] = round(qc50[i] * (100-quality)/50);
    if(quality < 50) qc[i] = round(qc50[i] * 50/quality);
    if(quality == 50) qc[i] = qc50[i];
    if(qc[i] > 255) qc[i] = 255;
    if(qc[i] < 1) qc[i] = 1;
  }
  printf("Chrominance Quantization 8x8 Matrix Result:\n");
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[0],qc[1],qc[2],qc[3],qc[4],qc[5],qc[6],qc[7]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[8],qc[9],qc[10],qc[11],qc[12],qc[13],qc[14],qc[15]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[16],qc[17],qc[18],qc[19],qc[20],qc[21],qc[22],qc[23]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[24],qc[25],qc[26],qc[27],qc[28],qc[29],qc[30],qc[31]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[32],qc[33],qc[34],qc[35],qc[36],qc[37],qc[38],qc[39]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[40],qc[41],qc[42],qc[43],qc[44],qc[45],qc[46],qc[47]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[48],qc[49],qc[50],qc[51],qc[52],qc[53],qc[54],qc[55]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", qc[56],qc[57],qc[58],qc[59],qc[60],qc[61],qc[62],qc[63]);

  // Fill COS Look Up Table
  for(y=0; y < 8; y++) {
    for(x=0; x < 8; x++) coslut[y*8 + x] = cos((2*x + 1) * y * M_PI / 16);
  }

  // Convert DCT Quantization Zig-Zag Block Output
  convert_y();
  convert_u();
  convert_v();

  // Create Target File
  target_file = my_fopen(target_filename, "wb", NULL);
  if(!target_file) goto err;
  fprintf(stderr, "Creating %s...\n", target_filename);

  // Store Target File
  for(i=0; i < source_size*2; i++) fputc(dct_file[i], target_file);

  float end_time = (float)clock()/CLOCKS_PER_SEC;
  float time_elapsed = end_time - start_time;

  // Finished
  fprintf(stderr, "Done (%f Seconds)\n", time_elapsed);
  goto no_err;
  err:
  e = 1;
  no_err:
  if(source_file) fclose(source_file);
  if(target_file) fclose(target_file);
  return e;
}

int main(int argc, char **argv) {
  if(argc < 2) {
    banner();
    usage(argv[0]);
    return 1;
  }
  if(argc < 5) {
    fprintf(stderr, "Not enough parameters\n");
    usage(argv[0]);
    return 1;
  }

  if(argv[1]) { // IF Width Set
    width = strtol(argv[1], &argv[1], 10);
    if(width & 7) {
      fprintf(stderr, "Width needs to be a multiple of 8\n");
      usage(argv[0]);
      return 1;
    }
  }
  fprintf(stderr, "Width = %d\n", width);

  if(argv[2]) { // IF Height Set
    height = strtol(argv[2], &argv[2], 10);
    if(height & 7) {
      fprintf(stderr, "Height needs to be a multiple of 8\n");
      usage(argv[0]);
      return 1;
    }
  }
  fprintf(stderr, "Height = %d\n", height);

  if(argv[5]) { // IF Quality Set
    quality = strtol(argv[5], &argv[5], 10);
    if((quality <= 0) || (quality > 100)) {
      fprintf(stderr, "Quality needs to be a number between 1 & 100\n");
      usage(argv[0]);
      return 1;
    }
  }
  fprintf(stderr, "Quality = %d\n", quality);

  if(create_dct(argv[3], argv[4])) return 1;
}