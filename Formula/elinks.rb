class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 2

  bottle do
    rebuild 3
    sha256 "7c099838d11a7d665ad1c3ba3d42d32578f2ffb1d887b987de559fe6f2312501" => :el_capitan
    sha256 "f79cf9f65d250c981a33853575b9ee882856d09060e64c328215ba61da20dc0e" => :yosemite
    sha256 "fee696ef0ea70a68d8904c1738db28a624f8460a72d27503e297c70db4fbcb25" => :mavericks
  end

  devel do
    url "http://elinks.or.cz/download/elinks-current-0.13.tar.bz2"
    version "0.13-current"
    sha256 "2055f85440c4896ae036c05739ef2201689ab0cb3b461a687178af125c76506a"
  end

  head do
    url "http://elinks.cz/elinks.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    ENV.delete("LD")
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey",
                          "--enable-256-colors"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<-EOS.undent
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("elinks test.html")
  end
end
