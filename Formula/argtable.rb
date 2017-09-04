class Argtable < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://argtable.sourceforge.io"
  url "https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz"
  version "2.13"
  sha256 "8f77e8a7ced5301af6e22f47302fdbc3b1ff41f2b83c43c77ae5ca041771ddbf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "daaf6febd3634d8bfc7183ecff055b447b47399d5139ae945a4999c275c384be" => :sierra
    sha256 "3706836b6abca975a5f4d07248543c39e84b3afbcbac136eac812da6bb84ef5d" => :el_capitan
    sha256 "ee5b16cc98b4518b72d8d3f6a25cf0a4e189eee76f8dcb2c23fb54d8254a3491" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOF.undent
      #include "argtable2.h"
      #include <assert.h>
      #include <stdio.h>

      int main (int argc, char **argv) {
        struct arg_lit *all = arg_lit0 ("a", "all", "show all");
        struct arg_end *end = arg_end(20);
        void *argtable[] = {all, end};

        assert (arg_nullcheck(argtable) == 0);
        if (arg_parse(argc, argv, argtable) == 0) {
          if (all->count) puts ("Received option");
        } else {
          puts ("Invalid option");
        }
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-largtable2",
                   "-o", "test"
    assert_match "Received option", shell_output("./test -a")
    assert_match "Received option", shell_output("./test --all")
    assert_match "Invalid option", shell_output("./test -t")
  end
end
