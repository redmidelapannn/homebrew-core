class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.7.0.tgz"
  sha256 "e42df91556317588c6ca0e41bf796f9bd5ec5c70e0668e6c97c608c697c24a90"
  head "https://github.com/randombit/botan.git"

  bottle do
    rebuild 1
    sha256 "a3ee614e20a11ab01cafebc783813590948c36c82f4a6b2676284d04156dfd50" => :mojave
    sha256 "827ae0a3fff35f26b619051bcf1d532113dcdaa145574fdda54ccb9e4e2244ea" => :high_sierra
    sha256 "e1e340f2e6eac4b1197f0608bae820e0a649fa7a480cedf4345633a1581c6eaf" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

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
