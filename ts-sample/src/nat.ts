import {identity} from "./utiles";
import {Err, Ok, Result, resultThen} from "./result";


export type Nat = { v: Nat, type: 'Nat' } | { type: 'Nat'}
export const nF = <T extends any>(f: (x: T) => T) => (n: Nat): (x: T) => T => {
  if ("v" in n) {
    return (x: T) => f(nF(f)(n.v)(x))
  } else {
    return identity
  }
}
export const nSucc = (n: Nat): Nat => ({v: n, type: 'Nat'})
export const nDecc = (n: Nat): Result<Nat, string> => {
  if ("v" in n) {
    return Ok(n.v)
  } else {
    return Err("Invalid Nat range")
  }
}

export const nPlus = (m: Nat) => (n: Nat): Nat => {
  return nF(nSucc)(n)(m)
}

export const nSub = (m: Nat) => (n: Nat): Result<Nat, string> => {
  return nF(resultThen(nDecc))(n)(Ok(m))
}

export const nMul = (m: Nat) => (n: Nat): Nat => {
  return nF(nPlus(m))(n)(NZero)
}

export const NZero: Nat = {type: "Nat"}
export const NOne = nSucc(NZero)
export const NTwo = nSucc(NOne)
export const NThree = nSucc(NTwo)
export const NFour = nSucc(NThree)
export const NFive = nSucc(NFour)

