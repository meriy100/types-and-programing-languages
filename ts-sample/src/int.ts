import { Nat, nF, nMul, nPlus, nSucc, NZero } from './nat';

export type Int = { x: Nat; y: Nat; type: 'Int' };
export const iSucc = (n: Int): Int => ({ x: nSucc(n.x), y: n.y, type: 'Int' });
export const iDecc = (n: Int): Int => ({ x: n.x, y: nSucc(n.y), type: 'Int' });
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

export const IZero: Int = { x: NZero, y: NZero, type: 'Int' };
export const IOne = iSucc(IZero);
export const ITwo = iSucc(IOne);
export const IThree = iSucc(ITwo);
export const IFour = iSucc(IThree);
export const IFive = iSucc(IFour);
export const IMOne: Int = iDecc(IZero);
export const IMTwo: Int = iDecc(IMOne);
export const IMThree: Int = iDecc(IMTwo);
export const IMFor: Int = iDecc(IMThree);
export const IMFive: Int = iDecc(IMFor);
