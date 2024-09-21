export type Bool = { type: 'True' | 'False' };
export const True: Bool = { type: 'True' };
export const False: Bool = { type: 'False' };

export const IF =
  <T>(b: Bool) =>
  (m: { True: () => T; False: () => T }) =>
    b.type === 'True' ? m.True() : m.False();
