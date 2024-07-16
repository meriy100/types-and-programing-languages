class Main
  Pending = :Pending
  Active = :Active
  Inactive = :Inactive
  Error = -> (message) { [:Error, message] }

  def call
    f = -> (x) { -> (y) { x } }
    g = -> (x) { -> (y) { -> (z) { x } } }


    statusToText = -> (status) {
      case status
      in :Pending
        "Pending"
      in :Active
        "Active"
      in :Inactive
        "Inactive"
      in :Error, message
        "Error : " + message
      end
    }
    [
      f.(1).(2),
      statusToText.(Error.("error message")),
    ]
  end
end

if __FILE__ == $0
  puts Main.new.call
end
