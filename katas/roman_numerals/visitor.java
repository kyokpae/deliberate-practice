import java.util.HashMap;
import java.util.Map;

public class RomanNumerals {
  
  public interface RomanNumeral {
    void accept(Visitor visitor); 
  }
  
  public interface Visitor {
    void visit(I num);
    void visit(V num);
    void visit(X num);
    void visit(L num);
    void visit(C num);
    void visit(D num);
    void visit(M num);
  }

  static class I implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }
  
  static class V implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }

  static class X implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }

  static class L implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }

  static class C implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }

  static class D implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }

  static class M implements RomanNumeral {
    @Override
    public void accept(Visitor visitor) {
      visitor.visit(this);
    }
  }
  
  public static class RomanNumeralConverter {
    
    private static RomanNumeralConverter INSTANCE = new RomanNumeralConverter();
    
    private final Map<Character, RomanNumeral> map = new HashMap<Character, RomanNumeral>();
    
    private RomanNumeralConverter() {
      map.put('I', new I());
      map.put('V', new V());
      map.put('X', new X());
      map.put('L', new L());
      map.put('C', new C());
      map.put('D', new D());
      map.put('M', new M());
    }
    
    public static RomanNumeral convert(char c) {
      return INSTANCE.doConvert(c);
    }
    
    private RomanNumeral doConvert(char c) {
      return map.get(c);
    }
  }  
  
  static class ConvertingVisitor implements Visitor {

    private char prev;
    private int value;
    
    public static Integer convert(String number) {
      ConvertingVisitor visitor = new ConvertingVisitor();
      for (int i = 0; i < number.length(); i++) {
        char c = number.charAt(i);
        RomanNumeral numeral = RomanNumeralConverter.convert(c);
        if (numeral == null) {
          return null;
        }
        numeral.accept(visitor);
        visitor.prev = c;
      }
      return visitor.value;
    }
    
    @Override
    public void visit(I num) {
      value += 1;
    }

    @Override
    public void visit(V num) {
      value += (wasPrevious('I')) ? 3 : 5;
    }

    @Override
    public void visit(X num) {
      value += (wasPrevious('I')) ? 8 : 10;
    }

    @Override
    public void visit(L num) {
      value += (wasPrevious('X')) ? 30 : 50;
    }

    @Override
    public void visit(C num) {
      value += (wasPrevious('X')) ? 80 : 100;
    }

    @Override
    public void visit(D num) {
      value += (wasPrevious('C')) ? 300 : 500;
    }

    @Override
    public void visit(M num) {
      value += (wasPrevious('C')) ? 800 : 1000;
    }

    private boolean wasPrevious(char c) {
      return (prev == c);
    }  
  }  

  public static void main(String[] args) {   
    System.out.println(ConvertingVisitor.convert("MCMLXXXII"));
  }
}
