import { runApp } from "./app"
import { writeSubjects, writeStudents } from "./dataUtils"

beforeAll(() => {
  writeStudents([]);
  writeSubjects([]);
});

afterAll(() => {
  writeStudents([]);
  writeSubjects([]);
});

describe('runApp', () => {
  it('accepts valid commands', () => {
    const validCommands = [
      ['add', 'student', 'Jan Kowalski'],
      ['add', 'subject', 'Physics'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '2'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '3'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '4'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '5'],
      ['average', 'Jan Kowalski', 'Physics'],
      ['del', 'student', 'Jan Kowalski'],
      ['del', 'subject', 'Physics'],
      ['count', 'students'],
      ['count', 'subjects'],
    ];

    validCommands.forEach(command => {
      expect(runApp(command)).not.toBe('ERROR');
    });
  });

  it('does not accept invalid commands', () => {
    const invalidCommands = [
      ['invalid', 'command'],
      ['add'],
      ['add', 'student'],
      ['add', 'student', 'Jan'],
      ['add', 'student', 'jan Kowalski'],
      ['add', 'student', 'Jan kowalski'],
      ['add', 'student', 'Jan Kowalski '],
      ['add', 'student', 'Jan  Kowalski'],
      ['add', 'student', 'J@n Kowalski'],
      ['add', 'subject'],
      ['add', 'subject', 'physics'],
      ['add', 'subject', 'Physics '],
      ['add', 'subject', ' Physics '],
      ['add', 'subject', 'Phys1cs'],
      ['set'],
      ['set', 'grade'],
      ['set', 'grade', 'Jan'],
      ['set', 'grade', 'Jan Kowalski'],
      ['set', 'grade', 'Jan Kowalski', 'Physics'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '4 '],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '1'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '2.2'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '2.0'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '3.5'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '6'],
      ['set', 'grade', 'Jan Kowalski', 'Physics', '-2'],
      ['average'],
      ['average', 'Jan'],
      ['average', 'Jan Kowalski'],
      ['del'],
      ['del', 'student'],
      ['del', 'student', 'Jan'],
      ['del', 'subject'],
      ['count'],
    ]

    invalidCommands.forEach(command => {
      expect(runApp(command)).toBe('ERROR');
    });
  });

  it('does not crash on unsuccessful operation', () => {
    const command = ['add', 'student', 'Jan Kowalski'];

    runApp(command);

    expect(runApp(command)).toBe('ERROR');
  });

  it('handles empty args', () => {
    expect(runApp([])).toBe('ERROR');
  });
});