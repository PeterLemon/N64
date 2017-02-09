#include <stdio.h>
#include <stdlib.h>
#include <math.h>

char cmd;
unsigned char SourceCHR;
long width;
long height;
short depth;

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

double q[64]; // JPEG Standard Quantization 8x8 Matrix Set By Quality Level

double dct[64]; // DCT 8x8 Matrix

signed char dctq[64]; // DCT Quantization 8x8 Matrix

unsigned char image[64]; // Image Data 8x8 Matrix

// Show Program Banner
static void banner(void) {
  fprintf(stderr,
    "BMP To DCT Converter\n"
    "By Peter Lemon (krom) 2016\n"
  );
}

// Show Usage Info
static void usage(const char *prgname) {
  fprintf(stderr,
    "Usage:\n"
    "Convert 32-Bit/24-Bit BMP To 8-Bit DCT Quantization Block File:\n"
    "  %s BMP_File DCT_File Quality\n"
    "  (BMP_File:  Input) *Required\n"
    "  (DCT_File: Output) *Required\n"
    "  (Quality: 1..100 = Poor..Best, Default = 50)\n"
    , prgname
  );
}

// Wrapper For Fopen
static FILE *my_fopen(const char *filename, const char *mode, long *size) {
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

// Read 8-Bit Number From File (MSB 1st)
static int readvalue(FILE *f) {
  return fgetc(f);
}

// Write 8-Bit Number To File (MSB 1st)
static void writevalue(int value, FILE *f) {
  fputc(value, f);
}

// Convert 32-Bit/24-Bit BMP To 8-Bit DCT Quantization Block File
static void convert_dct(FILE *source_file, FILE *target_file, long ofs, long ofs_end) {
  ofs = 0x12;
  fseek(source_file, ofs, SEEK_SET);
  width = readvalue(source_file);
  width += (readvalue(source_file))<<8;
  width += (readvalue(source_file))<<16;
  width += (readvalue(source_file))<<24;

  height = readvalue(source_file);
  height += (readvalue(source_file))<<8;
  height += (readvalue(source_file))<<16;
  height += (readvalue(source_file))<<24;

  ofs = 0x1C;
  fseek(source_file, ofs, SEEK_SET);
  depth = readvalue(source_file);
  depth += (readvalue(source_file))<<8;

  unsigned int i = 0;
  unsigned int u = 0;
  unsigned int v = 0;
  unsigned int x = 0;
  unsigned int y = 0;

  // Fill JPEG Standard Quantization 8x8 Matrix Set By Quality Level
  for(i=0; i < 64; i++) {
    if(quality > 50) q[i] = q50[i] * (100-quality)/50;
    if(quality < 50) q[i] = q50[i] * 50/quality;
    if(quality == 50) q[i] = q50[i];
    if(q[i] > 255) q[i] = 255;
    if(q[i] < 1) q[i] = 1;
  }

  // Fill COS Look Up Table
  for(u=0; u < 8; u++) {
    for(x=0; x < 8; x++) coslut[u*8 + x] = cos((2*x + 1) * u * M_PI / 16);
  }

  // Loop Blocks
  ofs = ofs_end - ((depth / 8) * width);
  long wofs = 0;
  unsigned int block_row = 0; // Block Row Counter
  while(wofs < width * height) {

    // Load Image Block (Red Channel)
    for(y=0; y < 8; y++) {
      for(x=0; x < 8; x++) {
        fseek(source_file, ofs, SEEK_SET);
        SourceCHR = readvalue(source_file);
        image[y*8 + x] = SourceCHR;
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
      SourceCHR = dctq[i];
      fseek(target_file, wofs, SEEK_SET);
      writevalue(SourceCHR, target_file);
      wofs++;
    }
  }

}

// Create DCT From Source Filename & Target Filename (Return 0 On Success)
static int create_binary(const char *source_filename, const char *target_filename) {
  FILE *source_file = NULL;
  long source_size;
  FILE *target_file = NULL;
  long ofs;
  int e = 0;
  source_file = NULL;

  // Open Source File
  source_file = my_fopen(source_filename, "rb", &source_size);
  if(!source_file) goto err;

  // Create Target File
  target_file = my_fopen(target_filename, "wb", NULL);
  if(!target_file) goto err;
  fprintf(stderr, "Creating %s...\n", target_filename);
  ofs = 0;

  // Convert DCT Quantization Block Output
  convert_dct(source_file, target_file, ofs, source_size);
  
  // Finished
  fprintf(stderr, "Done\n");
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

  if(create_binary(argv[1], argv[2])) return 1;
}