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

// union type , abstract data type
const construct = (type, values) => ({
  case: cases => cases[type].apply(null, values),
});

const Answer = {
  Response: response => construct('Response', [response]),
  Declined: construct('Declined', []),
  Undecided: construct('Undecided', []),
};

function spreadPrac() {
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
}

function objectPrac() {
  console.log('objects');
  const p = new Person(1, 'bob');
  p.say();
  const pf = new PersonF(1, 'sam');
  pf.say();
  const j1 = {x: 1};
  // copying json methods
  // 1 unknown how good this one is. but proly pretty good, doesnt seem to be in vanilla node
  // let j2 = structuredClone(j1);
  // 2 not very deep
  j2 = {...j1}
  // 3 doesnt retain things that cant go into a json
  j2 = JSON.parse(JSON.stringify(j1));
}

function uniqBy(jsons, keySupplier) {
  return Object.values(
    jsons.reduce((acc, el) => {
      const key = keySupplier(el);
      if (acc.hasOwnProperty(key)) return acc;
      acc[key] = el;
      return acc;
    }, {})
  );
}

function setPrac() {
  const p = new Person(1, 'bob');
  const p2 = new Person(1, 'bob');
  const p3 = new Person(1, 'sam');
  // native sets are very basic. only works with basic values, not list,json,obj
  const pset = new Set([p, p2, p3]);
  console.log(pset);
  const nset = new Set([1, 1, 3]);
  console.log(nset);
  const jset = new Set([{ x: 1 }, { x: 1 }, {}, {}]);
  console.log(jset);
  // own set method by built json key reducer
  const js = [{
    x: 1,
    y: 2,
    z: 4,
  },
  {
    x: 1,
    y: 3,
    z: 5,
  },
  {
    x: 1,
    y: 2,
    z: 6,
  }
  ];
  console.log(uniqBy(js, j => `${j.x}${j.y}`).sort((a, b) => a.z - b.z));
}

function queuePrac() {
  console.log('queuePrac');
  // FIFO
  let q = [1, 2, 3]; // think in normal order
  console.log(q);
  // pop = poll
  let f = q.shift(); // grabs last ele in list (first in queue)
  console.log(f);
  console.log(q);
  // unshift = add
  q.push(4); // Adds to the beginning of list (last in queue)
  console.log(q);
  // OR FIFO
  q = [3, 2, 1]; // think in reverse order
  console.log(q);
  // pop = poll
  f = q.pop(); // grabs last ele in list (first in queue)
  console.log(f);
  console.log(q);
  // unshift = add
  q.unshift(4); // Adds to the beginning of list (last in queue)
  console.log(q);
}

function stackPrac() {
  // LIFO
  console.log('stackPrac');
  let stack = [3, 2, 1]; // think in reverse order
  console.log(stack);
  let f = stack.pop(); // grabs last ele in list (first in stack)
  console.log(f);
  console.log(stack);
  stack.push(4); // Adds to the ending of list (first in stack)
  console.log(stack);
}

function matrixPrac() {
  console.log('matrixPrac');
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
  const minI = (a.length > b.length ? b : a).length;
  const res = [];
  for (var i = 0; i < minI; i++) {
    res.push([a[i], b[i]]);
  }
  return res;
}

function chunk(arr, n) {
  const chunkedArr = [];
  while (arr.length !== 0) {
    chunkedArr.push(arr.splice(0, n));
  }
  return chunkedArr;
}

function toKeyValArray(json) {
  if (json === null || json === undefined) {
    return json;
  }
  return Object.keys(json).map(key => ({ key: key, value: json[key] }));
}

function fromKeyValArray(keyValueArray) {
  if (keyValueArray === null || keyValueArray === undefined) {
    return keyValueArray;
  }
  return keyValueArray.reduce((acc, ele) => {
    acc[ele.key] = ele.value;
    return acc;
  }, {});
}

function flatten(thing) {
  return thing.constructor.name === 'Array' ?
    thing.reduce((acc, ele) => {
      const flatEle = flatten(ele);
      if (flatEle.constructor.name === 'Array') {
        acc = acc.concat(flatEle);
      }
      else {
        acc.push(flatEle);
      }
      return acc;
      }, [])
    : thing;
}

function chunkArray(inputArray, chunkSize) {
  const chunkedArray = [];
  for (let i = 0; i < inputArray.length; i += chunkSize) {
    chunkedArray.push(inputArray.slice(i, i + chunkSize));
  }
  return chunkedArray;
}

function listOperations() {
  const arr = [1, 2, 3];
  console.log('list operations');
  console.log(arr.flatMap(e => [e, e]));
  console.log(arr.every(e => e < 2));
  console.log(arr.some(e => e < 2));
  console.log(arr.find(e => e == 3));
  console.log(arr.findIndex(e => e == 3));
  console.log(arr.find(e => e == 4));
  // list.chunk
  const myArray = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  const chunkedArray = chunkArray(myArray, 3);
  console.log(chunkedArray);

  // remove indices 1 and 2 in place and return the removed elements
  console.log(arr.splice(1, 2));
  // remove index 0 in place and return the removed elements
  console.log(arr.splice(0));
  console.log(zip([1, 2, 3, 4, 5].slice(0, 3), ['a', 'b', 'c']));
  console.log(chunk([...Array(20).keys()], 6));
  // array for 20 zeros
  console.log(Array(20).fill(0));
  const keyChecks = new Set(['o', 'e']);
  console.log(groupBy(['one', 'two', 'three'], ele => ele.split('').filter(c => keyChecks.has(c)).length));
  console.log(flatten([1, [2], 3, [[4], 5]]));
  const distinctBy = (items, key) => [...new Map(items.map(item => [item[key], item])).values()];
  const basicObjs = [...Array(5).keys(), ...Array(5).keys()].map(i => ({x: i}));
  console.log(distinctBy(basicObjs, 'x'));
}

