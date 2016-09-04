const step1 = () => console.log('step1');
const step2 = () => console.log('setp2');
const step3 = () => console.log('step3');
const step4 = () => console.log('step4');


const funcs = [ step4, step3, step2, step1 ];
const start = funcs[funcs.length - 1];
const rest = funcs.slice(0, -1);

const solve = (...args) => rest.reduceRight((currentReturn, nextFunc) => nextFunc(currentReturn), start(...args));

solve();
