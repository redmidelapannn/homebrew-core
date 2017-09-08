class Ydict < Formula
  desc "Yet another command-line dictionary for geeks!"
  homepage "https://github.com/TimothyYe/ydict"
  url "https://github.com/TimothyYe/ydict/releases/download/V0.6/ydict-mac64-0.6.tar.gz"
  sha256 "8596ca84cee14975a83645f8aa3529ff47e26d939ba9521b95170dc13471c2e3"

  bottle do
    sha256 "817d05181d0c2621dddae0c2a019ec40e4fec93bb5c350dd159a9fc9db5122d7" => :sierra
    sha256 "817d05181d0c2621dddae0c2a019ec40e4fec93bb5c350dd159a9fc9db5122d7" => :el_capitan
    sha256 "817d05181d0c2621dddae0c2a019ec40e4fec93bb5c350dd159a9fc9db5122d7" => :yosemite
  end

  def install
    bin.install "ydict"
  end

  test do
    system "#{bin}/ydict", "hello"
  end
end
