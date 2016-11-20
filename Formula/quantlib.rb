class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.9/QuantLib-1.9.tar.gz"
  sha256 "eb4aeebaa2b850c36eb8a03bc0c71556f34811913b4bea21ec0553a91b746de5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "df64e2706af3d5bf9d652c8369af12e56bc6ec61e8f3ff98270a68192c76d0fd" => :sierra
    sha256 "b221fe6a6e23342d586f01c664a638f340f8b01644f31e6c5876f9f9f39cf0b6" => :el_capitan
    sha256 "511c16be6393faf0c40728d76b71f7d75c8b66c3619dd49ed16c610dffb75ff5" => :yosemite
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11
  option "with-intraday", "Enable intraday components to dates"

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
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
