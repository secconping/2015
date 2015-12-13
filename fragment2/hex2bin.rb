def to_8bit_str(str)
  "0" * (8 - str.length) + str
end

result = []

open("haffman.txt"){|f| f.read}.split(' ').each{|hex|
  result << to_8bit_str(hex.to_i(16).to_s(2))
}

print result.join()
