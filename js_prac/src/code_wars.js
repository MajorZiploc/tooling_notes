// @ts-check

// function guardChoosing(names) {
//   const dutySchedule = [];
//   const points = {};
//   names.forEach(name => (points[name] = 0));

//   for (let day = 0; day < 30; day++) {
//     // Determine the type of duty for the day based on the day of the week
//     let dutyType;
//     if (day % 7 === 4) {
//       // Friday
//       dutyType = 1.5;
//     } else if (day % 7 === 5 || day % 7 === 6) {
//       // Saturday or Sunday
//       dutyType = 2;
//     } else {
//       dutyType = 1;
//     }

//     // Sort the recruits by their points in ascending order
//     const sortedRecruits = names.sort((a, b) => points[a] - points[b]);

//     // Assign duty to the recruit with the fewest points for the day
//     sortedRecruits.some(recruit => {
//       if (points[recruit] + dutyType - points[sortedRecruits[0]] <= 1) {
//         points[recruit] += dutyType;
//         dutySchedule.push(recruit);
//         return true;
//       }
//       return false;
//     });
//   }

//   return dutySchedule;
// }
// function pattern(n) {
//   if (n === 1) return '1';
//   const l = ['1'];
//   let curN = 2;
//   while (curN <= n) {
//     l.push(`1${'*'.repeat(curN - 1)}${curN.toString()}`);
//     curN = curN + 1;
//   }
//   return l.join('\n');
// }

// // "1\n1*2\n1**3")
// // console.log(pattern(3));

// function nextHappyYear(year){
//   let curYear = year + 1;
//   while (!validYear(curYear)) {
//     curYear = curYear + 1;
//   }
//   return curYear;
// }

// function validYear(year) {
//   const seen = new Set();
//   let nums = year;
//   while (nums !== 0) {
//     const lastNum = nums % 10;
//     if (seen.has(lastNum)) {
//       return false;
//     }
//     seen.add(lastNum);
//     nums = Math.floor(nums / 10);
//   }
//   return true;
// }

// // 1023
// // console.log(nextHappyYear(1001));
// // 2013
// console.log(nextHappyYear(2001));


// // console.log(1000 / 10);

// function strongEnough(earthquake, age) {
//   const earthquakeStrength = earthquake.reduce((acc, shockwave) => acc * shockwave.reduce((sacc, tremor) => sacc + tremor, 0), 1);
//   const buildingStrength = 1000 * (Math.E ** (-0.01 * age));
//   return buildingStrength > earthquakeStrength ? "Safe!" : "Needs Reinforcement!";
// }

// // "Safe!"
// console.log(strongEnough([[2,3,1],[3,1,1],[1,1,2]], 2))

// const pointsToGain = [1, 1, 1, 1, 1.5, 2, 2];
// const totalDays = 30;

// function guardChoosing(names) {
//   const recs = names.map(name => ({name, points: 0}));
//   const guardsOfMonth = [];
//   for (let curDay = 1; curDay <= totalDays; curDay++) {
//     const dayPointValue = pointsToGain[(curDay - 1) % pointsToGain.length];
//     recs.sort((r1, r2) => r1.points - r2.points);
//     console.log(recs);
//     recs[0].points = recs[0].points + dayPointValue;
//     guardsOfMonth.push(recs[0].name);
//   }
//   return guardsOfMonth;
// }

// console.log(guardChoosing(['A', 'B', 'C']));


// function incrementString(s) {
//   const m = s.match(/^(.*?)(\d*)$/);
//   const word = m[1];
//   const ogNum = m[2] || '0';
//   const num = `${Number(ogNum) + 1}`;
//   const diff = ogNum.length - num.length;
//   const paddedNum = diff > 0 ? `${'0'.repeat(diff)}${num}` : num;
//   return `${word}${paddedNum}`;
// }

// console.log(incrementString('foo0001'));
// console.log(incrementString('foo'));
// console.log(incrementString('foo1'));


