class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.13.tar.gz"
  sha256 "bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "90df4f03dbde169ac9a4878e6203db89be3a4bdb07e8a14de29fe9ee6eb02401" => :high_sierra
    sha256 "9b14d41f5baf2eb0433b34b0675fe9e88ff505e29e3d18bf540c94f3e8e089c2" => :sierra
    sha256 "690b23b79442c7756a2ad6e751288f779370be1054e879c3b88f12814ddcfcc9" => :el_capitan
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
