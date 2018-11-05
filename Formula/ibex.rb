class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.7.2.tar.gz"
  sha256 "d6653999cfe2af51b11253b3fb4bdd4cad90a7dc8247503fdc8532bf99bebaf8"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "764d1d9a1e05e95491cfdb74d1914e24ef4a30cf28e0a92ec006328f56745c7c" => :mojave
    sha256 "b3cdd6d7fb3eca70015d6d77ad2c3ccea9cabfd54599fc47dde2843d729c81e7" => :high_sierra
    sha256 "d29319ba6bf572bbde6726d79eb2d4368cc5d2ec42a12dfff728b36d92c2c2f4" => :sierra
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--enable-shared",
                                 "--lp-lib=soplex",
                                 "--with-optim"
    system "./waf", "install"

    pkgshare.install %w[examples plugins/solver/benchs]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub! /CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd"
      s.gsub! /LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex"
    end

    (1..8).each do |n|
      system "make", "lab#{n}"
      system "./lab#{n}"
    end

    (1..3).each do |n|
      system "make", "-C", "slam", "slam#{n}"
      system "./slam/slam#{n}"
    end
  end
end
