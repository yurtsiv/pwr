import { exec } from "child_process";

const [_node, _script, appPath] = process.argv;
if (!appPath) throw new Error('Application path not specified');

const runApp = (args: string): Promise<string> =>
  new Promise((res, rej) => {
    exec(`${appPath} ${args}`, (error, stdout, stderr) => {
      if (error || stderr) rej(error || stderr);

      res(stdout.trim());
    })
  });

const beforeAll = async () => {
  try {
    await runApp(`del student "Jan Kowalski"`);
  } catch (e) {
    console.error('Error in beforeAll\n', e);
  }

  try {
    await runApp(`del subject Physics`);
  } catch (e) {
    console.error('Error in beforeAll\n', e);
  }
};

interface TestDefinition {
  name: string;
  command: string;
  res: string;
  before?: () => Promise<any>;
}

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

interface TestResult {
  name: string;
  command: string;
  positive: boolean;
  expected?: string;
  received?: string;
}

const runTest = async ({name, command, res: expectedRes, before}: TestDefinition): Promise<TestResult> => {
  try {
    if (before) await before();
  } catch (e) {
    console.error("Error in before\n", e);
    return {
      name,
      command,
      positive: false
    };
  }

  let res;
  try {
    res = await runApp(command);
  } catch (e) {
    console.error(`Error while running "${command}"\n`, e);
    return {
      name,
      command,
      positive: false
    }
  }

  return {
    name,
    command,
    positive: res === expectedRes,
    expected: expectedRes,
    received: res
  }
};

const runTests = async (tests: TestDefinition[]) => {
  await beforeAll();

  for (const test of tests) {
    const {name, positive} = await runTest(test);
    console.log(`${name} :  ${positive}`)
  }
};

runTests(tests);
