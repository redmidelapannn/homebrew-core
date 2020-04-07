class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.3.0.tar.gz"
  sha256 "1107b0170a33769db36876334261924edc71dfc1eb00f9b464c7d2ad6d5743d3"
  head "https://github.com/cloudflare/boringtun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4153b373f9438dd4043e1e9727e736a6d228857a1eb41fa054d4593cd858d8cd" => :catalina
    sha256 "46fc17d10095e64031992c7d208e458ec647bcdb63810586246f7d1169a95da1" => :mojave
    sha256 "1f2d834be2ad45de7a183ce1789c07c2d462626ad79393e1852a0ed70321af99" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/boringtun", "--help"
    assert_match "boringtun " + version.to_s, shell_output("#{bin}/boringtun -V").chomp
    assert_match /failed to start/, shell_output("#{bin}/boringtun utun --log #{testpath}/boringtun.log")
    assert_predicate testpath/"boringtun.log", :exist?
    boringtun_log = File.read(testpath/"boringtun.log")
    assert_match /Success, daemonized/, boringtun_log.split("/n").first
  end
end
