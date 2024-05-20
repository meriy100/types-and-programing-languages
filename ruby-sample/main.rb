# frozen_string_literal: true

# ZERO = ->(s) { -> (z) { z } }
# ONE =  ->(s) { ->(z) { s[z] } }

def is_numeric_val(t)
  case t
  in 'TmZero'
    true
  in 'TmSucc', t1
    is_numeric_val(t1)
  else
    false
  end
end

TyBool = 'Bool'
TyNat = 'Nat'

def typeof(ctx, t)
  case t
  in 'TmTrue', _
    TyBool
  in 'TmFalse', _
    TyBool
  in 'TmIf', _, t1, t2, t3
    raise 'Type Error' unless typeof(ctx, t1) == TyBool && typeof(ctx, t2) == typeof(ctx, t3)

    typeof(ctx, t2)

  in 'TmZero', _
    TyNat
  in 'TmSucc', _, t1
    raise 'Type Error' unless typeof(ctx, t1) == TyNat

    TyNat

  in 'TmPred', _, t1
    raise 'Type Error' unless typeof(ctx, t1) == TyNat

    TyNat

  in 'TmIsZero', _, t1
    raise 'Type Error' unless typeof(ctx, t1) == TyNat

    TyBool

  else
    raise "No Type #{t}"
  end
end

def is_val(t)
  case t
  in 'TmTrue', _
    true
  in 'TmFalse', _
    true
  in 'TmZero', _
    true
  in 'TmSucc', _, t1
    is_numeric_val(t1)
  else
    false
  end
end

def eval1(t)
  case t
  in 'TmIf', _, ['TmTrue', _], t2, t3
    t2
  in 'TmIf', _, ['TmFalse', _], t2, t3
    t3
  in 'TmIf', _, t1, t2, t3
    t1_ = eval1(t1)
    ['TmIf', _, t1_, t2, t3]
  in 'TmSucc', _, t1
    result = eval1(t1)
    ['TmSucc', _, result]
  in 'TmPred', _, ['TmZero', _]
    ['TmZero', _]
  in 'TmPred', _, ['TmSucc', _, nv]
    raise 'No Apply Rule' unless is_numeric_val(nv)

    nv

  in 'TmIsZero', _, ['TmZero', _]
    ['TmTrue', _]
  in 'TmIsZero', _, ['TmSucc', _, nv]
    raise 'No Apply Rule' unless is_numeric_val(nv)

    ['TmFalse', _]

  in 'TmIsZero', _, t1
    t1_ = eval1(t1)
    ['TmIsZero', _, t1_]
  in 'TmSucc', _, t1
    t1_ = eval1(t1)
    ['TmIsZero', _, t1_]
  else
    raise 'No Apply Rule'
  end
end

ZERO = ['TmZero', nil].freeze
ONE = ['TmSucc', nil, ['TmZero', nil]].freeze
IF = ->(b) { ->(t) { ->(f) { ['TmIf', nil, b, t, f] } } }

def main
  source =
    IF[['TmFalse', nil]][
      ZERO
    ][
      ONE
    ]
  p(eval1(source))
  p(typeof([], source))
end

main
