class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 2

  bottle do
    rebuild 3
    sha256 "ef7cfbb392acf920d3e7fc20d64ef62b386f2ca032e8b0c6fefeceb7eda9887d" => :mojave
    sha256 "05eee04629867abbc0f84345a5d7562614eeed92297d3136c970af95a65209dd" => :high_sierra
    sha256 "266e946489ff9ba2108445879934addafc276913c1b7aae7dea13899abe7bc42" => :sierra
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
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("#{bin}/elinks test.html")
  end
end
