export type Pair<L, R> = { l: L; r: R; type: 'Pair' };
export const pair =
  <L, R>(l: L) =>
  (r: R): Pair<L, R> => ({ l, r, type: 'Pair' });
export const left = <L, R>(p: Pair<L, R>): L => p.l;
export const right = <L, R>(p: Pair<L, R>): R => p.r;
