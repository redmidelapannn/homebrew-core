class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.8.1/QuantLib-1.8.1.tar.gz"
  sha256 "27d14d5e49b8a21d20f03da69a05584af50e6a3dbe47dad5b9f2c61ad3460bed"
  revision 1

  bottle do
    cellar :any
    sha256 "a4c878ecfe755319c38d17cd232ad1fdc8d85bd21dc0c6b8fbc3b08f0400a3bd" => :sierra
    sha256 "2c5708569d0d5232aa9ef43919c13c956590fa6f07ce385735b50672c2a54221" => :el_capitan
    sha256 "c1a1b24a4bdd7a109f74c0bf58ad86cdbf0f1c9047f5f09b18e0a2141eb395b9" => :yosemite
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11

  if build.cxx11?
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
  end

  def install
    ENV.cxx11 if build.cxx11?
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}"
      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
