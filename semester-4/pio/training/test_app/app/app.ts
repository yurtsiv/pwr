#!/usr/bin/env node

import {
  addStudent,
  addSubject,
  delStudent,
  delSubject,
  countStudents,
  countSubjects,
  setGrade,
  getAverage
} from './dataUtils';

const studName = /^[A-Z][a-zA-Z]+ ([A-Z][a-zA-Z]+)$/;
const subjName = /^([A-Z][a-zA-Z]+)$/;

const commands: [RegExp[], Function][] = [
  [
    [/^add$/, /^student$/, studName],
    addStudent
  ],
  [
    [/^add$/, /^subject$/, subjName],
    addSubject
  ],
  [
    [/^del$/, /^student$/, studName],
    delStudent
  ],
  [
    [/^del$/, /^subject$/, subjName],
    delSubject
  ],
  [
    [/^count$/, /^students$/],
    countStudents
  ],
  [
    [/^count$/, /^subjects$/],
    countSubjects
  ],
  [
    [/^set$/, /^grade$/, studName, subjName, /^[2-5]$/],
    setGrade
  ],
  [
    [/^average$/, studName, subjName],
    getAverage
  ]
] 

export const runApp = (args: string[]) => {
  const command = commands.find(([regs, func]) =>
    args.length === regs.length &&
    regs.every((reg, index) => reg.test(args[index]))  
  );

  if (!command) {
    console.log('ERROR');
    return 'ERROR';
  } 

  const [_regEx, func] = command;

  const funcArgs = args.slice(
    args.length - func.length,
    args.length
  );

  try {
    const res = func(...funcArgs) ?? 'OK';
    return res;
  } catch (e) {
    console.log('ERROR')
    return 'ERROR';
  }
}

const [_node, _script, ...args] = process.argv;
console.log(args);
runApp(args);
