grammar Prefix;

@header {
import java.io.PrintWriter;
}

@members {
	PrintWriter out;

	void init() {
		try{
			out = new PrintWriter("test01_res.txt");
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

expr	:	IF_OPERATOR {out.print($IF_OPERATOR.text + " (");} B bool_expr {out.print(") {\n");} B expr+ (ELIF_OPERATOR B bool_expr B expr+)* (ELSE_OPERATOR B expr+)? ENDIF_OPERATOR {out.print("}\n");} B?
	|	PRINT_OPERATOR B arithm_expr B?
	|	EQ_OPERATOR B? VARIABLE B arithm_expr B?;

bool_expr
	:	BOOL_BIN_OPERATOR B? arithm_expr B arithm_expr
	|	NOT_OPERATOR B? bool_expr;

arithm_expr
	:	ARITHM_BIN_OPERATOR B? arithm_expr B arithm_expr
	|	NUMBER
	|	VARIABLE;

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
