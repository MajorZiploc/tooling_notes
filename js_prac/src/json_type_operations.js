const jtu = require('json-test-utility');
const jr = jtu.jsonRefactor;

function operationOnTypeForJson(json, operation, type = 'String') {
  return jr.fromKeyValArray(
    jr.toKeyValArray(json).map(kv => operationOnKeyValuePair(kv, operation, type))
  );
}

function operationOnKeyValuePair(kv, operation, type = 'String') {
  if (kv.value?.constructor.name === type) {
    return { ...kv, value: operation(kv.value) };
  } else if (kv.value?.constructor.name === 'Object') {
    return { ...kv, value: operationOnTypeForJson(kv.value, operation, type) };
  } else if (kv.value?.constructor.name === 'Array') {
    return { ...kv, value: kv.value.map(v => operationOnKeyValuePair(v, operation, type)) };
  } else {
    return kv;
  }
}

