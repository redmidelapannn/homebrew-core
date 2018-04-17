class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.13.tgz"
  sha256 "d336be76c23b330bcdbf7d0af9e82f1f4f9866f9caffd37062c7f44d9c272661"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "73173b3fc4c8b4d43a584e1ac31526e1c971d5a25d5ee51c32f52b004386c612" => :high_sierra
    sha256 "cb884b2871f9eb8297c73a9fd6ff684969e050a9efd01eb5fa889c2469c452ce" => :sierra
    sha256 "e9e5b1c564d7f8fe6aabc68dd463d368ea2013e5b5d3e160ce73d19eb3805db7" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "openssl"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
