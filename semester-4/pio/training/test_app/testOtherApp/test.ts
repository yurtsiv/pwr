import {runApp, runTests, TestDefinition} from './testUtils';

const beforeAll = async () => {
  try {
    await runApp(`del student "Jan Kowalski"`);
  } catch (e) {}

  try {
    await runApp(`del subject Physics`);
  } catch (e) {}
};

const tests: TestDefinition[] = [
  {
    name: 'Can add student',
    command: `add student "Jan Kowalski"`,
    res: 'OK'
  },
  {
    name: 'Can add subject',
    command: `add subject Physics`,
    res: 'OK'
  },
  {
    name: 'Can delete student',
    command: `del student "Jan Kowalski"`,
    res: 'OK'
  },
  {
    name: 'Can delete subject',
    command: 'del subject Physics',
    res: 'OK'
  },
  {
    name: 'Students count 0',
    command: 'count students',
    res: '0'
  },
  {
    name: 'Students count 1',
    before: async () => runApp(`add student "Jan Kowalski"`),
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
    before: async () => runApp('add subject Physics'),
    command: 'count subjects',
    res: '1',
  },
  {
    name: 'Can set grade',
    command: `set grade "Jan Kowalski" Physics 3`,
    res: 'OK'
  }
]

runTests(tests, beforeAll);
