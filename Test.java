import org.antlr.runtime.*;
import java.io.File;
import java.io.FileInputStream;

public class Test {
    public static void main(String[] args) {
        try {
        	ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(new File("test01.txt")));
        	PrefixLexer lexer = new PrefixLexer(input);
        	CommonTokenStream tokens = new CommonTokenStream(lexer);
        	PrefixParser parser = new PrefixParser(tokens);
        	parser.s();
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }
}
