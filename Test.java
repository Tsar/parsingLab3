import org.antlr.runtime.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;

public class Test {
    public static void main(String[] args) {
        for (String testName : args) {
            System.out.printf("Running parser on test '%s'...\n", testName);
            try {
                ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(new File("tests/" + testName + ".txt")));
                PrefixLexer lexer = new PrefixLexer(input);
                CommonTokenStream tokens = new CommonTokenStream(lexer);
                PrefixParser parser = new PrefixParser(tokens);
                parser.s();
                PrintWriter out = new PrintWriter("tests/" + testName + "_res.cpp");
                out.print(parser.getCode());
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
