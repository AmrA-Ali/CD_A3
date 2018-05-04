%token DIGIT
%token LETTER
%token ID
%token NUM
%token NOTNUM
%token NOTID


%token COMMENT
%token NOTCOMMENT
%token SYMBOL
%token SLB
%token SRB
%token LB
%token RB
%token CLB
%token CRB
%token SEMICOLON
%token COMMA
%token COLON

%token ADDOP
%token MULOP
%token LT
%token LTE
%token BT
%token BTE
%token EQ
%token NEQ
%token ASSIGN
%token INT
%token VOID
%token LET
%token IF
%token WHILE
%token RETURN
%token ELSE


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

program : declaration_list ;

declaration_list : declaration_list declaration | declaration ;

declaration : var_declaration | fun_declaration ;

var_declaration : type_specifier ID SEMICOLON
                | type_specifier ID SLB NUM SRB SEMICOLON ;

type_specifier : INT | VOID ;

fun_declaration : type_specifier ID LB params RB compound_stmt ;

params : param_list | VOID ;

param_list : param_list COMMA param
           | param ;

param : type_specifier ID | type_specifier ID SLB SRB ;

compound_stmt : CLB local_declarations statement_list CRB ;

local_declarations : local_declarations var_declaration
             ;

statement_list : statement_list statement
               ;

statement : expression_stmt
          | compound_stmt
          | selection_stmt
          | iteration_stmt
          | return_stmt ;

expression_stmt : expression SEMICOLON
                | SEMICOLON ;

selection_stmt : IF LB expression RB statement    %prec LOWER_THAN_ELSE ;
               | IF LB expression RB statement ELSE statement ;

iteration_stmt : WHILE LB expression RB statement ;

return_stmt : RETURN SEMICOLON | RETURN expression SEMICOLON ;

expression : var ASSIGN expression | simple_expression ;

var : ID | ID SLB expression SRB ;

simple_expression : additive_expression relop additive_expression
                  | additive_expression ;

relop : LTE | LT | BT | BTE | EQ | NEQ ;

additive_expression : additive_expression addop term | term ;

addop : ADDOP ;

term : term mulop factor | factor ;

mulop : MULOP ;

factor : LB expression RB | var | call | NUM ;

call : ID LB args RB ;

args : arg_list ;

arg_list : arg_list COMMA expression | expression ;
%%
#include <stdio.h>
#include<lex.yy.c>
extern char yytext[];
extern int column;

yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}
