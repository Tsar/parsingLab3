grammar Prefix;

@header {
import java.util.Set;
import java.util.HashSet;
}

@members {
String code, codeBeginning;
int codeOffset;
boolean newLine;
Set<String> varNames;

private void init() {
	codeBeginning = "#include <iostream>\n\nint main() {\n";
	code = "";
	codeOffset = 1;
	newLine = true;
	varNames = new HashSet<String>();
}

private void deinit() {
	if (!varNames.isEmpty()) {
		codeBeginning += "    int ";
		boolean firstVar = true;
		for (String varName : varNames) {
			if (!firstVar) {
				codeBeginning += ", " + varName;
			} else {
				codeBeginning += varName;
				firstVar = false;
			}
		}
		codeBeginning += ";\n";
	}
	code += "    return 0;\n}\n";
	code = codeBeginning + code;
}

private void addCode(String s) {
	if (s.length() == 0)
		return;
	if (s.charAt(0) == '}')
		--codeOffset;
	if (newLine) {
		for (int i = 0; i < codeOffset; ++i)
			code += "    ";
	}
	code += s;
	if (s.length() > 1 && s.charAt(s.length() - 2) == '{')
		++codeOffset;
	newLine = (s.charAt(s.length() - 1) == '\n');
}

public String getCode() {
	return code;
}
}

s	:	{init();} B? expr* {deinit();};

expr	:	IF_OPERATOR {addCode("if ");} B bool_expr {addCode(" {\n");} B expr+
		(ELIF_OPERATOR {addCode("} else if ");} B bool_expr {addCode(" {\n");} B expr+)*
		(ELSE_OPERATOR {addCode("} else {\n");} B expr+)?
		ENDIF_OPERATOR {addCode("}\n");} B?
	|	PRINT_OPERATOR {addCode("std::cout << ");} B arithm_expr {addCode(" << std::endl;\n");} B?
	|	EQ_OPERATOR B? VARIABLE {varNames.add($VARIABLE.text); addCode($VARIABLE.text + " = ");} B arithm_expr {addCode(";\n");} B?;

bool_expr
	:	BOOL_BIN_OPERATOR {addCode("(");} B? arithm_expr {addCode(" " + $BOOL_BIN_OPERATOR.text + " ");} B arithm_expr {addCode(")");}
	|	NOT_OPERATOR {addCode("(!");} B? bool_expr {addCode(")");};

arithm_expr
	:	ARITHM_BIN_OPERATOR {addCode("(");} B? arithm_expr {addCode(" " + $ARITHM_BIN_OPERATOR.text + " ");} B arithm_expr {addCode(")");}
	|	NUMBER {addCode($NUMBER.text);}
	|	VARIABLE {varNames.add($VARIABLE.text); addCode($VARIABLE.text);};

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

VARIABLE:	('A'..'Z' | 'a'..'z' | '_')('A'..'Z' | 'a'..'z' | '_' | '0'..'9')*;

B	:	(' ' | '\n' | '\t')+;
