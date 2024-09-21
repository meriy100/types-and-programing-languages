import { Result } from '../result';
import {
  iDecc,
  IFive,
  IMFive,
  IMOne,
  IMThree,
  IMTwo,
  iMul,
  Int,
  IOne,
  iPlus,
  iSub,
  iSucc,
  IThree,
  ITwo,
  IZero,
} from '../int';
import { intToNumber } from './support';

describe('Int', () => {
  describe('const', () => {
    it('0 = 0', () => {
      expect(intToNumber(IZero)).toBe(0);
    });

    it('1 = 1', () => {
      expect(intToNumber(IOne)).toBe(1);
    });

    it('-1 = -1', () => {
      expect(intToNumber(IMOne)).toBe(-1);
    });
  });

  describe('iSucc', () => {
    it('succ 1 = 2', () => {
      expect(intToNumber(iSucc(IOne))).toBe(2);
    });

    it('succ -1 = 2', () => {
      expect(intToNumber(iSucc(IMOne))).toBe(0);
    });

    it('succ -2 = -1', () => {
      expect(intToNumber(iSucc(IMTwo))).toBe(-1);
    });
  });

  describe('iDecc', () => {
    it('decc 1 = 0', () => {
      expect(intToNumber(iDecc(IOne))).toBe(0);
    });

    it('decc -1 = -2', () => {
      expect(intToNumber(iDecc(IMOne))).toBe(-2);
    });

    it('decc -2 = -3', () => {
      expect(intToNumber(iDecc(IMTwo))).toBe(-3);
    });
  });

  describe('iPlus', () => {
    it('1 + 2 = 3', () => {
      expect(intToNumber(iPlus(IOne)(ITwo))).toBe(3);
    });

    it('1 + -1 = 0', () => {
      expect(intToNumber(iPlus(IOne)(IMOne))).toBe(0);
    });

    it('-1 + 1 = 0', () => {
      expect(intToNumber(iPlus(IMOne)(IOne))).toBe(0);
    });

    it('-2 + 5 = 3', () => {
      expect(intToNumber(iPlus(IMTwo)(IFive))).toBe(3);
    });
  });

  describe('iSub', () => {
    it('1 - 2 = -1', () => {
      expect(intToNumber(iSub(IOne)(ITwo))).toBe(-1);
    });

    it('1 - -1 = 2', () => {
      expect(intToNumber(iSub(IOne)(IMOne))).toBe(2);
    });

    it('-1 - 1 = -2', () => {
      expect(intToNumber(iSub(IMOne)(IOne))).toBe(-2);
    });

    it('-2 - 5 = -7', () => {
      expect(intToNumber(iSub(IMTwo)(IFive))).toBe(-7);
    });
  });

  describe('iMul', () => {
    it('2 * 2 = 4', () => {
      expect(intToNumber(iMul(ITwo)(ITwo))).toBe(4);
    });

    it('5 * 3 = 15', () => {
      expect(intToNumber(iMul(IFive)(IThree))).toBe(15);
    });

    it('5 * -3 = -15', () => {
      expect(intToNumber(iMul(IFive)(IMThree))).toBe(-15);
    });

    it('-5 * 3 = -15', () => {
      expect(intToNumber(iMul(IMFive)(IThree))).toBe(-15);
    });

    it('-5 * -3 = 15', () => {
      expect(intToNumber(iMul(IMFive)(IMThree))).toBe(15);
    });
  });
});
