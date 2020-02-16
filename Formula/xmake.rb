class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.2.9/xmake-v2.2.9.tar.gz"
  sha256 "7d7b4b368808c78cda4bcdd00a140cd8b4cab8f32c7b3c31aa22fdd08dde4940"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a7709bdb3593814418701f04ca8a14e36ea4c39e273a86dd9392590386ae786f" => :catalina
    sha256 "da263c4d4e5d204a4f02322a19c37b2e5e40f22bee89f17e7f09eb26ea9ff04e" => :mojave
    sha256 "4e0032aba9ebde646ce36ddd93a619296ea95f0d6d8ce818b7fd762cfa944055" => :high_sierra
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    system bin/"xmake"
    assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
  end
end
