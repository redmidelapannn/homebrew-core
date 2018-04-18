class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.12.1.tar.gz"
  sha256 "92b92b3db842da20db6fc5eba1e75baecaa62f6b19f1eb1e6568ce7d7df927cc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "89cd03d61176a74fce780d29660bc4940b9ed8f370247003227ab9430957b05d" => :high_sierra
    sha256 "dddb1a840cd66b865cf8110d27b766cd2ec99a145b3b0a00a420d30ea995e950" => :sierra
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
