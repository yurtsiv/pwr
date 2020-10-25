import {
  writeStudents,
  writeSubjects,
  addStudent,
  countStudents,
  addSubject,
  countSubjects,
  delStudent,
  delSubject,
  setGrade,
  readStudents,
  findStudent,
  getAverage
} from "./dataUtils"

const student = 'Jan';
const subject = 'Physics';

describe('countStudents', () => {
  beforeAll(() => {
    writeStudents([]);
  });

  it('should be 0', () => {
    expect(countStudents()).toBe(0);
  })

  it('should be 1', () => {
    addStudent(student);
    expect(countStudents()).toBe(1);
  })
})

describe('countSubjects', () => {
  beforeAll(() => {
    writeSubjects([]);
  });

  it('should be 0', () => {
    expect(countSubjects()).toBe(0);
  })

  it('should be 1', () => {
    addSubject(subject);
    expect(countSubjects()).toBe(1);
  })
})

describe('addStudent', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
  });

  it('should add student', () => {
    addStudent(student)

    expect(countStudents()).toBe(1);
  });

  it('can not add existing student', () => {
    expect(() => addStudent(student)).toThrow();
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
    addStudent(student);
  });

  it('can not delete non existing student', () => {
    expect(() => delStudent('Some')).toThrow();
  });

  it('should delete student', () => {
    delStudent(student);

    expect(countStudents()).toBe(0);
  });

  it('can not delete student if none added', () => {
    expect(() => delStudent('Some')).toThrow();
  });
});

describe('setGrade', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);

    addStudent(student);
    addStudent('Other');
    addSubject(subject);
  });

  it('should add grades', () => {
    setGrade(
      student,
      subject,
      '3'
    );

    setGrade(
      student,
      subject,
      '4'
    );

    const stud = findStudent(readStudents(), student);

    expect(stud.grades).toEqual([
      {
        value: 3,
        subject,
      },
      {
        value: 4,
        subject
      }
    ])
  });

  it('can not set grade for non existing student', () => {
    expect(() => setGrade('Some', subject, '2')).toThrow();
  });

  it('can not set grade with non existing subject', () => {
    expect(() => setGrade(student, 'InvalidSubj', '2')).toThrow();
  });
});

describe('delSubject', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
    addSubject(subject);
    addStudent(student);
    setGrade(student, subject, '2');
  });

  it('can not delete non existing subject', () => {
    expect(() => delSubject('Some')).toThrow();
  });

  it('should delete subject and grades where it occurs', () => {
    delSubject(subject);

    expect(countSubjects()).toBe(0);

    const stud = findStudent(
      readStudents(),
      student
    );

    expect(stud.grades).toEqual([]);
  });

  it('can not delete subject if none added', () => {
    expect(() => delSubject('Some')).toThrow();
  });
});


describe('getAverage', () => {
  beforeAll(() => {
    writeStudents([]);
    writeSubjects([]);
    addSubject(subject);
    addStudent(student);
    setGrade(student, subject, '2');
    setGrade(student, subject, '3');
    setGrade(student, subject, '5');
  });

  it('returns rounded average', () => {
    expect(
      getAverage(student, subject)
    ).toBe("3.3")

    setGrade(student, subject, '5');

    expect(
      getAverage(student, subject)
    ).toBe("3.8")
  });

  it('returns 0.0 for non existing student', () => {
    expect(
      getAverage('Invalid', subject)
    ).toBe('0.0');
  });

  it('return 0.0 for non existing subject', () => {
    expect(
      getAverage(student, 'Invalid')
    ).toBe('0.0');
  });
});