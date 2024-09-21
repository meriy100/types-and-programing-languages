import { relToNumber } from './support';
import {
  RFive,
  RFour,
  RMOne,
  RMThree,
  rMul,
  ROne,
  rPlus,
  rSub,
  RThree,
  RTwo,
  RZero,
} from '../rel';

describe('Rel', () => {
  describe('rPlus', () => {
    it('1 + 2 = 3', () => {
      expect(relToNumber(rPlus(ROne)(RTwo))).toBe(3);
    });

    it('-1 + 2 = 1', () => {
      expect(relToNumber(rPlus(RMOne)(RTwo))).toBe(1);
    });

    it('-1 + 1 = 0', () => {
      expect(relToNumber(rPlus(RMOne)(ROne))).toBe(0);
    });
  });

  describe('rSub', () => {
    it('1 - -3 = 4', () => {
      expect(relToNumber(rSub(ROne)(RMThree))).toBe(4);
    });

    it('1 - 4 = -3', () => {
      expect(relToNumber(rSub(ROne)(RFour))).toBe(-3);
    });

    it('2 - 1 = 1', () => {
      expect(relToNumber(rSub(RTwo)(ROne))).toBe(1);
    });
  });

  describe('rMul', () => {
    it('1 * 2 = 2', () => {
      expect(relToNumber(rMul(ROne)(RTwo))).toBe(2);
    });

    it('2 * 3 = 6', () => {
      expect(relToNumber(rMul(RTwo)(RThree))).toBe(6);
    });

    it('2 * -1 = -2', () => {
      expect(relToNumber(rMul(RTwo)(RMOne))).toBe(-2);
    });

    it('5 * 0 = 0', () => {
      expect(relToNumber(rMul(RFive)(RZero))).toBe(0);
    });
  });
});
