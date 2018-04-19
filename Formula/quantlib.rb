class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.12.1.tar.gz"
  sha256 "92b92b3db842da20db6fc5eba1e75baecaa62f6b19f1eb1e6568ce7d7df927cc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ac04fab52d000d122553cfd55b98bf122f0116616f0f4c92da40d012f43995d2" => :high_sierra
    sha256 "04b23cd5c06cd4e73a134da2cf192819af9db4f557b0e575e1312e6689c76a52" => :sierra
    sha256 "d053712a8da336933ed3b5e76eb0b65520182843d8c774430946c5bf7a029405" => :el_capitan
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-intraday", "Enable intraday components to dates"

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      args = []
      args << "--enable-intraday" if build.with? "intraday"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            *args

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
