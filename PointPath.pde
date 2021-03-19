public class PointPath {

  private StringList path;
  public PointPath() {
    this.path = new StringList();
  }
  public int getSize() {
    return this.path.size();
  }
  public void addPath(String point) {
    point = point.toLowerCase();
    if (checkText(point))
      this.path.append(point);
  }
  public void popPath() {
    int len = this.path.size();
    if (len>0)
      this.path.remove(len-1);
  }
  public void removePath(int i) {
    int len = this.path.size();
    if (i>=0 && i<len)
      this.path.remove(i);
  }
  public String getPath(int i) {
    return this.path.get(i);
  }
  public StringList allPath() {
    return this.path;
  }

  public boolean checkText(String text) {
    if (text.indexOf("s(")!=0 && text.indexOf("e(")!=0 && text.indexOf("(")!=0 && text.indexOf("cp(")!=0)
      return false;
    if (text.indexOf(")")!=text.length()-1)
      return false;
    int num1=0;
    int num2=0;
    int num3=0;
    for (int i=0; i<text.length(); i++)
    {
      if (text.charAt(i)=='(')
        num1++;
      if (text.charAt(i)==')')
        num2++;
      if (text.charAt(i)==',')
        num3++;
    }
    if (num1!=1 || num2!=1 || num3!=1)
      return false;

    String substr = text.substring(text.indexOf("(")+1, text.indexOf(")"));
    float[] nums = float(split(substr, ","));
    if (Float.isNaN(nums[0]) || Float.isNaN(nums[1]))
    {
      return false;
    }

    return true;
  }
}
