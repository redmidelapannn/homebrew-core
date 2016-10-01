class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz"
  sha256 "c79d21c5af215105ba16eb69ee75b589bf7d41abce86feaa40757513e33c6ecf"
  revision 2

  bottle do
    cellar :any
    sha256 "bc22fa7c60d738e3b6f262d5852b349458f12c92213a52a2d26bb44f7238f944" => :sierra
    sha256 "30401b70e03772c1c8077da18d07f1844940a02a7b309f0fa77e77db9787e3f4" => :el_capitan
    sha256 "7c2c41b73f54478aae8e35509f32ce641292fbbe93f11bff0fa3bb8c95cf3824" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost@1.61" => "with-icu4c"
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  def install
    icu4c = Formula["icu4c"]
    libtool = Formula["libtool"]
    ENV.append "LDFLAGS", "-L#{libtool.lib}"
    ENV.append "LDFLAGS", "-L#{icu4c.lib}"
    ENV.append "CPPFLAGS", "-I#{libtool.include}"
    ENV.append "CPPFLAGS", "-I#{icu4c.include}"

    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}", "--enable-boost-locale"
    system "make", "install"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<-EOS.undent
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
