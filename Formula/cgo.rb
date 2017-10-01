class Cgo < Formula
  desc "A terminal based gopher client"
  homepage "https://github.com/kieselsteini/cgo"
  url "https://github.com/kieselsteini/cgo/archive/c1ed336.zip"
  version "0.4.1"
  sha256 "f644ed2a40347d5d8567ef3d43c8c1da76ed251b71ddb34c576efa3b55782d13"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ff5640c37dd473f6b9497e21c24df292b6782db3475eda55778584cdf8e33c2" => :high_sierra
    sha256 "f195d818bcfc11d0e5712797665705470e3cd4a210402008ff1b8153fa69a940" => :sierra
    sha256 "73b3f4c3a80ef101850d66f7bfe3b6a363576001a0fa9f358d72f1c80ae6e2ca" => :el_capitan
  end

  depends_on "telnet"=> :optional
  depends_on "mplayer" => :optional

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/cgo", "-v"
  end
end
