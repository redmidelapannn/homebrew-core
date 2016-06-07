class Pwnat < Formula
  desc "Proxy server that works behind a NAT"
  homepage "https://samy.pl/pwnat/"
  url "https://samy.pl/pwnat/pwnat-0.3-beta.tgz"
  sha256 "d5d6ea14f1cf0d52e4f946be5c3630d6440f8389e7467c0117d1fe33b9d130a2"

  head "https://github.com/samyk/pwnat.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0149fc977622f2fd55db5845a377437028df31bb847230d3fd73d548e481e289" => :el_capitan
    sha256 "3554e2661a9b62eaeadd2fbf89f6ef59a5c01a8c5b030e61711b5f9048a6dc84" => :yosemite
    sha256 "4879d61dca4ede18f4db6a59f1a43024794a42fc02864956c2c585cb3fccf9ac" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
  end

  test do
    shell_output("#{bin}/pwnat -h", 1)
  end
end
