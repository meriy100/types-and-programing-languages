import {
  Nat,
  NFive,
  nMul,
  NOne,
  nPlus,
  nSub,
  nSucc,
  NThree,
  NTwo,
  NZero,
} from '../nat';
import { Result } from '../result';

const natToNumber = (n: Nat): number => ('v' in n ? 1 + natToNumber(n.v) : 0);

const resultToValue = <T, E>(result: Result<T, E>) => {
  if (result.type === 'Ok') return result.value;
  throw result.error;
};

// 自然数

describe('Nat', () => {
  describe('const', () => {
    it('0 = 0', () => {
      expect(natToNumber(NZero)).toBe(0);
    });

    it('1 = 1', () => {
      expect(natToNumber(NOne)).toBe(1);
    });
  });

  describe('nSucc', () => {
    it('succ 1 = 2', () => {
      expect(natToNumber(nSucc(NOne))).toBe(2);
    });
  });

  describe('nPlus', () => {
    it('2 + 3 = 5', () => {
      expect(natToNumber(nPlus(NTwo)(NThree))).toBe(5);
    });
  });

  describe('nSub', () => {
    it('3 -  2 = 1', () => {
      expect(natToNumber(resultToValue(nSub(NThree)(NTwo)))).toBe(1);
    });

    it('2 - 2 = 0', () => {
      expect(natToNumber(resultToValue(nSub(NTwo)(NTwo)))).toBe(0);
    });
  });

  describe('nMul', () => {
    it('2 * 2 = 4', () => {
      expect(natToNumber(nMul(NTwo)(NTwo))).toBe(4);
    });

    it('5 * 3 = 15', () => {
      expect(natToNumber(nMul(NFive)(NThree))).toBe(15);
    });
  });
});
