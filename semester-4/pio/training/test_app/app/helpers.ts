import {readFileSync, writeFileSync, existsSync, writeFile} from 'fs';

export const nameReg = new RegExp('[A-Z][a-zA-Z]+');

export const readJSONFile = fileName => () => {
  if (!existsSync(fileName)) {
    writeFileSync(fileName, JSON.stringify([]));

    return [];
  }

  try {
    return JSON.parse(readFileSync(fileName, 'utf-8'));
  } catch (e) {
    return [];
  }
}

export const writeJSONFile = fileName => data =>
  writeFileSync(fileName, JSON.stringify(data));