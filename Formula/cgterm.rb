class Cgterm < Formula
  desc "Color graphics telnet client for connecting to Commodore 64 BBSes"
  homepage "https://paradroid.automac.se/cgterm/"
  url "https://paradroid.automac.se/cgterm/cgterm-1.6.tar.gz"
  sha256 "21b17a1f5178517c935b996d6f492dba9fca6a88bb7964f85cce8913f379a2a1"

  bottle do
    sha256 "3e5c2b0fb240e2c8f39b03bf50e442632b0edf05a268afb21857cb8ccfaeb978" => :sierra
    sha256 "57f50c543c85ca4763668e160dfc263fa689ae340fdf5e2baebcad8e459ed550" => :el_capitan
    sha256 "5fbe30549f78c7b67c518d8c77f5b7371d1d68ccd0e1ca26cc2aeeda354e78ee" => :yosemite
  end

  depends_on "sdl"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Note that '-h' option is broken and returns 1 but should print usage
    assert_match "cgterm [-4|-8] [-d delay] [-f] [-k keyboard.kbd] [-o logfile] [-r seconds]",
      shell_output("#{bin}/cgterm -h 2>&1", 1)
  end
end
