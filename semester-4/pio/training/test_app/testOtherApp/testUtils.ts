import { exec } from "child_process";

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

export const runTests = async (tests: TestDefinition[], beforeAll: () => Promise<void>) => {
  await beforeAll();

  for (const test of tests) {
    const testRes = await runTest(test);
    if (!testRes.positive) {
      console.error(testRes);
    }
  }
};
