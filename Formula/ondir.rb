class Ondir < Formula
  desc "Automatically execute scripts as you traverse directories"
  homepage "https://swapoff.org/ondir.html"
  url "https://swapoff.org/files/ondir/ondir-0.2.3.tar.gz"
  sha256 "504a677e5b7c47c907f478d00f52c8ea629f2bf0d9134ac2a3bf0bbe64157ba3"
  head "https://github.com/alecthomas/ondir.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "06b5a32ee3e78f94d8cee1e151d01bda40d0387b8e97a4e162c0db4ab6898ba8" => :sierra
    sha256 "76a3cd880fbec9fd0223a70ec1bd363944cfb9b61bc796d895f6f849a59f550f" => :el_capitan
    sha256 "b52accd1b75b8c9fb75957df764f8ddad7b726effe66dfe9930799e6bff05b98" => :yosemite
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
