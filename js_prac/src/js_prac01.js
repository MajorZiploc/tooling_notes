class Person {
  constructor(age, name) {
    this.age = age;
    this.name = name;
  }

  say() {
    console.log(`Hi, my name is ${this.name} and im ${this.age} years old`);
  }
}

function PersonF(age, name) {
  this.age = age;
  this.name = name;
}

PersonF.prototype.say = function () {
  console.log(`From function class thingy: Hi, my name is ${this.name} and im ${this.age} years old`);
};

// Enums
class Season {
  // Create new instances of the same class as static attributes
  static Summer = new Season('summer');
  static Autumn = new Season('autumn');
  static Winter = new Season('winter');
  static Spring = new Season('spring');

  constructor(name) {
    this.name = name;
  }
}

function matrix_prac() {
  console.log('matrix_prac');
  const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  console.log(matrix);
  const two = matrix[0][1];
  console.log(two);
  const nine = matrix[2][2];
  console.log(nine);
}

function queue_prac() {
  // FIFO
  console.log('queue_prac');
  let q = [3, 2, 1]; // think in reverse order
  console.log(q);
  // pop = poll
  let f = q.pop(); // grabs last ele in list (first in queue)
  console.log(f);
  console.log(q);
  // unshift = add
  q.unshift(4); // Adds to the beginning of list (last in queue)
  console.log(q);
}

function stack_prac() {
  // LIFO
  console.log('stack_prac');
  let stack = [3, 2, 1]; // think in reverse order
  console.log(stack);
  let f = stack.pop(); // grabs last ele in list (first in stack)
  console.log(f);
  console.log(stack);
  stack.push(4); // Adds to the ending of list (first in stack)
  console.log(stack);
}

function fib_in_store(n, store) {
  if (store[n] === undefined) {
    store[n] = fib_in(n, store);
  }
  return store[n];
}

function fib_in(n, store) {
  if (n < 2) return n;
  return fib_in_store(n - 1, store) + fib_in_store(n - 2, store);
}

function fib_mem(n) {
  return fib_in(n, {});
}

function groupByKey(lst, key) {
  return lst.reduce((acc, ele) => {
    acc[key] = acc[key] || [];
    acc[key].push(ele);
    return acc;
  }, {});
}

function groupBy(lst, keySupplier) {
  return lst.reduce((acc, ele) => {
    const key = keySupplier(ele);
    acc[key] = acc[key] || [];
    acc[key].push(ele);
    return acc;
  }, {});
}

function zip(a, b) {
  const maxI = (a.length > b.length ? a : b).length;
  const res = [];
  for (var i = 0; i < maxI; i++) {
    res.push([a[i], b[i]]);
  }
  return res;
}

async function main() {
  console.log('spread operator');
  const j = { x: 1, z: 'z' };
  console.log(j.y);
  // the last keys value takes precedence in the spread operator
  const j2 = { x: 2, ...j };
  console.log(j2);
  const j3 = { ...j, ...{ x: 2 } };
  console.log(j3);
  const j35 = { ...j, j3 };
  console.log(j35);
  const j4 = { ...j, y: 2, x: 5 };
  console.log(j4);

  console.log('objects');
  const p = new Person(1, 'bob');
  const p2 = new Person(1, 'bob');
  const p3 = new Person(1, 'sam');
  p.say();
  // native sets are very basic. only works with basic values, not list,json,obj
  const pset = new Set([p, p2, p3]);
  console.log(pset);
  const nset = new Set([1, 1, 3]);
  console.log(nset);
  const jset = new Set([{ x: 1 }, { x: 1 }, {}, {}]);
  console.log(jset);

  queue_prac();
  stack_prac();
  matrix_prac();

  console.log('generate range of numbers. 0,1,2,3,4');
  console.log([...Array(5).keys()]);
  console.log([...Array(15).keys()].map(fib_mem));
  const pf = new PersonF(1, 'sam');
  pf.say();
  const arr = [1, 2, 3];

  console.log('list operations');
  console.log(arr.flatMap(e => [e, e]));
  console.log(arr.every(e => e < 2));
  console.log(arr.some(e => e < 2));
  console.log(arr.find(e => e == 3));
  console.log(arr.find(e => e == 4));
  console.log(zip([1, 2, 3, 4, 5].slice(0, 3), ['a', 'b', 'c']));
  const keyChecks = new Set(['o', 'e']);
  console.log(groupBy(['one', 'two', 'three'], ele => ele.split('').filter(c => keyChecks.has(c)).length));
  // prettier-ignore
  console.log(true ? 'has ternary op'
    : 'ya dig?' === undefined ? 'lol'
    : 'or no?');

  console.log('checking types');
  console.log([].constructor.name);
  console.log([] instanceof Array); // true
  console.log(typeof []); // object
  console.log(p.constructor.name);
  console.log(p instanceof Person); // true
  console.log(typeof p); // object
  console.log({}.constructor.name);
  console.log({} instanceof Object); // true
  console.log(typeof {}); // object

  console.log('string operations');
  const s1 = 'this is A stRing';
  console.log(s1.split(''));
  console.log(s1.split(' '));
  console.log(s1.length);
  const r1 = /st(.{2,})/;
  console.log(s1.replace(r1, 'zz$1zz'));
  const r2 = new RegExp('st(.{2,})');
  console.log(s1.search(r2));
  console.log('hihihi'.search(r2));
  console.log(s1.trim());
  console.log(s1.toLowerCase());
  console.log(s1.toUpperCase());
  console.log(s1.big());
  console.log(s1.charAt(2));
  console.log(s1.substring(3, 10));
  console.log(s1.substring(3, 100));
  console.log(s1.endsWith('stuff'));
  console.log(s1.indexOf(' st'));
  console.log(s1.match(r2));
  console.log(s1.normalize('NFC'));

  const arr2 = [2, 3, 4, 5];
  console.log('for loop basic');
  for (let i = 0; i < arr2.length; i++) {
    console.log(`ele: ${arr2[i]}`);
  }
  console.log('for loop enhanced');
  for (i of arr2) {
    console.log(`ele: ${i}`);
  }
  console.log('for loop over json keys');
  const obj1 = { x: 1, y: 2 };
  for (k in obj1) {
    console.log(`${k}: ${obj1[k]}`);
  }
  Object.keys(obj1).forEach(k => {
    console.log(`${k}: ${obj1[k]}`);
  });
  Object.entries(obj1).forEach(kv => {
    console.log(`${kv}`);
  });

  console.log('Type conversions');
  const x = 1;
  const xs = String(x);
  console.log(xs + 1);
  const y = '1';
  const yi = Number(y);
  console.log(yi + 1);
  const sd = '11/11/2021';
  const ds = Date(sd);
  console.log(ds);

  console.log(p.constructor);

  console.log('Enums');
  const winter = Season.Winter;
  console.log(winter === Season.Summer);
  console.log(winter === Season.Winter);
}

main();
