class Gauche < Formula
  desc "R5RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.4.tgz"
  sha256 "7b18bcd70beaced1e004594be46c8cff95795318f6f5830dd2a8a700410fc149"

  bottle do
    revision 2
    sha256 "f4d13975cdb0872d43ada65a9175debc671521c5eec19d054bc6d9a7a6367058" => :el_capitan
    sha256 "00cc62a452ebbe50572cf686b9b653ccebfbdc90021f03a95bb75b7c3219cea4" => :yosemite
    sha256 "281460f741c2994387a93ef56830663d456b338ef69b1af4a79757d0bc39e038" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("gosh -V")
    assert_match /Gauche scheme shell, version #{version}/, output
  end
end
