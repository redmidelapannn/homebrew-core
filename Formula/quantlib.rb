class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "http://quantlib.org/"
  url "https://downloads.sourceforge.net/project/quantlib/QuantLib/1.7/QuantLib-1.7.tar.gz"
  mirror "https://distfiles.macports.org/QuantLib/QuantLib-1.7.tar.gz"
  sha256 "4b6f595bcac4fa319f0dc1211ab93df461a6266c70b2fc479aaccc746eb18c9b"

  bottle do
    revision 1
    sha256 "39e96f3602a70d7d86e433ffdd59dffe9287f7d5b8321d61a639dc750536f28c" => :el_capitan
    sha256 "3173d1523b438d81f51f4eedc2808c4ef7df423f4f9ae37ba89b57c467bee7bd" => :yosemite
    sha256 "796ee6fdaf504e3c3ba1a6499fe9f24f1b409516bcf2164c08be9ffa8cd34af0" => :mavericks
  end

  head do
    url "https://github.com/lballabio/QuantLib.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11
  # fix for quantlib 1.7 linking conflicts with the boost thread library
  # this patch must be removed when quantlib 1.8 is released, because quantlib maintainers fixed the bug
  # (see https://github.com/lballabio/QuantLib/commit/d1909593d9f36c6703966460fb48773792facd7e)
  patch :p0 do
    url "https://gist.githubusercontent.com/enricodetoma/7d7b137b69726815f070/raw/aa952c28854df8bf3e95069ba1beb3ec76924644/patch-FRA"
    sha256 "cd5814785b3850bfd88559e94331ac3ae907868c36bfa23dbba41e2ef87cd9d9"
  end

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    if build.head?
      system "./autogen.sh"
    end
    if MacOS.version >= :mavericks
      ENV.append "LDFLAGS", "-stdlib=libstdc++ -mmacosx-version-min=10.6"
      ENV.append "CXXFLAGS", "-stdlib=libstdc++ -mmacosx-version-min=10.6"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--enable-static",
                          "--with-boost-include=#{Formula["boost"].opt_include}",
                          "--with-boost-lib=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{share}/emacs/site-lisp/quantlib",
                          "LDFLAGS=#{ENV.ldflags}",
                          "CXXFLAGS=#{ENV.cxxflags}"
    system "make", "install"
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
