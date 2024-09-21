import { Nat } from '../nat';
import { Result } from '../result';
import { Int } from '../int';
import { Rel } from '../rel';

export const natToNumber = (n: Nat): number =>
  'v' in n ? 1 + natToNumber(n.v) : 0;

export const resultToValue = <T, E>(result: Result<T, E>) => {
  if (result.type === 'Ok') return result.value;
  throw result.error;
};

export const intToNumber = (n: Int): number =>
  natToNumber(n.x) - natToNumber(n.y);

export const relToNumber = (r: Rel): number =>
  intToNumber(r.t) / intToNumber(r.b);
