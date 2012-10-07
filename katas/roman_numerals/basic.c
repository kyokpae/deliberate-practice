#include <stdio.h>

// Type encapsulating state of a roman numerals parser.
typedef struct {
  short value;
  char prev;
} Parser;

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
  switch (c) {
    case 'I': parseI(parser); break;
    case 'V': parseV(parser); break;
    case 'X': parseX(parser); break;
    case 'L': parseL(parser); break;
    case 'C': parseC(parser); break;
    case 'D': parseD(parser); break;
    case 'M': parseM(parser); break;
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

void assertEquals(int number, char * roman_numeral) {
  int actual_number = convert(roman_numeral);
  if (actual_number == number) {
    printf("  %s -> %d\n", roman_numeral, number);
  } else {
    printf("! %s -> %d (got %d)\n", roman_numeral, number, actual_number);
  }
}

int main(void) {
  assertEquals(499, "CDXCIX");
  assertEquals(1982, "MCMLXXXII");
  assertEquals(2012, "MMXII");
  assertEquals(3999, "MMMCMXCIX");
  return 0;
}
