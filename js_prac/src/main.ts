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
