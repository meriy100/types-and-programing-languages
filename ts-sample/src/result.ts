export type Result<T, E> = { type: 'Ok'; value: T } | { type: 'Err'; error: E };
export const Ok = <T, E>(v: T): Result<T, E> => ({ value: v, type: 'Ok' });
export const Err = <T, E>(e: E): Result<T, E> => ({ error: e, type: 'Err' });
export const resultThen =
  <T, E, U>(f: (v: T) => Result<U, E>) =>
  (result: Result<T, E>): Result<U, E> => {
    if (result.type === 'Ok') {
      return f(result.value);
    } else {
      return result;
    }
  };

export const resultMatch =
  <T, E, U>(match: { Ok: (v: T) => U; Err: (e: E) => U }) =>
  (result: Result<T, E>): U => {
    if (result.type === 'Ok') {
      return match.Ok(result.value);
    } else {
      return match.Err(result.error);
    }
  };
