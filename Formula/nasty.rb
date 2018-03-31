class Nasty < Formula
  desc "Passphrase cracker for PGP or GPG keys"
  homepage "https://www.vanheusden.com/nasty/"
  url "https://www.vanheusden.com/nasty/nasty-0.6.tgz"
  sha256 "7607256d4672f1c52f2603d7b9691e7250bfe3a9b4f219fcbb61227172a7f6b7"
  bottle do
    cellar :any
    sha256 "a39089e33f8a974750798dcad617939b19e3f9363615cc1ce7f0885e14328de3" => :high_sierra
    sha256 "b399bd43697daac224fe2a1728b8fd9ad8695877d968e35c2ddc5965d940a057" => :sierra
    sha256 "6b42dc11f2f4d3c3be12b9a94ceadb5a7047b12a07efd0a524e706244bbb4363" => :el_capitan
  end

  depends_on "gpgme"

  def caveats
    "You need to allow scripted passphrase entry by adding 'pinentry-mode loopback' to ~/.gnupg/gpg.conf"
  end

  def install
    system "make"
    bin.install "nasty"
  end

  test do
    (testpath/"gpg.conf").write <<~EOS
      pinentry-mode loopback
    EOS
    (testpath/"generate-key.script").write <<~EOS
      Key-Type: 1
      Key-Length: 2048
      Subkey-Type: 1
      Subkey-Length: 2048
      Name-Real: Joan of Arc
      Name-Email: joan@arc.com
      Passphrase: ya3Iey2H
      Expire-Date: 0
    EOS
    system "gpg", "--batch", "--homedir", testpath, "--no-permission-warning", "--gen-key", "generate-key.script"
    (testpath/"wordlist.txt").write <<~EOS
      badguess1
      badguess2
      ya3Iey2H
      badguess3
    EOS
    ENV["GNUPGHOME"] = testpath
    system "#{bin}/nasty", "-m", "file", "-i", testpath/"wordlist.txt", "-f", testpath/"passphrase.out"
    recovered = File.read(testpath/"passphrase.out")
    raise "Passphrase was not recovered" unless recovered =~ /ya3Iey2H/
  end
end
