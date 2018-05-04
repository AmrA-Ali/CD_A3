%token ELSE
%token IF
%token INT
%token RETURN
%token VOID
%token WHILE

%token ID
%token NUM

%token LTE
%token GTE
%token EQUAL
%token NOTEQUAL

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

program : declaration_list ;

declaration_list : declaration_list declaration | declaration ;

declaration : var_declaration | fun_declaration ;

var_declaration : type_specifier ID ';'
                | type_specifier ID '[' NUM ']' ';' ;

type_specifier : INT | VOID ;

fun_declaration : type_specifier ID '(' params ')' compound_stmt ;

params : param_list | VOID ;

param_list : param_list ',' param
           | param ;

param : type_specifier ID | type_specifier ID '[' ']' ;

compound_stmt : '{' local_declarations statement_list '}' ;

local_declarations : local_declarations var_declaration
             ;

statement_list : statement_list statement
               ;

statement : expression_stmt
          | compound_stmt
          | selection_stmt
          | iteration_stmt
          | return_stmt ;

expression_stmt : expression ';'
                | ';' ;

selection_stmt : IF '(' expression ')' statement    %prec LOWER_THAN_ELSE ;
               | IF '(' expression ')' statement ELSE statement ;

iteration_stmt : WHILE '(' expression ')' statement ;

return_stmt : RETURN ';' | RETURN expression ';' ;

expression : var '=' expression | simple_expression ;

var : ID | ID '[' expression ']' ;

simple_expression : additive_expression relop additive_expression
                  | additive_expression ;

relop : LTE | '<' | '>' | GTE | EQUAL | NOTEQUAL ;

additive_expression : additive_expression addop term | term ;

addop : '+' | '-' ;

term : term mulop factor | factor ;

mulop : '*' | '/' ;

factor : '(' expression ')' | var | call | NUM ;

call : ID '(' args ')' ;

args : arg_list ;

arg_list : arg_list ',' expression | expression ;
%%
#include <stdio.h>

extern char yytext[];
extern int column;

yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}
