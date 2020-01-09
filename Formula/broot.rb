class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.3.tar.gz"
  sha256 "d498b911e4f7cc936a705a28653a0d7a7183c80ef093fd7e738403f3388f6322"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4bbc40dfb31281dd15bb2add71763fb170fcaa9ac74c9c2ca81ffdcbf784ddc" => :catalina
    sha256 "da8d087396f591e24cac6efd5909a4b6ffb06ff0fbd45671c9110a9dc9b27c6c" => :mojave
    sha256 "567737e15d269684675754e22ec7966e15fcffd9c3d3a37c77cfe3940f26be3d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
