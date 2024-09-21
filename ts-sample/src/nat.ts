import { comp, identity } from './utiles';
import {
  Err,
  Ok,
  Result,
  resultMatch,
  resultThen,
  resultWithDefault,
} from './result';
import { Pair, pair } from './pair';
import { Bool, False, IF, Not, OR, True } from './bool';

export type Nat = { v: Nat; type: 'Nat' } | { type: 'Nat' };
export const nF =
  <T extends any>(f: (x: T) => T) =>
  (n: Nat): ((x: T) => T) => {
    if ('v' in n) {
      return (x: T) => f(nF(f)(n.v)(x));
    } else {
      return identity;
    }
  };
export const nSucc = (n: Nat): Nat => ({ v: n, type: 'Nat' });
export const nDecc = (n: Nat): Result<Nat, string> => {
  if ('v' in n) {
    return Ok(n.v);
  } else {
    return Err('Invalid Nat range');
  }
};

export const nIsZero = (n: Nat): Bool => ('v' in n ? False : True);

export const nGt =
  (m: Nat) =>
  (n: Nat): Bool =>
    resultWithDefault(False)(
      resultThen<Nat, string, Bool>(
        comp<Nat, Bool, Result<Bool, string>>(
          comp<Nat, Bool, Bool>(nIsZero)(Not),
        )(Ok),
      )(nSub(m)(n)),
    );

export const nEq =
  (n: Nat) =>
  (m: Nat): Bool =>
    resultWithDefault(False)(
      resultThen<Nat, string, Bool>(
        comp<Nat, Bool, Result<Bool, string>>(nIsZero)(Ok),
      )(nSub(m)(n)),
    );

export const nPlus =
  (m: Nat) =>
  (n: Nat): Nat =>
    nF(nSucc)(n)(m);

export const nSub =
  (m: Nat) =>
  (n: Nat): Result<Nat, string> =>
    nF(resultThen(nDecc))(n)(Ok(m));

export const nMul =
  (m: Nat) =>
  (n: Nat): Nat =>
    nF(nPlus(m))(n)(NZero);

export const nDiv =
  (m: Nat) =>
  (n: Nat): Result<Nat, string> => {
    const innerDiv =
      (l: Nat) =>
      (acc: Nat): Result<Nat, string> => {
        return resultThen((v: Nat) =>
          IF<Result<Nat, string>>(nIsZero(v))({
            True: () => Ok(acc),
            False: () => innerDiv(v)(nSucc(acc)),
          }),
        )(nSub(l)(n));
      };

    if ('v' in n) {
      return innerDiv(m)(NOne);
    } else {
      return Err('Division by zero is not allowed');
    }
  };

export const NZero: Nat = { type: 'Nat' };
export const NOne = nSucc(NZero);
export const NTwo = nSucc(NOne);
export const NThree = nSucc(NTwo);
export const NFour = nSucc(NThree);
export const NFive = nSucc(NFour);
export const NSix = nSucc(NFive);
