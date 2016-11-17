class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://www.lysator.liu.se/~nisse/misc/"
  url "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"
  sha256 "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "bb6ea50086f1c045aba783d17bc0e6676e68aa2197f5f6d3cf94d4167f86c0e8" => :sierra
    sha256 "dd211e28b1961d12fab02da41c3966d6a2ce0da910b55ced89fdf446ce44d085" => :el_capitan
    sha256 "1d1c340d070648e5bbd2faeef20ef03e03907758b141d97082ff5f4d57f75867" => :yosemite
  end

  # This patch fixes compilation with Clang.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5f0ad3/argp-standalone/patch-argp-fmtstream.h"
    sha256 "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    lib.install "libargp.a"
    include.install "argp.h"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
