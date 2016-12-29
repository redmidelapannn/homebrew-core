class Mdds < Formula
  desc "multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "http://kohei.us/files/mdds/src/mdds-1.2.2.tar.bz2"
  sha256 "141e730b39110434b02cd844c5ad3442103f7c35f7e9a4d6a9f8af813594cc9d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5dcf4f9993d164e16323cf15f980557263b709b995d79548285571e41d1186d8" => :sierra
    sha256 "239b668243e44cc939ed3fbec71d083b32288c175dfa8d986e4f59b49c620e96" => :el_capitan
    sha256 "239b668243e44cc939ed3fbec71d083b32288c175dfa8d986e4f59b49c620e96" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "boost"
  needs :cxx11

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include.children.first}"
    system "./test"
  end
end
