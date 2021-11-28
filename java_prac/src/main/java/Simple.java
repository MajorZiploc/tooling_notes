public class Simple {

  public class TreeNode {
    TreeNode left;
    TreeNode right;
    int value;
    public TreeNode(TreeNode left, TreeNode right, int value) {
      this.left = left;
      this.right = right;
      this.value = value;
    }
  }

  public static void main(String args[]) {
    System.out.println("Hello Java");
    Simple simple = new Simple();
    TreeNode tree = simple.new TreeNode(null, simple.new TreeNode(null, null, 2), 1);
    System.out.println(tree);
    System.out.println(maxSum(tree));
  }

  static int maxSum(TreeNode tree) {
    if (tree.left == null && tree.right == null) return tree.value;
    if (tree.right == null) return tree.value + maxSum(tree.left);
    if (tree.left == null) return tree.value + maxSum(tree.right);
    return tree.value + Math.max(maxSum(tree.left), maxSum(tree.right));
  }

}
