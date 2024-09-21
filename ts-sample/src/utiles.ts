export const identity = <T extends any>(x: T) => x;

export const comp =
  <T, U, V>(f: (_: T) => U) =>
  (g: (_: U) => V) =>
  (x: T): V =>
    g(f(x));
