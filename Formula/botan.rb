class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.13.0.tar.xz"
  sha256 "f57ae42a41e1091bca58f44f41addebd9a390b651603952c881ec89d50187e90"
  head "https://github.com/randombit/botan.git"

  bottle do
    rebuild 1
    sha256 "09161adf3443ef770cecb99d1b048a2844072cae5e73b209d8680d0e25a2690a" => :catalina
    sha256 "b2ec79abe2ccb67079feb9fb156655597d4fc32c8b6ea8bae12f951daa098f0d" => :mojave
    sha256 "7d6f05234a37948949da38084a3c50061760d6026fb7648723bbace798dd0d15" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "python@2" => :build
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
