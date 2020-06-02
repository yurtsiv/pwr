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

const commands: [RegExp, Function][] = [
  [
    /add student [A-Z][a-zA-Z]+ ([A-Z][a-zA-Z]+)$/,
    addStudent
  ],
  [
    /add subject ([A-Z][a-zA-Z]+)$/,
    addSubject
  ],
  [
    /del student [A-Z][a-zA-Z]+ ([A-Z][a-zA-Z]+)$/,
    delStudent
  ],
  [
    /del subject ([A-Z][a-zA-Z]+)$/,
    delSubject
  ],
  [
    /count students$/,
    countStudents
  ],
  [
    /count subjects$/,
    countSubjects
  ],
  [
    /set grade [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+ [2-5]$/,
    setGrade
  ],
  [
    /average [A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+ ([A-Z][a-zA-Z]+)$/,
    getAverage
  ]
] 

export const runApp = (args) => {
  const argsString = args.join(' ').trim();

  const command = commands.find((c) => c[0].test(argsString))

  if (!command) {
    return console.log('ERROR');
  } 

  const [_regEx, func] = command;

  const funcArgs = args.slice(
    args.length - func.length,
    args.length
  );

  try {
    const res = func(...funcArgs) ?? 'OK';
    console.log(res)
  } catch (e) {
    console.log('ERROR')
  }
}

const [_node, _script, ...args] = process.argv;
runApp(args);
