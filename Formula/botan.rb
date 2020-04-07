class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.14.0.tar.xz"
  sha256 "0c10f12b424a40ee19bde00292098e201d7498535c062d8d5b586d07861a54b5"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "bc0c5b3b8a3c6d137003414520e262587e39219b0f48958da5172f3056cdb8c6" => :catalina
    sha256 "89f233c4bc764c40e3e0b22fcb115434dae976291ce464ebfd6d6c7fdf04e161" => :mojave
    sha256 "8895c7e67d28031351b03d8273fbfcbccdd33376baacc362a7a5429086fdf317" => :high_sierra
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
