class Node {
  constructor(v, left_node = null, right_node = null) {
    this.v = v;
    this.left_node = left_node;
    this.right_node = right_node;
  }
}

class BinaryTree {
  constructor(node) {
    this.node = node;
  }

  dfs_pre_order() {
    this.dfs_pre_order_helper(this.node);
  }

  dfs_pre_order_helper(node) {
    if (node != null) {
      console.log(node.v);
      this.dfs_pre_order_helper(node.left_node);
      this.dfs_pre_order_helper(node.right_node);
    }
  }

  bfs() {
    const q = [this.node];
    while (q.length !== 0) {
      // process node
      const cur_node = q.pop();
      console.log(cur_node.v);

      // add its children to the queue
      const children = [cur_node.left_node, cur_node.right_node];
      for (const child of children) {
        if (child !== null) q.unshift(child);
      }
    }
  }
}

function main() {
  const tree1 = new BinaryTree(new Node(1, new Node(2, null, new Node(5)), new Node(3, new Node(6))));
  tree1.dfs_pre_order();
  console.log('');
  tree1.bfs();
}

main();
