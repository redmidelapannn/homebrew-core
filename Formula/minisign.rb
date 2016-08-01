class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.7.tar.gz"
  sha256 "0c9f25ae647b6ba38cf7e6aea1da4e8fb20e1bc64ef0c679da737a38c8ad43ef"

  bottle do
    cellar :any
    sha256 "eda1ddf370982493aaa039c6056d0228041ff7a8784f2098e9133904a451d381" => :el_capitan
    sha256 "f211d75128d691038180fc8a6acd2eed6880f67a769f643aa94f88ef26c6967f" => :yosemite
    sha256 "f5098cd0f3f04c5bd2054734a605b1e07f2f0557cb9913fbdd7db60f286c0cfb" => :mavericks
  end

  depends_on "libsodium"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"keygen.sh"

    system "./keygen.sh"
    assert File.exist?("minisign.pub")
    assert File.exist?("minisign.key")

    (testpath/"signing.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"signing.sh"

    system "./signing.sh"
    assert File.exist?("homebrew.txt.minisig")
  end
end