// function fifo(n, referenceList) {
//   const page = [...Array(n).keys()].map(_ => -1);
//   let curIdx = 0;
//   for (const ref of referenceList) {
//     const idx = page.findIndex(i => i === ref);
//     if (idx !== -1) continue;
//     page[curIdx] = ref;
//     curIdx = (curIdx + 1) % n;
//   }
// 	return page;
// }

// // [ 4, 2, 5 ]
// // [4, 5, 3]
// console.log(fifo(3, [1, 2, 3, 4, 2, 5]));

// function lru(n, refs) {
//   const page = [...Array(n).keys()].map(_ => -1);
//   const queue = []
//   for (const ref of refs) {
//     let idx = page.findIndex(p => p === ref);
//     if (idx !== -1) {
//       let i = queue.findIndex(p => p === idx);
//       if (i !== -1) {
//         queue.splice(i, 1);
//         queue.push(idx);
//       } else {
//         queue.push(idx);
//       }
//     } else {
//       let idx = page.findIndex(p => p === -1);
//       if (idx !== -1) {
//         page[idx] = ref;
//         queue.push(idx);
//       } else {
//         idx = queue.splice(0, 1)?.[0]
//         if (idx !== -1) {
//           page[idx] = ref;
//           queue.push(idx);
//         }
//       }
//     }
//   }
//   return page;
// }

// // [5, 2, 3]]
// console.log(lru(3, [1, 2, 3, 4, 3, 2, 5]));
// // [ 8, 6, 7, 2 ]
// // [8, 6, 7, 2]
// // console.log(lru(4, [5, 4, 3, 2, 3, 5, 2, 6, 7, 8]));



// function compress(str) {
//   if (str.length <= 1) return str;
//   let curCompIdx = 0;
//   let lastChar = str[0];
//   const comp = [[1, lastChar]];
//   let idx = 1;
//   while(idx < str.length) {
//     const curChar = str[idx];
//     if (curChar === lastChar) {
//       const [charCount, char] = comp[curCompIdx];
//       comp[curCompIdx] = [charCount + 1, char];
//     } else {
//       lastChar = curChar;
//       curCompIdx++;
//       comp[curCompIdx] = [1, curChar];
//     }
//     idx++;
//   }
//   const strComp = JSON.stringify(comp);
//   return strComp.length < str.length ? strComp : str;
// }

// function tryParse(c) {
//   try {
//     return JSON.parse(c);
//   } catch (err) {
//     return undefined;
//   }
// }

// function decompress(c) {
//   const compList = tryParse(c);
//   if (!compList) return c;
//   return compList.reduce((acc, [count, char]) => acc + char.repeat(count), '');
// }


// // var c1='[[14,"a"],[1,"b"],[41,"a"],[1,"c"]]'
// // [[14,"a"],[1,"b"],[41,"a"],[1,"c"]]
// console.log(decompress(compress('aaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac')));
// // console.log(decompress('aaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac'));

// // var string2= "abcde"
// // var c2= "abcde"



// const planets = {
//   1: 'Mercury',
//   2: 'Venus',
//   3: 'Earth',
//   4: 'Mars',
//   5: 'Jupiter',
//   6: 'Saturn',
//   7: 'Uranus',
//   8: 'Neptune',
// };

// function getPlanetName(id){
//   return planets[id];
// }

// function elapsedSeconds(startDate, endDate){
//   return Math.floor((endDate - startDate) / 1000);
// }

// const start = new Date(2013, 1, 1, 0, 0, 1);
// const end = new Date(2013, 1, 1, 0, 0, 3);
// console.log(elapsedSeconds(start, end));

// function calculate(string) {
//   const m = string.match(/^.*?(\d+).*?(gains|loses).*?(\d+).*?$/);
//   if (!m) return;
//   const num1 = +m[1];
//   const operation = m[2];
//   const num2 = +m[3];
//   if (operation === 'gains') return num1 + num2;
//   if (operation === 'loses') return num1 - num2;
// }

