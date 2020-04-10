class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.14.0.tar.xz"
  sha256 "0c10f12b424a40ee19bde00292098e201d7498535c062d8d5b586d07861a54b5"
  head "https://github.com/randombit/botan.git"

  bottle do
    rebuild 1
    sha256 "eb3dcb2ac0652f103d9514b964a0f7c151c94d32c9ce6e97ddfdc20d27b3151f" => :catalina
    sha256 "9d16967839ecb29c9377891b93ea2b14410e5c2057c9baf314ae205425f5304a" => :mojave
    sha256 "429e8b69c9e20e9dea91b10e0d88a227cbedbbbbaca41a2b60085d323c6ac95f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos # Due to Python 2
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
