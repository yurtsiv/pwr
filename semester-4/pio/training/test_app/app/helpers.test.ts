import { unlinkSync, existsSync, exists } from "fs";
import { readJSONFile, writeJSONFile } from "./helpers";

const file = 'tempFileForTestingPurposes.json';

beforeAll(() => {
  if (existsSync(file)) {
    unlinkSync(file);
  }
});

afterAll(() => {
  if (existsSync(file)) {
    unlinkSync(file);
  }
});

it('should create a file if it does not extist', () => {
  expect(existsSync(file)).toBe(false);

  const res = readJSONFile(file)();

  expect(res).toEqual([]);
  expect(existsSync(file)).toBe(true);
});

it('should successfully write and read JSON', () => {
  const data = {a: 1, b: 2}
  writeJSONFile(file)(data);

  expect(readJSONFile(file)()).toEqual(data);
});