const jtu = require('json-test-utility');
const jr = jtu.jsonRefactor;

function operationOnTypeForJson(json, operation, type = 'String') {
  return jr.fromKeyValArray(
    jr.toKeyValArray(json).map(kv => ({ ...kv, value: operationOnValue(kv.value, operation, type) }))
  );
}

function operationOnValue(value, operation, type = 'String') {
  if (value?.constructor.name === type) {
    return operation(value);
  } else if (value?.constructor.name === 'Object') {
    return operationOnTypeForJson(value, operation, type);
  } else if (value?.constructor.name === 'Array') {
    return value.map(v => operationOnValue(v, operation, type));
  } else {
    return value;
  }
}
