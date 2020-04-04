class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.18.tar.gz"
  sha256 "d5048e14f2b7ea79f0adee08b2cbcee01b57b9cc282f60225ff4fcfc614c7ebc"

  bottle do
    cellar :any
    sha256 "11a8094d040b06b9b6d2f92a3bed18fd341168f4561c65c0feffd72b8e21bbfe" => :catalina
    sha256 "35dde16f5c2c5e5c12ddc3b2fefe64fc521db1dd11f3ed719aa900b324d95915" => :mojave
    sha256 "af7ce81061b5aafdd557bbbe9635135ea6325c4e72b072709e0d4b7013269d82" => :high_sierra
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
