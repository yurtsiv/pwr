import {runApp, runTests, TestDefinition} from './testUtils';

const students = [
  'Jan Kowalski',
  'JOhn Doe',
  'John DOe'
];

const subjects = [
  'Physics',
  'PhYsics'
];

const beforeAll = async () => {
  for (const student of students) {
    await runApp(`del student "${student}"`)
  }

  for (const subject of subjects) {
    await runApp(`del subject "${subject}"`)
  }
};

const tests: TestDefinition[] = [
  /**
   * Basic functionality
   */
  {
    name: 'Can add student',
    command: `add student "${students[0]}"`,
    res: 'OK'
  },
  {
    name: 'Can add subject',
    command: `add subject "${subjects[0]}"`,
    res: 'OK'
  },
  {
    name: 'Can delete student',
    command: `del student "${students[0]}"`,
    res: 'OK'
  },
  {
    name: `Doesn't crash if no students in DB`,
    command: `del student "${students[0]}"`,
    res: 'ERROR'
  },
  {
    name: 'Can delete subject',
    command: `del subject "${subjects[0]}"`,
    res: 'OK'
  },
  {
    name: 'Students count 0',
    command: 'count students',
    res: '0'
  },
  {
    name: 'Students count 1',
    before: async () => runApp(`add student "${students[0]}"`),
    command: 'count students',
    res: '1'
  },
  {
    name: 'Subjects count 0',
    command: 'count subjects',
    res: '0',
  },
  {
    name: 'Subjects count 1',
    before: async () => runApp(`add subject "${subjects[0]}"`),
    command: 'count subjects',
    res: '1',
  },
  {
    name: 'Can set grade',
    command: `set grade "${students[0]}" "${subjects[0]}" 3`,
    res: 'OK'
  },
  {
    name: 'Calculates average',
    before: async () => {
      await runApp(`set grade "${students[0]}" "${subjects[0]}" 4`)
      await runApp(`set grade "${students[0]}" "${subjects[0]}" 3`)
    },
    command: `average "${students[0]}" "${subjects[0]}"`,
    res: '3.3', // 10 / 3
  },
  {
    // big letter in the middle of name
    name: `Can add student with unusual name`,
    command: `add student "${students[1]}"`,
    res: 'OK',
  },
  {
    // big letter in the middle of surname
    name: `Can add student with unusual name`,
    command: `add student "${students[2]}"`,
    res: 'OK',
  },
  {
    // big letter in the middle of name
    name: `Can add subject with unusual name`,
    command: `add subject "${subjects[1]}"`,
    res: 'OK',
  },
  {
    name: 'Stress test (adding 20 grades in parallel)',
    before: async () => {
      for (let i = 0; i < 20; i++) {
        runApp(`set grade "${students[0]}" "${subjects[0]}" 3`);
      }
    },
    command: `average "${students[0]}" "${subjects[0]}"`,
    res: '3.0'
  },

  /**
   * Invalid add
   */
  {
    name: `Should not accept invalid command`,
    command: `random command`,
    res: 'ERROR',
  },
  {
    // aadd
    name: `Should not accept invalid command`,
    command: `aadd student "Jan Kowalski"`,
    res: 'ERROR',
  },
  {
    // addd
    name: `Should not accept invalid command`,
    command: `addd student "Jan Kowalski"`,
    res: 'ERROR',
  },
  {
    // ssubject
    name: `Should not accept invalid command`,
    command: `add ssubject Physics`,
    res: 'ERROR',
  },

  /**
   * Invalid 'add student'
   */
  {
    name: `Can't add existing student`,
    command: `add student "Jan Kowalski"`,
    res: 'ERROR'
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "john "`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "John D"`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "J Doe"`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "JohnDoe"`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "john Doe"`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "John doe"`,
    res: 'ERROR',
  },
  {
    name: `Can't add student with invalid name`,
    command: `add student "john doe"`,
    res: 'ERROR',
  },
  {
    // two spaces
    name: `Can't add student with invalid nam (two spaces)`,
    command: `add student "John  Doe"`,
    res: 'ERROR',
  },
  {
    // zero in name
    name: `Can't add student with invalid name (zero in name)`,
    command: `add student "J0hn Doe"`,
    res: 'ERROR',
  },
  {
    // zero in surname
    name: `Can't add student with invalid name (zero in surname)`,
    command: `add student "John D0e"`,
    res: 'ERROR',
  },

  /**
   * Invalid 'add subject'
   */
  {
    name: `Can't add existing subject`,
    command: `add subject "${subjects[0]}"`,
    res: 'ERROR',
  },
  ...[
    'physics',
    ' Physics',
    'Physics ',
    'Phy sics',
    'Phys1cs',
    'Phy-sics',
    'Phy_sics'
  ].map(invalidName => ({
    name: `Can't add subject with invalid name`,
    command: `add subject "${invalidName}"`,
    res: 'ERROR'
  })),

  /**
   * Invalid set grade
   */
  {
    name: `Can't set grade for non exisitng studnet`,
    command: `add subject "Some Random" "${subjects[0]}"`,
    res: 'ERROR',
  },
  {
    name: `Can't set grade for non exisitng subject`,
    command: `add subject "${students[0]}" "SomeSubject"`,
    res: 'ERROR',
  },
  ...[
    '1',
    '2.2',
    '3.5',
    '3.0',
    '2 ',
    ' 2',
    '6'
  ].map(invalidGrade => ({
    name: `Can't set invalid grade`,
    command: `set grade "${students[0]}" "${subjects[0]}" "${invalidGrade}"`,
    res: 'ERROR'
  })),

  /**
   * Invalid average
   */
  {
    name: `Average for non existing student`,
    command: `average "Some Student" "${subjects[0]}"`,
    res: '0.0'
  },
  {
    name: `Average for non existing subject`,
    command: `average "${students[0]}" "SomeSubject"`,
    res: '0.0'
  }
]

runTests(tests, beforeAll);
