import {exec} from 'child_process';
import {Table} from 'console-table-printer';

const [_node, _script, appPath] = process.argv;

if (!appPath) throw new Error('Application path not specified');

export const runApp = (args: string): Promise<string> =>
  new Promise((res, rej) => {
    exec(`${appPath} ${args}`, (error, stdout, stderr) => {
      if (error || stderr) rej(error || stderr);

      res(stdout.trim());
    })
  });

export interface TestDefinition {
  name: string;
  command: string;
  res: string;
  before?: () => Promise<any>;
}

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

const printResults = (testRes: TestResult[]) => {
  const table = new Table({
    columns: [
      {name: 'Test name', alignment: 'left'},
      {name: 'Command', alignment: 'left'},
      {name: 'Positive', alignment: 'left'},
      {name: 'Expected', alignment: 'left'},
      {name: 'Received', alignment: 'left'}
    ]
  });

  testRes.forEach((res) => {
    table.addRow({
      'Test name': res.name,
      'Command': res.command,
      'Positive': res.positive,
      'Expected': res.expected,
      'Received': res.received
    }, {color: res.positive ? 'white' : 'red'})
  });

  table.printTable();
}

export const runTests = async (tests: TestDefinition[], beforeAll: () => Promise<void>) => {
  await beforeAll();

  const results = [];
  for (const test of tests) {
    results.push(await runTest(test));
  }

  printResults(results);
};
