class Libmarisa < Formula
  desc "Static and space-efficient trie data structure"
  homepage "https://github.com/s-yata/marisa-trie"
  revision 1

  stable do
    url "https://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
    sha256 "67a7a4f70d3cc7b0a85eb08f10bc3eaf6763419f0c031f278c1f919121729fb3"

    # trie-test.cc:71: TestKey(): 115: Assertion `r_key.ptr() == NULL' failed.
    # Both upstream patches are needed since one unwinds the other.
    patch do
      url "https://github.com/s-yata/marisa-trie/commit/80f812304bcf6d2ca2f7d614cbb7b5fb07ac44f5.patch"
      sha256 "e7882c93b470c1a079ee22805108f976b2a460759ea7656cf5264a793427cc8c"
    end

    patch do
      url "https://github.com/s-yata/marisa-trie/commit/cbab26f05f92313e72f4a58262264879bdb37531.patch"
      sha256 "dfce4e35db5a2b51bdcbc396dfd03cbf1c9b5e2f786548e8001e2af661d4b55c"
    end
  end

  bottle do
    cellar :any
    revision 2
    sha256 "8a02695ab5e2d3417f3ca03b7639ef97de7d58aa72a4268c05620b0af681058b" => :yosemite
    sha256 "b7d7691ab312b816b016a954f2e00106616870d388d2ccef5df68180bcaf30ef" => :mavericks
  end

  head do
    url "https://github.com/s-yata/marisa-trie.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fixes TestEntry(): 212: Assertion `entry.ptr() == NULL' failed.
  # Same method as upstream used for the `r_key.ptr() == NULL' bug
  # Upstream PR opened 7th May 2016
  patch do
    url "https://github.com/s-yata/marisa-trie/pull/9.patch"
    sha256 "35cb5c33083e9780aed45cfddd45ebe6aea28ae1eb2a2014f5f02a48cdbc60a9"
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <marisa.h>
      int main() {
        marisa::Keyset keyset;
        keyset.push_back("a");
        keyset.push_back("app");
        keyset.push_back("apple");

        marisa::Trie trie;
        trie.build(keyset);

        marisa::Agent agent;
        agent.set_query("apple");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lmarisa", "-o", "test"
    system "./test"
  end
end
