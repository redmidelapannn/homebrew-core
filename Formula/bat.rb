class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.9.0.tar.gz"
  sha256 "4ce9c118cf5da1159a882dea389f3c5737b5d98192e9a619b0fe8c1730341cc6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bf74ab5036afcb49a63abf7aaffdeb4c945dc17e6f8be84c50089a89917bfaf5" => :mojave
    sha256 "3e807a5d7d60ce9506aaeb86a8da437e5b5df9df88b04e01f48d7871c9c4b18e" => :high_sierra
    sha256 "438d894e01b6abb4c59d494e946af127b1efd665a5c3f9f75d32d2a909019c22" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    bash_completion.install "bat.bash"
    # Temporary disable fish completions due to upstream issues. The completions might not work on
    # some systems. See https://github.com/sharkdp/bat/issues/372
    # fish_completion.install "bat.fish"
    zsh_completion.install "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
