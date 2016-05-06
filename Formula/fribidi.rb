class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://fribidi.org/"
  url "https://fribidi.org/download/fribidi-0.19.7.tar.bz2"
  sha256 "08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e"

  bottle do
    cellar :any
    revision 1
    sha256 "6ca452c2788dd7685b66399c78f4ab13b86cb4539ad7499aeb8446b1054ab57c" => :el_capitan
    sha256 "2439216fc86bf413ea8e35688e8a25e840cbd0ccde9f6dba6d7dcd724db13d21" => :yosemite
    sha256 "6f317f455fc929f1072db0f6630d0ce774d21c3cb312fbb18e7296d2e4461dee" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<-EOS.undent
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
