class SimpleFuzzer < Formula
  desc "Simple Fuzzer"
  homepage "http://aaron.bytheb.org/programs/sfuzz.html"
  url "https://github.com/orgcandman/Simple-Fuzzer.git",
      :commit => "3bf135bf1dfab5ddffb40f273a37d6502d95b752"
  version "0.7.1"
  head "https://github.com/orgcandman/Simple-Fuzzer.git"

  bottle do
    sha256 "5e363394851fced83bc31931d605c36c404388d6c9dd1cb8504915ed3d175b43" => :mojave
    sha256 "35659ad6d11c86d48c7440459b98f55f206455735a361a6922b526e7363ffd85" => :high_sierra
    sha256 "043624b30db5eda18d6df69b31458c7063490be9ad6b8bfe4c9db0a582c492fd" => :sierra
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "sfuzz"
  end

  test do
    system "#{bin}/sfuzz", "-h"
  end
end
