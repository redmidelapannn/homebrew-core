class Streem < Formula
  desc "Prototype of stream based programming language"
  homepage "https://github.com/matz/streem"
  url "https://github.com/matz/streem/archive/201611.tar.gz"
  sha256 "807a9ccf3162efb061a15a333943050b329f0232cceb55492e5cd582c09a7fb4"
  head "https://github.com/matz/streem.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1db4b66df6e88669e9b3301242a9c8ec30f2a3e5fc95912a892d22de1e42adb" => :sierra
    sha256 "4968d4ff815b02813cbcab35f38bbcde1cce17e380064a409d7c0dc046e72b14" => :el_capitan
    sha256 "0f352f03bfda5eff5467d9e35d184067f055b6c60d3657612d22cc7513318d1e" => :yosemite
  end

  def install
    system "make"
    prefix.install "bin"
  end

  test do
    hello_text = shell_output("#{bin}/streem -e '[\"hello\"] | stdout'")
    assert_equal "hello\n", hello_text
  end
end
