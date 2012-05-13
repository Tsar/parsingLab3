grammar Prefix;

@header {
import java.io.PrintWriter;
}

@members {
	PrintWriter out;

	void init() {
		try{
			out = new PrintWriter("output.cpp");
			out.print("#include <iostream>\n\n");
			out.print("int main() {\n");
		} catch (Exception e) {
		}
	}
	
	void deinit() {
		out.print("}\n");
		out.close();
	}
}

s	:	{init();} B? expr* {deinit();};

expr	:	IF_OPERATOR {out.print("if ");} B bool_expr {out.print(" {\n");} B expr+
		(ELIF_OPERATOR {out.print("} else if ");} B bool_expr {out.print(" {\n");} B expr+)*
		(ELSE_OPERATOR {out.print("} else {\n");} B expr+)?
		ENDIF_OPERATOR {out.print("}\n");} B?
	|	PRINT_OPERATOR {out.print("std::cout << ");} B arithm_expr {out.print(";\n");} B?
	|	EQ_OPERATOR B? VARIABLE {out.print($VARIABLE.text + " = ");} B arithm_expr {out.print(";\n");} B?;

bool_expr
	:	BOOL_BIN_OPERATOR {out.print("(");} B? arithm_expr {out.print(" " + $BOOL_BIN_OPERATOR.text + " ");} B arithm_expr {out.print(")");}
	|	NOT_OPERATOR {out.print("(!");} B? bool_expr {out.print(")");};

arithm_expr
	:	ARITHM_BIN_OPERATOR {out.print("(");} B? arithm_expr {out.print(" " + $ARITHM_BIN_OPERATOR.text + " ");} B arithm_expr {out.print(")");}
	|	NUMBER {out.print($NUMBER.text);}
	|	VARIABLE {out.print($VARIABLE.text);};

ARITHM_BIN_OPERATOR
	:	'+'
	|	'-'
	|	'*'
	|	'/'
	|	'>>'
	|	'<<'
	|	'|'
	|	'&';

BOOL_BIN_OPERATOR
	:	'>='
	|	'<='
	|	'>'
	|	'<'
	|	'||'
	|	'&&';

NOT_OPERATOR
	:	'!';

EQ_OPERATOR
	:	'=';

IF_OPERATOR
	:	'if';

ELIF_OPERATOR
	:	'elif';

ELSE_OPERATOR
	:	'else';

ENDIF_OPERATOR
	:	'endif';

PRINT_OPERATOR
	:	'print';

NUMBER	:	('0'..'9')+;

VARIABLE:	('A'..'Z' | 'a'..'z' | '_')('A'..'Z' | 'a'..'z' | '_' | '0'..'9')+;

B	:	(' ' | '\n' | '\t')+;
