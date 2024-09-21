import {
  Nat,
  nDecc,
  nEq,
  nIsZero,
  nMul,
  nPlus,
  nSub,
  nSucc,
  NZero,
} from './nat';
import {
  Err,
  Ok,
  Result,
  resultMap,
  resultThen,
  resultWithDefault,
} from './result';
import { AND, Bool, False, IF, Not, OR, True, XOR } from './bool';
import { comp } from './utiles';

export type Int = { x: Nat; y: Nat; type: 'Int' };
export const iSucc = (n: Int): Int => ({ x: nSucc(n.x), y: n.y, type: 'Int' });
export const iDecc = (n: Int): Int => ({ x: n.x, y: nSucc(n.y), type: 'Int' });
export const iIsZero = (n: Int): Bool => nEq(n.x)(n.y);

export const iAbs = (n: Int): Int =>
  IF<Int>(iIsPositive(n))({
    True: () => n,
    False: () => iMul(n)(IMOne),
  });

export const iNormalize = (n: Int): Int =>
  resultWithDefault(n)(
    resultThen<Nat, string, Int>((y: Nat) =>
      resultThen<Nat, string, Int>((x: Nat) =>
        Ok(iNormalize({ x, y, type: 'Int' })),
      )(nDecc(n.x)),
    )(nDecc(n.y)),
  );

export const iEq =
  (m: Int) =>
  (n: Int): Bool =>
    iIsZero(iSub(m)(n));

export const iIsPositive = (i: Int): Bool =>
  AND(Not(iIsZero(i)))(nIsZero(iNormalize(i).y));

export const iIsNegative = (i: Int): Bool =>
  AND(Not(iIsZero(i)))(nIsZero(iNormalize(i).x));

export const iGt =
  (m: Int) =>
  (n: Int): Bool =>
    iIsPositive(iSub(m)(n));

export const iGtEq =
  (m: Int) =>
  (n: Int): Bool =>
    OR(iGt(m)(n))(iEq(m)(n));

export const iPlus =
  (m: Int) =>
  (n: Int): Int => ({
    x: nPlus(m.x)(n.x),
    y: nPlus(m.y)(n.y),
    type: 'Int',
  });

export const iSub =
  (m: Int) =>
  (n: Int): Int => ({
    x: nPlus(m.x)(n.y),
    y: nPlus(m.y)(n.x),
    type: 'Int',
  });

export const iMul =
  (m: Int) =>
  (n: Int): Int => ({
    x: nPlus(nMul(n.x)(m.x))(nMul(n.y)(m.y)),
    y: nPlus(nMul(n.x)(m.y))(nMul(n.y)(m.x)),
    type: 'Int',
  });

export const iDiv =
  (m: Int) =>
  (n: Int): Result<Int, string> => {
    const absM = iAbs(m);
    const absN = iAbs(n);
    const innerDiv =
      (l: Int) =>
      (acc: Int): Result<Int, string> =>
        IF<Result<Int, string>>(iIsZero(l))({
          True: () => Ok(acc),
          False: () =>
            IF<Result<Int, string>>(iIsPositive(l))({
              True: () => innerDiv(iSub(l)(absN))(iSucc(acc)),
              False: () => Err('Invalid Int range'),
            }),
        });

    return IF<Result<Int, string>>(iIsZero(n))({
      True: () => Err('Division by zero is not allowed'),
      False: () =>
        IF<Result<Int, string>>(XOR(iIsNegative(m))(iIsNegative(n)))({
          True: () =>
            resultMap<Int, string, Int>(iMul(IMOne))(innerDiv(absM)(IZero)),
          False: () => innerDiv(absM)(IZero),
        }),
    });
  };

export const IZero: Int = { x: NZero, y: NZero, type: 'Int' };
export const IOne = iSucc(IZero);
export const ITwo = iSucc(IOne);
export const IThree = iSucc(ITwo);
export const IFour = iSucc(IThree);
export const IFive = iSucc(IFour);
export const ISix = iSucc(IFive);
export const IMOne: Int = iDecc(IZero);
export const IMTwo: Int = iDecc(IMOne);
export const IMThree: Int = iDecc(IMTwo);
export const IMFor: Int = iDecc(IMThree);
export const IMFive: Int = iDecc(IMFor);
export const IMSix: Int = iDecc(IMFive);
