%option noyywrap

%{
    #include "calc.h"
    #define llog(token) {fprintf(flex_bison_log_file, "LEX: %s \"%s\"\n", #token, yytext);fflush(flex_bison_log_file);}
%}

digit       [0-9]
int         [+-]?{digit}+
float       [+-]?{digit}+\.{digit}*
quit        "quit"
func        "neg"|"abs"|"exp"|"log"|"sqrt"|"add"|"sub"|"mult"|"div"|"rem"

%%

{int} {
    llog(INT);
    yylval.dval = strtod(yytext, NULL);
    return INT;
}

{float} {
     llog(FLOAT);
     yylval.dval = strtod(yytext, NULL);
     return FLOAT;
}

{func} {
    llog(FUNC);
    yylval.fval = resolveFunc(yytext);
    return FUNC;
}

{quit} {
    llog(QUIT);
    return QUIT;
}

[(] {
   llog(LPAREN);
   return LPAREN;
}

[)] {
    llog(RPAREN);
 return RPAREN;
}

[\n] {
    llog(EOL);
    return EOL;
}

[\r\t ] {}; /* skip whitespace */

. {
    llog(ERROR INVALID);
}

%%
