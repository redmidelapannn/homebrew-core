class Exa < Formula
  desc "Replacement for 'ls' written in Rust."
  homepage "https://the.exa.website"
  url "https://github.com/iKevinY/exa/archive/v0.4.1.tar.gz"
  sha256 "9302a9a99a8d06abd6f1743b4d4c41306697af8e97d3203272cab26a425b5c8b"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any
    sha256 "c0ea5ee3b00eadb590f3ecfd5bde9f917f09f78564b58fe96aa09bcfd79f6540" => :sierra
    sha256 "ad4ad58bc070e9737c84024203e806b85ad7d5eb8e8fb2049e3da691e29819d7" => :el_capitan
    sha256 "389b2b1043fb991d8bc79db4b6bb9d37bfb363953db15d3df8320ff06a9a12f9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libgit2" => :recommended

  def install
    args = ["--release"]
    args << "--no-default-features" if build.without? "libgit2"

    system "cargo", "build", *args
    bin.install "target/release/exa"
    man1.install "contrib/man/exa.1"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("exa")
  end
end
