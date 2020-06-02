import {Student, Subject} from './types';
import {studentsFile, subjectsFile} from './constants';
import {writeJSONFile, readJSONFile} from './helpers';

export const readStudents: () => Student[] = readJSONFile(studentsFile);
export const readSubjects: () => Subject[] = readJSONFile(subjectsFile);

export const writeStudents: (s: Student[]) => void = writeJSONFile(studentsFile);
export const writeSubjects: (s: Subject[]) => void = writeJSONFile(subjectsFile);

export const findStudent = (studs: Student[], name: string, surname: string) =>
  studs.find(s => s.name === name && s.surname === surname);

export const addStudent = (name: string, surname: string) => {
  const students = readStudents();

  if (findStudent(students, name, surname)) throw new Error('Student already exists');

  students.push({name, surname, grades: []})

  writeStudents(students);
}

export const addSubject = (name: string) => {
  const subjects = readSubjects();

  const existingSubj = subjects.find(s => s === name);

  if (existingSubj) throw new Error('Subject already exists');

  subjects.push(name);

  writeSubjects(subjects);
}

export const delStudent = (name: string, surname: string) => {
  const students = readStudents();

  if (!students.length)
    throw new Error('No students');

  const newStudents = students.filter(s => s.name !== name && s.surname !== surname);

  if (newStudents.length === students.length)
    throw new Error('Student does not exist');
 
  writeStudents(newStudents);
}

export const delSubject = (name: string) => {
  const subjects = readSubjects();

  if (!subjects.length)
    throw new Error('No subjects');

  const newSubjects = subjects.filter(s => s !== name);

  if (newSubjects.length === subjects.length)
    throw new Error('Subject does not exist');
  
  
  const students = readStudents();
  const newStudents = students.map(s => ({
    ...s,
    grades: s.grades.filter(g => g.subject !== name)
  }));

  writeSubjects(newSubjects);
  writeStudents(newStudents);
}

export const countStudents = () => readStudents().length;

export const countSubjects = () => readSubjects().length;

export const setGrade = (studName: string, studSurname: string, subjName: string, grade: number) => {
  const students = readStudents();
  const student = findStudent(students, studName, studSurname);
  if (!student) throw new Error('Student does not exist');

  const subjects = readSubjects(); 
  const subject = subjects.find(s => s === subjName);

  if (!subject) throw new Error('Subject does not exist');

  const newStudents = students.map(s => {
    if (s.name === studName && s.surname === studSurname) {
      return {
        ...s,
        grades: [
          ...s.grades,
          {
            value: grade,
            subject
          }
        ]
      }
    }

    return s;
  });


  writeStudents(newStudents);
}

export const getAverage = (studName: string, studSurname: string, subjName: string) => {
  const students = readStudents();

  const student = findStudent(students, studName, studSurname);
  if (!student) return '0.0';

  const grades = student.grades.filter(g => g.subject === subjName);
  if (!grades.length) return '0.0';

  const sum = grades.reduce((acc, g) => acc + g.value, 0);
  return (sum / grades.length).toFixed(1);
}