class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.11.0.tar.gz"
  sha256 "bb4e39efadfab71c0c929a92b82dac58deacfe2a4eb527d4256ac0634e042ed2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5d5063109837f150a5c0855b33cdd2ca0e5db65d0dc471f5f0eca3dd867dc815" => :mojave
    sha256 "449362bf2a67ea50ef18374c850da5130fa1a5e2fe2b5c6353dc56475f08811c" => :high_sierra
    sha256 "80a06d9ecc931678c779f1d035f088084cc55e5ee4a3fa4e477e59a9951e3ec3" => :sierra
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    fish_completion.install "assets/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
