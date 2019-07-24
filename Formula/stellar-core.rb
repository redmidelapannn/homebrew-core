class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v11.3.0",
      :revision => "5f7821d327f8e873c1c5fd6b638e70e1f06066e1"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "d820808106dcaf349512e9380b6073fc10e003d31cace2c77213f66a99f77506" => :mojave
    sha256 "4518f82e5cf2fc70957ff29e8aace133311304c48b0541dfd36a9b65189941d3" => :high_sierra
    sha256 "6e9d40aaf80d503501ce35e61ef3411a3afd5b3caf112890ee529e0371a0a40c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium"
  depends_on "postgresql"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "--test", "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount],[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
