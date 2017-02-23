class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "https://logological.org/cheops"
  url "https://files.nothingisreal.com/software/cheops/cheops-1.3.tar.bz2"
  mirror "https://github.com/logological/cheops/releases/download/1.3/cheops-1.3.tar.bz2"
  sha256 "a3ce2e94f73068159827a1ec93703b5075c7edfdf5b0c1aba4d71b3e43fe984e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6087558b906474548d121bf3e745a7291dbc307d0c9ef16b3b6edd92d9dc830" => :sierra
    sha256 "3ed8f3d4920c6c44b4d25f16402564db5639acb1e3f104329f244cd52051a9f6" => :el_capitan
    sha256 "de719231c43b1494c0a77fe0ef97868399bd67e3c3386fecfd6564f26f4acbdf" => :yosemite
  end

  head do
    url "https://github.com/logological/cheops.git"

    option "with-tex", "Build pdf manual"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on :tex => [:build, :optional]
  end

  def install
    if build.head?
      if build.without? "tex"
        inreplace "Makefile.am",
          "doc_DATA = COPYING NEWS AUTHORS THANKS README doc/cheops.pdf",
          "doc_DATA = COPYING NEWS AUTHORS THANKS README"
      end

      system "autoreconf", "-fiv"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cheops", "--version"
  end
end
