class Phoon < Formula
  desc "Displays current or specified phase of the moon via ASCII art"
  homepage "https://www.acme.com/software/phoon/"
  url "https://www.acme.com/software/phoon/phoon_14Aug2014.tar.gz"
  version "04A"
  sha256 "bad9b5e37ccaf76a10391cc1fa4aff9654e54814be652b443853706db18ad7c1"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ae91a1dc089678416ddeab9bd3dfbe76f0fd9f4789a86b187740167d0658926d" => :el_capitan
    sha256 "0e1367a2f7fc2ff8e225e61384f0ab7211d0ccef9bb89683e5350b76bbd67f11" => :yosemite
    sha256 "fe3e7a1e5ba4f5373d948872d1f26fd33c3fac21aa8d7c260841eac5bd477e1a" => :mavericks
  end

  def install
    system "make"
    bin.install "phoon"
    man1.install "phoon.1"
  end
end
