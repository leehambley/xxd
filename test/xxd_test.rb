require "test_helper"

class XxdTest < Minitest::Test

  def gnu_xxd_output_for_fixture
    '00000000: 2159 a651 f852 132c 5f83 1259 9acd d837  !Y.Q.R.,_..Y...7' + "\n" \
    '00000010: 0340 44d2 e08f 6979 46ee 40dc d6a0 bfa3  .@D...iyF.@.....' + "\n" \
    '00000020: 0c63 a246 1eae 5ddd 9a59 9fa2 f14d d57c  .c.F..]..Y...M.|' + "\n" \
    '00000030: f13f 8aa5 b7dd 7384 c620 133f f43c 190f  .?....s.. .?.<..' + "\n" \
    '00000040: a89a 3f85 f958 be10 f8dd d7b5 a5d6 907f  ..?..X..........' + "\n" \
    '00000050: 78ee 3b93 8fb5 5c51 51ed eb71 e23c 7c75  x.;...\QQ..q.<|u' + "\n" \
    '00000060: bde0 2e05                                ....            ' + "\n" \
  end

  def fixture
    File.binread(File.join(File.dirname(__FILE__), "random-data-from-urandom"))
  end

  def test_that_it_has_a_version_number
    refute_nil ::Xxd::VERSION
  end

  def test_it_matches_the_naïve_output_of_gnu_xxd
    assert Xxd.dump(fixture) == gnu_xxd_output_for_fixture
  end

  def test_it_can_parse_its_own_output_as_input_losslessly
    assert Xxd.parse(Xxd.dump(fixture)) == fixture
  end

end