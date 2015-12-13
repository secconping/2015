def to9bit_str(code)
  str = code.to_s(2)
  "0" * (9 - str.length) + str
end

utf32 = []

buffer = ""
open('nonet.txt'){|f| f.read }.lines{|nonet|
  nonet.strip!

  binstr = to9bit_str(nonet.to_i(8))

  if binstr.match(/^0/)
    # この文字をつなげて終わり
    utf32 << (buffer + binstr[1, 8]).to_i(2)
    buffer = ""
  else
    # 次の文字を結合する
    buffer << binstr[1, 8]
  end
}

print utf32.pack("U*")
