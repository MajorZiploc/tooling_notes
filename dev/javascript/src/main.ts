enum RecordStatus {
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


console.log(160/18);


// this regex doesnt work on my version of typescript or javascript - the \s* isnt working - does [[:blank:]]* work instead?

let ee = 'error: {"error":[{"code":"400","name":"rest call error","description":"statuscode: 400. \"{\"statuscode\":1070,\"message\":\"requested time cannot be in the past.\",\"errordata\":null}\"","data":"{\"statuscode\":1070,\"message\":\"requested time cannot be in the past.\",\"errordata\":null}"}]}';
const regex = new RegExp('.*message.:[ \t\n]*"(.*?)".*');
console.log(ee.replace(regex, '$1'));

// console.log(ee.replace(/.*message.:\s*"(.*?)".*/, '$1'));