// console.log(calculate("Panda has 36 apples and gains 6"));

// /** @type {(position: number) => number} */
// String.prototype.findParenMatch = function(position) {
//   const na = -1;
//   if (position > this.length) return na;
//   const v = this[position];
//   const isOpen = v === "(";
//   const isClose = v === ")";
//   if (!isOpen && !isClose) return na;
//   const start = isOpen ? position : 0;
//   const end = isOpen ? this.length : position + 1;
//   const stack = [];
//   for (let i = start; i < end; i ++) {
//     const c = this[i];
//     const entry = i;
//     if (c === "(") {
//       stack.push(entry);
//     } else {
//       if (stack.length === 0) continue;
//       const open = stack.pop();
//       if (position === open) return entry;
//       if (position === entry) return open;
//     }
//   }
//   return na;
// };


// let str = ')((()))(';
// // 1
// // console.log(str.findParenMatch(6));
// // 6
// console.log(str.findParenMatch(1));

// class TreeNode {
//     constructor(value, left = null, right = null) {
//         this.value = value;
//         this.left = left;
//         this.right = right;
//     }
// }

// /** @type{(root: TreeNode) => number} */
// function maxSum(root) {
//   if (!root) return 0;
//   if (root.left && root.right) return root.value + Math.max(maxSum(root.left), maxSum(root.right));
//   if (root.left) return root.value + maxSum(root.left);
//   if (root.right) return root.value + maxSum(root.right);
//   return root.value;
// }

// /** @type{(root: TreeNode) => number} */
// function maxSum2(root) {
//   if (!root) return 0;
//   return maxSumHelper(root, 0);
// }

// /** @type{(root: TreeNode, acc: number) => number} */
// function maxSumHelper(root, acc) {
//   const newAcc = acc + root.value;
//   if (root.left && root.right) return Math.max(maxSumHelper(root.left, newAcc), maxSumHelper(root.right, newAcc));
//   if (root.left) return maxSumHelper(root.left, newAcc);
//   if (root.right) return maxSumHelper(root.right, newAcc);
//   return newAcc;
// }

// https://www.codewars.com/kata/56c8bc4afd8fc0593d0009ab/train/javascript

// /** @type{(offset: number, totalDays: number) => number[]}*/
// function getDaysIndices(offset, totalDays) {
//   const idxs = [];
//   let cidx = offset;
//   while (cidx < totalDays) {
//     idxs.push(cidx);
//     cidx += 7;
//   }
//   return idxs;
// }

// /** @type{(names: string[]) => string[]}*/
// function guardChoosing(names) {
//   /** @type{string[]} */
//   const schedule = [];
//   const totalDays = 30;
//   const weekdays = {
//     weight: 1,
//     days: [
//       ...getDaysIndices(0, totalDays),
//       ...getDaysIndices(1, totalDays),
//       ...getDaysIndices(2, totalDays),
//       ...getDaysIndices(3, totalDays),
//     ]
//   };
//   const fridays = {
//     weight: 1.5,
//     days: getDaysIndices(4, totalDays),
//   };
//   const weekends = {
//     weight: 1.5,
//     days: [...getDaysIndices(5, totalDays), ...getDaysIndices(6, totalDays)],
//   };
//   const personLoads = names.map(name => ({name, load: 0}));
//   for (const dayGroup of [weekends, fridays, weekdays]) {
//     for (const day of dayGroup.days) {
//       const lowestLoad = personLoads.reduce((lowest, personLoad) => lowest.load < personLoad.load ? lowest : personLoad, personLoads[0]);
//       lowestLoad.load += dayGroup.weight;
//       schedule[day] = lowestLoad.name;
//     }
//   }
//   return schedule;
// }

// console.log(guardChoosing(['A', 'B', 'C']));
