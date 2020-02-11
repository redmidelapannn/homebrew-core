class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.1.tar.gz"
  sha256 "594130c1e985379ce60885aab1b961d2326d0e5b34816d1c3590cf5837493742"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5e1b29c778e2e3eeb98f64ee3091cbc5fad00ae921b4790b38afbd7db22821cc" => :catalina
    sha256 "667da828192ffb13bae1fc357f9dc57a6c535f8b62cca7ed48b8a99f1d345544" => :mojave
    sha256 "ff6e5bee3656845ff182b1fefd34116fd7704705d3c541bb11ea0f2884c12d45" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    assert_match "BFS", shell_output("#{bin}/broot --help 2>&1")

    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/broot --cmd :pt --no-style --out #{testpath}/output.txt
      send "n\r"
      expect {
        timeout { exit 1 }
        eof
      }
    EOS

    assert_match "New Configuration file written in", shell_output("expect -f test.exp 2>&1")
  end
end
