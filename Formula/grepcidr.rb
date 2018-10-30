class Grepcidr < Formula
  desc "Filter IP addresses matching IPv4 CIDR/network specification"
  homepage "http://www.pc-tools.net/unix/grepcidr/"
  url "http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz"
  sha256 "61886a377dabf98797145c31f6ba95e6837b6786e70c932324b7d6176d50f7fb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "126180ddd5f57210e4cc116483207731bda5a57e9d28114f2c56a74f7eeec571" => :mojave
    sha256 "f5aca73329ca4bf838832a0f2cb358cc0ffc2e41da706580ad718bc1bcdf2ca1" => :high_sierra
    sha256 "5507a67508d54f88b9cece1be302a6696e09f6bfbd1080301da161c80355200a" => :sierra
  end

  def install
    system "make"
    bin.install "grepcidr"
    man1.install "grepcidr.1"
  end

  test do
    (testpath/"access.log").write <<~EOS
      127.0.0.1 duck
      8.8.8.8 duck
      66.249.64.123 goose
      192.168.0.1 duck
    EOS

    output = shell_output("#{bin}/grepcidr 66.249.64.0/19 access.log")
    assert_equal "66.249.64.123 goose", output.strip
  end
end
