import { Result } from '../result';
import {
  iAbs,
  iDecc,
  iDiv,
  IFive,
  IFour,
  iIsNegative,
  iIsPositive,
  iIsZero,
  IMFive,
  IMOne,
  IMSix,
  IMThree,
  IMTwo,
  iMul,
  Int,
  IOne,
  iPlus,
  ISix,
  iSub,
  iSucc,
  IThree,
  ITwo,
  IZero,
} from '../int';
import { boolToBoolean, intToNumber, resultToValue } from './support';

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

  describe('iAbs', () => {
    it('abs 0 = 0', () => {
      expect(intToNumber(iAbs(IZero))).toBe(0);
    });

    it('abs 1 = 1', () => {
      expect(intToNumber(iAbs(IOne))).toBe(1);
    });

    it('abs 2 = 2', () => {
      expect(intToNumber(iAbs(ITwo))).toBe(2);
    });

    it('abs -1 = 1', () => {
      expect(intToNumber(iAbs(IMOne))).toBe(1);
    });

    it('abs -2 = 2', () => {
      expect(intToNumber(iAbs(IMTwo))).toBe(2);
    });
  });

  describe('iIsZero', () => {
    it('0 is zero', () => {
      expect(boolToBoolean(iIsZero(IZero))).toBe(true);
    });

    it('1 is not zero', () => {
      expect(boolToBoolean(iIsZero(IOne))).toBe(false);
    });

    it('-1 is not zero', () => {
      expect(boolToBoolean(iIsZero(IMOne))).toBe(false);
    });
  });

  describe('iIsPositive', () => {
    it('0 is not positive', () => {
      expect(boolToBoolean(iIsPositive(IZero))).toBe(false);
    });

    it('1 is positive', () => {
      expect(boolToBoolean(iIsPositive(IOne))).toBe(true);
    });

    it('2 is positive', () => {
      expect(boolToBoolean(iIsPositive(ITwo))).toBe(true);
    });

    it('-2 is not positive', () => {
      expect(boolToBoolean(iIsPositive(IMThree))).toBe(false);
    });
  });

  describe('iIsNegative', () => {
    it('0 is not negative', () => {
      expect(boolToBoolean(iIsNegative(IZero))).toBe(false);
    });

    it('1 is not negative', () => {
      expect(boolToBoolean(iIsNegative(IOne))).toBe(false);
    });

    it('2 is not negative', () => {
      expect(boolToBoolean(iIsNegative(ITwo))).toBe(false);
    });

    it('-2 is negative', () => {
      expect(boolToBoolean(iIsNegative(IMThree))).toBe(true);
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

  describe('iDiv', () => {
    it('4 / 2 = 2', () => {
      expect(intToNumber(resultToValue(iDiv(IFour)(ITwo)))).toBe(2);
    });

    it('5 / 5 = 1', () => {
      expect(intToNumber(resultToValue(iDiv(IFive)(IFive)))).toBe(1);
    });

    it('6 / -2 = -3', () => {
      expect(intToNumber(resultToValue(iDiv(ISix)(IMTwo)))).toBe(-3);
    });

    it('-6 / 3 = -2', () => {
      expect(intToNumber(resultToValue(iDiv(IMSix)(IThree)))).toBe(-2);
    });

    it('-6 / -3 = 2', () => {
      expect(intToNumber(resultToValue(iDiv(IMSix)(IMThree)))).toBe(2);
    });

    it('5 / 2 = Error', () => {
      expect(() => intToNumber(resultToValue(iDiv(IFive)(ITwo)))).toThrow(
        'Invalid Int range',
      );
    });

    it('5 / -3 = Error', () => {
      expect(() => intToNumber(resultToValue(iDiv(IFive)(IMThree)))).toThrow(
        'Invalid Int range',
      );
    });

    it('5 / 0 = Error', () => {
      expect(() => intToNumber(resultToValue(iDiv(IFive)(IZero)))).toThrow(
        'Division by zero is not allowed',
      );
    });
  });
});
