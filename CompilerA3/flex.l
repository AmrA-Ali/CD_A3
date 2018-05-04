%{
int char_count = 0, line_count = 0, char_pos =0;
%}

DIGIT   [0-9]
LETTER  [a-zA-Z]
ID      {LETTER}({LETTER}|{DIGIT})*(("."|"#"|"$"|"_")?({LETTER}|{DIGIT})+)?
NUM     ({DIGIT}+|{DIGIT}+"."{DIGIT}*)((E|e)("+"|"-")?{DIGIT}+)?
NOTNUM  ({DIGIT}+|{DIGIT}+"."{DIGIT}*)((E|e)("+"|"-")?[^{DIGIT}|\n]+)?
NOTID   {LETTER}({LETTER}|{DIGIT})*(("."|"#"|"$"|"_")?([^{LETTER}|^{DIGIT}|^\n|^ |^;])+)?
COMMENT "/*"(.|\n)*"*/"
NOTCOMMENT "/*"([^"*/"])
SYMBOL "/*"|"*/"
SLB "["
SRB "]"
LB "("
RB ")"
CLB "{"
CRB "}"
SEMICOLON ";"
COMMA ","
COLON ":"

ADDOP "+"|"-"
MULOP "*"|"/"
LT "<"
LTE "<="
BT ">"
BTE ">="
EQ "=="
NEQ "!="
ASSIGN "="
INT int
VOID void
LET let
IF if
WHILE while
RETURN return
ELSE else

%%
[ \t]+        {char_pos++;}
[ \t]+$       /* ignore this token -> throws away whitespace found at the end of a line */

{SEMICOLON}     {printf("24:%s\t", yytext); char_pos += strlen(yytext);}
{SLB}           {printf("18:%s\t", yytext); char_pos += strlen(yytext);}
{SRB}           {printf("19:%s\t", yytext); char_pos += strlen(yytext);}
{LB}            {printf("20:%s\t", yytext); char_pos += strlen(yytext);}
{RB}            {printf("21:%s\t", yytext); char_pos += strlen(yytext);}
{CLB}           {printf("22:%s\t", yytext); char_pos += strlen(yytext);}
{CRB}           {printf("23:%s\t", yytext); char_pos += strlen(yytext);}
{COMMA}         {printf("25:%s\t", yytext); char_pos += strlen(yytext);}

{ADDOP}         {printf("9:%s\t", yytext); char_pos += strlen(yytext);}
{MULOP}         {printf("10:%s\t", yytext); char_pos += strlen(yytext);}
{LTE}           {printf("11:%s\t", yytext); char_pos += strlen(yytext);}
{LT}            {printf("12:%s\t", yytext); char_pos += strlen(yytext);}
{BT}            {printf("13:%s\t", yytext); char_pos += strlen(yytext);}
{BTE}           {printf("14:%s\t", yytext); char_pos += strlen(yytext);}
{EQ}            {printf("15:%s\t", yytext); char_pos += strlen(yytext);}
{NEQ}           {printf("16:%s\t", yytext); char_pos += strlen(yytext);}
{ASSIGN}        {printf("17:%s\t", yytext); char_pos += strlen(yytext);}

{INT}           {printf("2:%s\t", yytext); char_pos += strlen(yytext);}
{VOID}          {printf("3:%s\t", yytext); char_pos += strlen(yytext);}
{LET}           {printf("4:%s\t", yytext); char_pos += strlen(yytext);}
{IF}            {printf("5:%s\t", yytext); char_pos += strlen(yytext);}
{WHILE}         {printf("6:%s\t", yytext); char_pos += strlen(yytext);}
{RETURN}        {printf("7:%s\t", yytext); char_pos += strlen(yytext);}
{ELSE}          {printf("8:%s\t", yytext); char_pos += strlen(yytext);}

{NOTCOMMENT}    {printf("\n!Not Comment @ line %d\n", line_count); char_pos += strlen(yytext);}
{COMMENT}       {
                    int i = 0;
                    for(;;i++){
                        if(yytext[i] == '\n')
                            line_count += 1;
                        if(yytext[i] == '*' && yytext[i+1] == '/')
                            break;
                    }
                }
{ID}            {printf("0:%s\t", yytext);char_pos += strlen(yytext);}
{NUM}           {printf("1:%s\t", yytext);char_pos += strlen(yytext);}
{NOTNUM}        {printf("\n!Not Num: %s - line: %d | col:%d\n", yytext, line_count, char_pos);char_pos += strlen(yytext);}


. {char_count++; char_pos += strlen(yytext); printf("\n!ID Error: %s - line: %d | col:%d\n", yytext, line_count+1, char_pos);}
\n {line_count++; char_count++; char_pos=0; printf("\n");}
%%

int main(){
    yylex();
    return 0;
}

// printf("Comment@line %d: %s", line_count, yytext);
/* [ \t]+ putchar(''); compresses multiple blanks and tabs down to a blank*/
// {NOTID}         {printf("\n!NOT ID: %s - line: %d | col:%d\n", yytext, line_count, char_pos);char_pos += strlen(yytext);}
