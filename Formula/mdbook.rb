class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.7.tar.gz"
  sha256 "b450d6f1c07624b4c31fd9bc7cb4390ca53e2c318136c62a86aaeea222437919"

  bottle do
    cellar :any_skip_relocation
    sha256 "84dd312e18197f8450a1274d5359be5ec32db6bfe6dac6ada21ff712a8b34e9c" => :catalina
    sha256 "aace64e94188f48b1f0ef9a68d08349fd13cbdd2187f26f55d502bceb13bab59" => :mojave
    sha256 "1e925ab1d4f3847d504a6164d7d551334f43f09e4a602cf3f57c9d5736a03bd5" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
