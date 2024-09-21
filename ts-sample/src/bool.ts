export type Bool = { type: 'True' | 'False' };
export const True: Bool = { type: 'True' };
export const False: Bool = { type: 'False' };

export const Not = (b: Bool): Bool => (b.type === 'True' ? False : True);

export const IF =
  <T>(b: Bool) =>
  (m: { True: () => T; False: () => T }) =>
    b.type === 'True' ? m.True() : m.False();

export const OR =
  (a: Bool) =>
  (b: Bool): Bool =>
    IF<Bool>(a)({
      True: () => True,
      False: () => b,
    });

export const AND =
  (a: Bool) =>
  (b: Bool): Bool =>
    IF<Bool>(a)({
      True: () => b,
      False: () => False,
    });

export const XOR =
  (a: Bool) =>
  (b: Bool): Bool =>
    OR(AND(a)(Not(b)))(AND(Not(a))(b));
