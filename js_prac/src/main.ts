export enum RecordStatus {
  DRAFT = 1,
  ACTIVE = 2,
  DELETED = 3,
  SUSPENDED = 4,
}

async function main () {
  console.log(RecordStatus[4]);
}

main();


const getCellText = (v: any) => {
  return v ?? '--';
};
console.log(getCellText(null));


let n = [1,2,3,4,5, 5.5]
console.log(n.map(i => i % 1))
console.log(n.map(i => i & 1))


let x = {'y': 1}
console.log(x?.[true ? 'y' : 'y']);
