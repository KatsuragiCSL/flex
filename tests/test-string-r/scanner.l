%{
/* A template scanner file to build "scanner.c". */
#include <stdio.h>
#include <stdlib.h>
#include "config.h"

#define NUMBER 200
#define WORD   201

%}

%option 8bit outfile="scanner.c" prefix="test"
%option nounput nomain nodefault noyywrap 
%option warn reentrant


%%

[[:space:]]+   { }
[[:digit:]]+   { printf("NUMBER "); fflush(stdout);}
[[:alpha:]]+   { printf("WORD "); fflush(stdout);}
.              {
    fprintf(stderr,"*** Error: Unrecognized character '%c' while scanning.\n",
         yytext_r[0]);
    yyterminate();
    }

<<EOF>>  { printf("<<EOF>>\n"); yyterminate();}

%%


#define INPUT_STRING_1  "1234 foo bar"
#define INPUT_STRING_2  "1234 foo bar *@&@&###@^$#&#*"

int
main ( int argc, char** argv )
{
    char * buf;
    int len;
    YY_BUFFER_STATE state;
    void * scanner=NULL;


    /* Scan a good string. */
    printf("Testing: yy_scan_string(%s): ",INPUT_STRING_1); fflush(stdout);
    yylex_init(&scanner);
    state = yy_scan_string ( INPUT_STRING_1 ,scanner);
    yylex(scanner);
    yy_delete_buffer(state, scanner);
    yylex_destroy(scanner);

    /* Scan only the first 12 chars of a string. */
    printf("Testing: yy_scan_bytes(%s): ",INPUT_STRING_2); fflush(stdout);
    yylex_init(&scanner);
    state = yy_scan_bytes  ( INPUT_STRING_2, 12 ,scanner);
    yylex(scanner);
    yy_delete_buffer(state,scanner);
    yylex_destroy(scanner);

    /* Scan directly from a buffer.
       We make a copy, since the buffer will be modified by flex.*/
    printf("Testing: yy_scan_buffer(%s): ",INPUT_STRING_1); fflush(stdout);
    len = strlen(INPUT_STRING_1) + 2;
    buf = (char*)malloc( len );
    strcpy( buf, INPUT_STRING_1);
    buf[ len -2 ]  = 0; /* Flex requires two NUL bytes at end of buffer. */
    buf[ len -1 ] =0;

    yylex_init(&scanner);
    state = yy_scan_buffer( buf, len ,scanner);
    yylex(scanner);
    yy_delete_buffer(state,scanner);
    yylex_destroy(scanner);
    
    printf("TEST RETURNING OK.\n");
    return 0;
}