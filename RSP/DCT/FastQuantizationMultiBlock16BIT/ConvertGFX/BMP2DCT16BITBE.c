#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

unsigned char bmp_file[16777216];
unsigned char dct_file[16777216];
unsigned int i, u, v, x, y, width, height;
unsigned short depth;

unsigned char quality = 50; // Quality Level (1..100 = Poor..Best)

double clut[8] = {1/(2*sqrt(2)),0.5,0.5,0.5,0.5,0.5,0.5,0.5}; // C Look Up Table (/2 Applied)

double coslut[64]; // COS Look Up Table

double q50[64] = {16,11,10,16,24,40,51,61, // JPEG Standard Quantization 8x8 Matrix (Quality = 50)
                  12,12,14,19,26,58,60,55,
                  14,13,16,24,40,57,69,56,
                  14,17,22,29,51,87,80,62,
                  18,22,37,56,68,109,103,77,
                  24,35,55,64,81,104,113,92,
                  49,64,78,87,103,121,120,101,
                  72,92,95,98,112,100,103,99};

double q[64];   // JPEG Standard Quantization 8x8 Matrix Set By Quality Level
double dct[64]; // DCT Block 8x8 Matrix

signed short dctq[64]; // DCT Quantization Block 8x8 Matrix

unsigned char image[64]; // Image Data 8x8 Matrix

// Show Program Banner
static void banner(void) {
  fprintf(stderr,
    "BMP To DCT Converter\n"
    "By Peter Lemon (krom) 2019\n"
  );
}

// Show Usage Info
static void usage(const char *prgname) {
  fprintf(stderr,
    "Usage:\n"
    "Convert 32-Bit/24-Bit BMP To 16-Bit DCT Quantization Block File:\n"
    "  %s BMP_File DCT_File Quality\n"
    "  (BMP_File:  Input) *Required\n"
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

// Convert 32-Bit/24-Bit BMP To 16-Bit DCT Quantization Block File
static void convert_dct(int ofs) {
  // Loop Blocks
  ofs -= (depth / 8) * width;
  int wofs = 0;
  int block_row = 0; // Block Row Counter
  while(wofs < width * height * 2) {

    // Load Image Block (Red Channel)
    for(y=0; y < 8; y++) {
      for(x=0; x < 8; x++) {
        image[y*8 + x] = bmp_file[ofs];
        ofs += (depth / 8);
      }
      ofs -= ((depth / 8) * width) + ((depth / 8) * 8); // Next Scanline In Block
    }

    block_row++;
    if(block_row == (width / 8)) {
      block_row = 0; // Next Column Block
      ofs += (depth / 8) * 8;
      ofs -= ((depth / 8) * width);
    }
    else ofs += ((depth / 8) * (width * 8)) + ((depth / 8) * 8); // Next Block Row

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
    for(i=0; i < 64; i++) dctq[i] = dct[i] / q[i];

    // Write DCTQ To Output File
    for(i=0; i < 64; i++) {
      dct_file[wofs] = dctq[i] >> 8;
      wofs++;
      dct_file[wofs] = dctq[i] & 0xFF;
      wofs++;
    }
  }

}

// Create DCT From Source Filename & Target Filename (Return 0 On Success)
static int create_dct(const char *source_filename, const char *target_filename) {
  FILE *source_file = NULL;
  int source_size;
  FILE *target_file = NULL;
  int ofs;
  int e = 0;
  source_file = NULL;

  // Open Source File
  source_file = my_fopen(source_filename, "rb", &source_size);
  if(!source_file) goto err;

  // Load Source File
  for(i=0; i < source_size; i++) bmp_file[i] = fgetc(source_file);

  // Fill JPEG Standard Quantization 8x8 Matrix Set By Quality Level
  for(i=0; i < 64; i++) {
    if(quality > 50) q[i] = round(q50[i] * (100-quality)/50);
    if(quality < 50) q[i] = round(q50[i] * 50/quality);
    if(quality == 50) q[i] = q50[i];
    if(q[i] > 255) q[i] = 255;
    if(q[i] < 1) q[i] = 1;
  }
  printf("Quantization 8x8 Matrix Result:\n");
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[0],q[1],q[2],q[3],q[4],q[5],q[6],q[7]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[8],q[9],q[10],q[11],q[12],q[13],q[14],q[15]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[16],q[17],q[18],q[19],q[20],q[21],q[22],q[23]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[24],q[25],q[26],q[27],q[28],q[29],q[30],q[31]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[32],q[33],q[34],q[35],q[36],q[37],q[38],q[39]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[40],q[41],q[42],q[43],q[44],q[45],q[46],q[47]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[48],q[49],q[50],q[51],q[52],q[53],q[54],q[55]);
  printf("%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n", q[56],q[57],q[58],q[59],q[60],q[61],q[62],q[63]);

  // Fill COS Look Up Table
  for(y=0; y < 8; y++) {
    for(x=0; x < 8; x++) coslut[y*8 + x] = cos((2*x + 1) * y * M_PI / 16);
  }

  ofs = 0x12;
  width = bmp_file[ofs] + (bmp_file[ofs+1]<<8) + (bmp_file[ofs+2]<<16) + (bmp_file[ofs+3]<<24);
  height = bmp_file[ofs+4] + (bmp_file[ofs+5]<<8) + (bmp_file[ofs+6]<<16) + (bmp_file[ofs+7]<<24);

  ofs = 0x1C;
  depth = bmp_file[ofs] + (bmp_file[ofs+1]<<8);

  ofs = source_size;

  float start_time = (float)clock()/CLOCKS_PER_SEC;

  // Convert DCT Quantization Block Output
  convert_dct(ofs);

  // Create Target File
  target_file = my_fopen(target_filename, "wb", NULL);
  if(!target_file) goto err;
  fprintf(stderr, "Creating %s...\n", target_filename);

  // Store Target File
  for(i=0; i < width*height*2; i++) fputc(dct_file[i], target_file);

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
  if(argc < 3) {
    fprintf(stderr, "Not enough parameters\n");
    usage(argv[0]);
    return 1;
  }

  if(argv[3]) { // IF Quality Set
    quality = strtol(argv[3], &argv[3], 10);
    if((quality <= 0) || (quality > 100)) {
      fprintf(stderr, "Quality needs to be a number between 1 & 100\n");
      usage(argv[0]);
      return 1;
    }
  }
  fprintf(stderr, "Quality = %d\n", quality);

  if(create_dct(argv[1], argv[2])) return 1;
}