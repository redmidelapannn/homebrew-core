class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20171227.tar.gz"
  sha256 "eaea0172c1f4ee4550d1b6c9ce01aab8d1ab66b4207776aa67991eb5872fdcd8"
  revision 1
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "ae936a251b3b18999bd7c4e111601f15df2c138899b9e3ad5df15a99ec82a57e" => :mojave
    sha256 "634ebc0b902e3b3b71509bd670a17e8f1650f36ba6439d85a2fbc7e4099603a4" => :high_sierra
    sha256 "1851d89dfd984f09f2ccbdf0f5484389d1caa18debcaac5748230c1d3ba950fb" => :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end
