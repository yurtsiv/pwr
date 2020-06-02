import { writeStudents, writeSubjects, addStudent, countStudents, addSubject, countSubjects, delStudent, delSubject } from "./dataUtils"

const student = {
  name: 'Jan',
  surname: 'Kowalski'
};

const subject = 'Physics';

describe('addStudent', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
  });

  it('should add student', () => {
    addStudent(student.name, student.surname); 

    expect(countStudents()).toBe(1);
  });

  it('can not add existing student', () => {
    expect(() => addStudent(student.name, student.surname)).toThrow();
  });
});

describe('addSubject', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
  });

  it('should add subject', () => {
    addSubject(subject); 

    expect(countSubjects()).toBe(1);
  });

  it('can not add existing subject', () => {
    expect(() => addSubject(subject)).toThrow();
  });
});

describe('delStudent', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
    addStudent(student.name, student.surname);
  });

  it('can not delete non existing student', () => {
    expect(() => delStudent('Some', 'Name')).toThrow();
  });

  it('should delete student', () => {
    delStudent(student.name, student.surname);

    expect(countStudents()).toBe(0);
  });

  it('can not delete student if none added', () => {
    expect(() => delStudent('Some', 'Name')).toThrow();
  });
});

describe('delSubject', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
    addSubject(subject);
  });

  it('can not delete non existing subject', () => {
    expect(() => delSubject('Some')).toThrow();
  });

  it('should delete subject', () => {
    delSubject(subject);

    expect(countStudents()).toBe(0);
  });

  it('can not delete subject if none added', () => {
    expect(() => delSubject('Some')).toThrow();
  });
});

// describe('countStudents', () => {
//   beforeAll(() => {
//     writeStudents([]);
//     writeSubjects([]);
//   });

//   it('should be 0', () => {
//     expect(countStudents()).toBe(0);
//   })

//   it('should be 1', () => {
//     addStudent(student.name, student.surname);
//     expect(countStudents()).toBe(1);
//   })
// })

// describe('countStudents', () => {
//   beforeAll(() => {
//     writeStudents([]);
//     writeSubjects([]);
//   });

//   it('should be 0', () => {
//     expect(countStudents()).toBe(0);
//   })

//   it('should be 1', () => {
//     addStudent(student.name, student.surname);
//     expect(countStudents()).toBe(1);
//   })
// })