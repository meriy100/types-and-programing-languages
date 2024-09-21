import {
  IFive,
  IFour,
  IMOne,
  IMThree,
  IMTwo,
  iMul,
  Int,
  IOne,
  iPlus,
  iSub,
  IThree,
  ITwo,
  IZero,
} from './int';
export type Rel = { type: 'Rel'; t: Int; b: Int };

export const rPlus =
  (m: Rel) =>
  (n: Rel): Rel => ({
    type: 'Rel',
    t: iPlus(iMul(m.t)(n.b))(iMul(n.t)(m.b)),
    b: iMul(m.b)(n.b),
  });

export const rSub =
  (m: Rel) =>
  (n: Rel): Rel => ({
    type: 'Rel',
    t: iSub(iMul(m.t)(n.b))(iMul(n.t)(m.b)),
    b: iMul(m.b)(n.b),
  });

export const rMul =
  (m: Rel) =>
  (n: Rel): Rel => ({
    type: 'Rel',
    t: iMul(m.t)(n.t),
    b: iMul(m.b)(n.b),
  });

export const rFromInt = (n: Int): Rel => ({ type: 'Rel', t: n, b: IOne });
export const RZero = rFromInt(IZero);
export const ROne = rFromInt(IOne);
export const RTwo = rFromInt(ITwo);
export const RThree = rFromInt(IThree);
export const RFour = rFromInt(IFour);
export const RFive = rFromInt(IFive);
export const RMOne = rFromInt(IMOne);
export const RMTwo = rFromInt(IMTwo);
export const RMThree = rFromInt(IMThree);
