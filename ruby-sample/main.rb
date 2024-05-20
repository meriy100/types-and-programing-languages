# ZERO = ->(s) { -> (z) { z } }
# ONE =  ->(s) { ->(z) { s[z] } }


def is_numeric_val(t)
  case t
  in "TmZero"
    true
  in "TmSucc", t1
    is_numeric_val(t1)
  else
    false
  end
end

TyBool = "Bool"
TyNat = "Nat"

def typeof(ctx, t)
  case t
  in "TmTrue"
    TyBool
  in "TmFalse"
    TyBool
  in "TmIf", t1, t2, t3
    if typeof(ctx, t1) == TyBool && typeof(ctx, t2) == typeof(ctx, t3)
      typeof(ctx, t2)
    else
      raise "Type Error"
    end
  in "TmZero"
    TyNat
  in "TmSucc", t1
    if typeof(ctx, t1) == TyNat
      TyNat
    else
      raise "Type Error"
    end
  in "TmPred", t1
    if typeof(ctx, t1) == TyNat
      TyNat
    else
      raise "Type Error"
    end
  in "TmIsZero", t1
    if typeof(ctx, t1) == TyNat
      TyBool
    else
      raise "Type Error"
    end
  else
    raise "No Type"
  end
end

def is_val(t)
  case t
  in "TmTrue"
    true
  in "TmFalse"
    true
  in "TmZero"
    true
  in "TmSucc", t1
    is_numeric_val(t1)
  else
    false
  end
end

def eval1(t)
  case t
  in "TmIf", ["TmTrue"], t2, t3
    t2
  in "TmIf", ["TmFalse"], t2, t3
    t3
  in "TmIf", t1, t2, t3
    t1_ = eval1(t1)
    ["TmIf", t1_, t2, t3]
  in "TmSucc", t1
    result = eval1(t1)
    ["TmSucc", result]
  in "TmPred", ["TmZero"]
    ["TmZero"]
  in "TmPred", ["TmSucc", nv]
    if is_numeric_val(nv)
      nv
    else
      raise "No Apply Rule"
    end
  in "TmIsZero", ["TmZero"]
    ["TmTrue"]
  in "TmIsZero", ["TmSucc", nv]
    if is_numeric_val(nv)
      ["TmFalse"]
    else
      raise "No Apply Rule"
    end
  in "TmIsZero", t1
    t1_ = eval1(t1)
    ["TmIsZero", t1_]
  in "TmSucc", t1
    t1_ = eval1(t1)
    ["TmIsZero", t1_]
  else
    raise "No Apply Rule"
  end
end

ZERO = ["TmZero"]
ONE = ["TmSucc", ["TmZero"]]
IF = -> (b) { -> (t) { ->(f) { ["TmIf", b, t, f] } } }


def main
  source =
    IF[["TmFalse"]][
      ZERO
    ][
      ONE
    ]
  p(eval1(source))
  p(typeof([], source))
end

main
