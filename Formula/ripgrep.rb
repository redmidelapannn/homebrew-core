class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.2.1.tar.gz"
  sha256 "372ccd0a93c98e9f3cc51644a9c52d1d8437ecb8b0e2908b33df9a46ca7b9ee2"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7256d24a2714cf440483819044ff38f311cd689db12a4d3eead5a72511a085a" => :sierra
    sha256 "e21f7a9d26c723a5ffd5fe462905e2f29bfceac28c619172fb96720ad12a7064" => :el_capitan
    sha256 "e4e9a338f0ed39479b3bc2c967bdaf1b5720511bbdc86cca0f0e7e933654cdaa" => :yosemite
  end

  depends_on "multirust" => :build

  def install
    system "multirust", "update", "nightly"
    system "multirust", "override", "nightly"

    ENV["RUSTFLAGS"] = "-C target-feature=+ssse3"
    system "cargo", "build", "--release", "--features", "simd-accel"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