function typeCheckingPrac() {
  console.log('checking types');
  console.log([].constructor.name); // Array
  console.log([] instanceof Array); // true
  console.log(typeof []); // object
  const p = new Person(1, 'bob');
  console.log(p.constructor.name); // Person
  console.log(p instanceof Person); // true
  console.log(typeof p); // object
  console.log({}.constructor.name); // Object
  console.log({} instanceof Object); // true
  console.log(typeof {}); // object
  console.log(''.constructor.name); // String
}

function stringPrac() {
  console.log('string operations');
  const s1 = 'this is A stRing';
  console.log(s1.split(''));
  // string to and from list
  console.log(s1.split('').join(''));
  console.log(s1.split(' '));
  console.log(s1.length);
  // pad string
  // padRight
  let originalString = "Hello";
  const paddedRightString = originalString + 'z'.repeat(32);
  console.log(paddedRightString);
  // padLeft
  const paddedLeftString = 'z'.repeat(32) + originalString;
  console.log(paddedLeftString);
  // pad string better
  console.log('a'.padEnd(10, 'z'));
  console.log('a'.padStart(10, 'z'));
  const r1 = /st(.{2,})/g;
  console.log(s1.replace(r1, 'zz$1zz'));
  const r2 = new RegExp('st(.{2,})', 'g');
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
  // (?=.*<pattern>) positive look ahead assert
  // ex> (?=.*\d) checks that the string has at least 1 digit
  // this regex checks that the string has at least 1 digit, lower and upper. with at least 6 chars total of alphanum
  const REGEXP = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[A-Za-z\d]{6,}$/;
  var r = /(g.)/ig;
  var s2 = 'i  got gs';
  console.log(s2.match(r));
}

function forLoopPrac() {
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
}

function typeConversionPrac() {
  console.log('Type conversions');
  const x = 1;
  const xs = String(x);
  console.log(xs + 1);
  const y = '1';
  let yi = Number(y);
  // OR
  yi = +y;
  // OR
  // yi = parseInt(y);
  console.log(isNaN(yi));
  console.log(yi + 1);
  const sd = '11/11/2021';
  const ds = new Date(sd);
  console.log(ds);
  // Check if a date is invalid
  console.log(isNaN(ds));
  const p = new Person(1, 'bob');
  console.log(p.constructor);
  let thing = 'a truthy thing!';
  // to boolean
  let b = !!b;
  // OR
  b = Boolean(b);
}

function enumPrac() {
  console.log('Enums');
  const winter = Season.Winter;
  console.log(winter === Season.Summer);
  console.log(winter === Season.Winter);
}

function unionPrac() {
  console.log('Unions');
  const answer = Answer.Response('sure thing!');
  const answerString = answer.case({
    Response: response => `I answered: ${response}`,
    Declined: () => `I'd rather not say`,
    Undecided: () => `I'm still thinking...`,
  });
  console.log(answerString);
}

function yieldPrac() {
  console.log('yieldPrac');
  function* yieldMeSomethingMister() {
    yield 1;
    yield 2;
  }
  console.log([...yieldMeSomethingMister()]);
}

async function throwThing() {
  throw {x: 'info'};
}
throwThing().catch(err => console.log(err));

function miscPrac() {
  // Null coalese
  console.log(null?.x.y());
  console.log(null?.['x'].y());
  console.log(null?.x?.y?.());
  let funcName = 'toString';
  let foo = undefined;
  foo?.[funcName]?.();
  const f = (maxArea, sampleArea) => (maxArea = sampleArea > maxArea ? sampleArea : maxArea)
  console.log(f(2,3));
  console.log([1,2,3,1].reduce(
  (maxArea, sampleArea) =>
    (maxArea = sampleArea > maxArea ? sampleArea : maxArea),
  0.0,
));
  const harvestActivities = [
    {
      yields: [{
        yieldUom: 1
      }
      ]
    },
    {
      yields: [{
        yieldUom: 2
      }
      ]
    }
  ]
  const harvestUoms = harvestActivities
      .flatMap(activity => activity.yields.map(y => y.yieldUom))
      .filter((v, i, a) => a.indexOf(v) === i);
  console.log(harvestUoms)
}

async function main() {
  console.log('generate range of numbers. 0,1,2,3,4');
  console.log([...Array(5).keys()]);
  console.log([...Array(15).keys()].map(fib_mem));
  // prettier-ignore
  console.log(true ? 'has ternary op'
    : 'ya dig?' === undefined ? 'lol'
    : 'or no?');
  spreadPrac();
  objectPrac();
  setPrac();
  queuePrac();
  stackPrac();
  matrixPrac();
  listOperations();
  typeCheckingPrac();
  stringPrac();
  forLoopPrac();
  typeConversionPrac();
  enumPrac();
  unionPrac();
  yieldPrac();
  miscPrac();
}

main();

const biweekly = 2700;
// const biweekly_deductions = 1100;
const biweekly_deductions = 0;
const weekly_deductions = biweekly_deductions / 2;
const weekly = biweekly / 2;
const weekly_after_deductions = weekly - weekly_deductions;
const weekly_expenses = 500;
const weekly_investable = weekly_after_deductions - weekly_expenses;
const annual_investable = weekly_investable * 56;
console.log(weekly_investable);
console.log(annual_investable);
