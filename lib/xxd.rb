require "xxd/version"

module Xxd
  class Error < StandardError; end

  def dump(input)
    io = StringIO.new
    res = input.bytes.each_slice(2).each_slice(8).each_with_index do |row, i|
      io.write format(
        "%07x0: %-40s %-16s\n",
        i,
        row.map { |pair| pair.map { |b| b.to_s(16).rjust(2, "0") }.join }.join(" "),
        row.flat_map { |pair| pair.map { |b| (b >= 32 && b < 127 ? b.chr : ".") } }.flatten.join
      )
    end
    io.string
  end
  module_function :dump

  def parse(input)
    res = input.lines.flat_map do |line|
      line[10..48].gsub(" ", "").scan(/../).map { |hb| hb.to_i(16) }
    end.pack("c*")
  end
  module_function :parse

end
