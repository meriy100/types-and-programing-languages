import {
  nDiv,
  NFive,
  NFour,
  nMul,
  NOne,
  nPlus,
  NSix,
  nSub,
  nSucc,
  NThree,
  NTwo,
  NZero,
} from '../nat';
import { natToNumber, resultToValue } from './support';

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

  describe('nDiv', () => {
    it('6 / 3 = 2', () => {
      expect(natToNumber(resultToValue(nDiv(NSix)(NThree)))).toBe(2);
    });

    it('5 / 5 = 1', () => {
      expect(natToNumber(resultToValue(nDiv(NFive)(NFive)))).toBe(1);
    });

    it('5 / 0 = Error', () => {
      expect(() => resultToValue(nDiv(NFive)(NZero))).toThrow(
        'Division by zero is not allowed',
      );
    });

    it('3 / 4 = Error', () => {
      expect(() => resultToValue(nDiv(NThree)(NFour))).toThrow(
        'Invalid Nat range',
      );
    });

    it('5 / 3 = Error', () => {
      expect(() => resultToValue(nDiv(NFive)(NThree))).toThrow(
        'Invalid Nat range',
      );
    });
  });
});
