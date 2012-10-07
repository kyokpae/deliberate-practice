Roman Numerals Kata
===================

Write a function to convert Roman Numeral to normal numbers in the range 1 to 3999.

Simple solutions
----------------

These solutions assume that input string is a well formed roman numeral.

Algorithm is based on observation that in properly formed roman number each numeral either
increases the value of that number or decreases. Decision is made based on current and previous
numerals e.g.:

  XIV -> 10 + 1 + 3
  XVI -> 10 + 5 + 1
  CDXC -> 100 + 300 + 10 + 80

basic.c: simple version
function_pointers.c: no if's used in dispatch
visitor.java: no if's used in dispatch but visitor pattern 

Validating solutions
--------------------

TBD

References
----------
[Coding Roman Numerals Kata](http://codingdojo.org/cgi-bin/wiki.pl?KataRomanNumerals)
