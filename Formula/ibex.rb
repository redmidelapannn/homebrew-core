class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://web.archive.org/web/20190826220512/www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.8.7.tar.gz"
  sha256 "b80da9f6edecaf93edc00c7e7c630ae6cf934ce9ce061debb630f027e69b5c97"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a394483e833cdb4006beb4a8665a4d19e4e1eee99cfd2c563b82d44f9eaeaf6" => :catalina
    sha256 "da42da5918051255b6b2730ae7f7a8d143cebb1667d8dc5c865d2d4673a8cd43" => :mojave
    sha256 "183e2e9d634cf7dbaabfadecc55836dd8f8f511eda1a0c0c56fa9f010de088ce" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on :macos # Due to Python 2

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--enable-shared",
                                 "--lp-lib=soplex",
                                 "--with-optim"
    system "./waf", "install"

    pkgshare.install %w[examples benchs/solver]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    ENV.cxx11

    cp_r (pkgshare/"examples").children, testpath

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub!(/CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd")
      s.gsub!(/LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex")
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
