file = "no-network.txt"

eight_base_string = ARGV[0] || open(file){|f| f.read}

octstr = ""
eight_base_string.lines{|l|
  l.strip!
  l.each_char{|c|
    octstr << c
    if octstr.length == 3
      puts octstr
      octstr = ""
    end
  }
}
