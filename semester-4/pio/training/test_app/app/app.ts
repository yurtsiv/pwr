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

const studName = /^[A-Z][a-zA-Z]+$/;
const studSurname = /^[A-Z][a-zA-Z]+$/;
const subjName = /^([A-Z][a-zA-Z]+)$/;

const commands: [RegExp[], Function][] = [
  [
    [/^add$/, /^student$/, studName, studSurname],
    (name, surname) => addStudent(`${name} ${surname}`)
  ],
  [
    [/^add$/, /^subject$/, subjName],
    addSubject
  ],
  [
    [/^del$/, /^student$/, studName, studSurname],
    (name, surname) => delStudent(`${name} ${surname}`)
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
    [/^set$/, /^grade$/, studName, studSurname, subjName, /^[2-5]$/],
    (name, surname, subj, grade) => setGrade(`${name} ${surname}`, subj, grade)
  ],
  [
    [/^average$/, studName, studSurname, subjName],
    (name, surname, subj) => getAverage(`${name} ${surname}`, subj)
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
    console.log(res);
    return res;
  } catch (e) {
    console.log('ERROR')
    return 'ERROR';
  }
}

const [_node, _script, ...args] = process.argv;

runApp(args);
