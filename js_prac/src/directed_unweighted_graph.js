class Node {
  constructor(v) {
    this.v = v;
  }
}

class Graph {
  constructor(nodes, relationships) {
    this.nodes = nodes;
    this.relationships = relationships;
  }

  bfs() {
    if (this.nodes.length === 0) return;
    const q = [this.nodes[0]];
    const seen = {};
    while (q.length !== 0) {
      const cur_node = q.pop();
      if (seen[cur_node.v] === undefined) {
        console.log(cur_node.v);
        seen[cur_node.v] = cur_node.v;
      }

      const children = this.relationships[cur_node.v] ?? [];
      for (const child of children) {
        if (seen[child.v] === undefined) {
          q.unshift(child);
        }
      }
    }
  }

  dfs() {
    if (this.nodes.length === 0) return;
    const stack = [this.nodes[0]];
    const seen = {};
    while (stack.length !== 0) {
      const cur_node = stack.pop();
      if (seen[cur_node.v] === undefined) {
        console.log(cur_node.v);
        seen[cur_node.v] = cur_node.v;
      }

      const children = this.relationships[cur_node.v] ?? [];
      for (const child of children) {
        if (seen[child.v] === undefined) {
          stack.push(child);
        }
      }
    }
  }
}

function main() {
  const a = new Node('a');
  const b = new Node('b');
  const c = new Node('c');
  const d = new Node('d');

  const relationships = {};
  relationships[a.v] = [b, c];
  relationships[b.v] = [d];
  relationships[c.v] = [d, a];
  relationships[d.v] = [a];

  const graph = new Graph([a, b, c, d], relationships);
  graph.bfs();
  console.log();
  graph.dfs();
}

main();
