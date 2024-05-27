require 'strscan'

class Lexer
  def initialize(source)
    @scanner = StringScanner.new(source)
  end

  def tokens
    tokens = []

    until @scanner.eos?
      @scanner.skip(/\s+/)

      if @scanner.scan(/"/)
        if @scanner.scan(/[^"]*/)
          tokens << [:STRING_LITERAL, @scanner[0]]
          @scanner.scan(/"/)
        end
      elsif @scanner.scan(/[=+<>]|==|<=|>=/)
        tokens << [:OPERATOR, @scanner[0]]
      elsif @scanner.scan(/case|of|\||type|if|then|else|let|in/)
        tokens << [:KEYWORD, @scanner[0]]
      elsif @scanner.scan(/->/)
        tokens << [:ARROW, @scanner[0]]
      elsif @scanner.scan(/\d+/)
        tokens << [:NUMBER, @scanner[0].to_i]
      elsif @scanner.scan(/[a-zA-Z_]\w*/)
        tokens << [:IDENTIFIER, @scanner[0]]
      elsif @scanner.scan(/:/)
        tokens << [:COLON, @scanner[0]]
      elsif @scanner.scan(/[{},\"]/)
        tokens << [:BRACE, @scanner[0]]
      elsif @scanner.scan(/[^\s\w\d=+><{}:,\"\|]/)
        tokens << [:UNKNOWN, @scanner[0]]
      end
    end

    tokens
  end
end

source=<<EOS
f : Int -> Int -> Int
f x y = x

g : String
  -> Int
  -> Int
g x y z = x

type User = { name : String }
type Status = 
  Pending
  | Active
  | Inactive
  | Error String
  
statusToText status = 
  case status of
    Pending -> "Pending"
    Active -> "Active"
    Inactive -> "Inactive"
    Error message -> "Error : " + message

bar = 
  if 1 == 2
  then 1
  else 2
foo =
  if 1 >= 2 
  then 1
  else 2
foo2 =
  if 1 <= 2 
  then 1
  else 2
foo3 =
  if 1 > 2 
  then 1
  else 2
foo4 =
  if 1 < 2 
  then 1
  else 2

foo = 
  let 
    x =  
      case 1 of
        1 -> 1
        2 -> 2
    y = 2
  in
    x + y

main : Int 
main = 
  f 1 2
EOS

lexer = Lexer.new(source)
puts lexer.tokens
