class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-01-01.tar.gz"
  version "20170101"
  sha256 "e46019b4428942464bf65ba92f2fcd88739d1b05fe7c3787bc031a03a50a327a"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66fced3a9300c3725ebfdfdcb5e63159cad46323de38de78c42ea873bfa12a83" => :sierra
    sha256 "f59e22cd3418f7ea8d3fc287f2a5f68ece5b4bad5ac6808d56f5da1756929561" => :el_capitan
    sha256 "27a448ddb2c0a741a815b67158784145781c13ceb5ab718d66d942076eb6f56f" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
