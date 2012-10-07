#include <stdio.h>

/* Roman Numerals converter to decimal numbers

Algorithm is based on observation that in properly formed roman number each numeral either
increases the value of that number or decreases. Decision is made based on current and previous
numerals e.g.:

  XIV -> 10 + 1 + 3
  XVI -> 10 + 5 + 1
  CDXC -> 100 + 300 + 10 + 80

This implementation uses table of function pointers to dispatch processing of the current numeral
to the appropriate function.
*/

// Type encapsulating state of a roman numerals parser.
typedef struct {
  short value;
  char prev;
} Parser;

// Type of pointers to functions that modify the state of roman numerals parser.
typedef void (*ParserFunction)();

// Look-up table to quickly dispatch processing of the character to correct function
ParserFunction ParserFunction_Lut[256];

void parseI(Parser * parser) {
  parser->value += 1;
}

void parseV(Parser * parser) {
  parser->value += (parser->prev == 'I') ? 3 : 5;
}

void parseX(Parser * parser) {
  parser->value += (parser->prev == 'I') ? 8 : 10;
}

void parseL(Parser * parser) {
  parser->value += (parser->prev == 'X') ? 30 : 50;
}

void parseC(Parser * parser) {
  parser->value += (parser->prev == 'X') ? 80 : 100;
}

void parseD(Parser * parser) {
  parser->value += (parser->prev == 'C') ? 300 : 500;
}

void parseM(Parser * parser) {
  parser->value += (parser->prev == 'C') ? 800 : 1000;
}

void Parser_parse(Parser * parser, char c) {
  ParserFunction fptr = ParserFunction_Lut[c];
  if (fptr != 0) {
    (*fptr)(parser);
  }
  parser->prev = c;
}

int convert(char* roman_numeral) {
  Parser parser;

  parser.value = 0;
  parser.prev = 0;

  while (*roman_numeral) {
    Parser_parse(&parser, *roman_numeral);
    roman_numeral++;
  }

  return parser.value;
}

void ParserFunction_initLut() {
  int i;
  for (i = 0; i < 256; i++) {
    ParserFunction_Lut[i] = 0;
  }
  ParserFunction_Lut['I'] = parseI;
  ParserFunction_Lut['V'] = parseV;
  ParserFunction_Lut['X'] = parseX;
  ParserFunction_Lut['L'] = parseL;
  ParserFunction_Lut['C'] = parseC;
  ParserFunction_Lut['D'] = parseD;
  ParserFunction_Lut['M'] = parseM;
}

void assertEquals(int number, char * roman_numeral) {
  int actual_number = convert(roman_numeral);
  if (actual_number == number) {
    printf("  %s -> %d\n", roman_numeral, number);
  } else {
    printf("! %s -> %d (got %d)\n", roman_numeral, number, actual_number);
  }
}

int main(void) {
  ParserFunction_initLut();
  
  assertEquals(499, "CDXCIX");
  assertEquals(1982, "MCMLXXXII");
  return 0;
}
