class Ddgr < Formula
  include Language::Python::Shebang

  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.8.tar.gz"
  sha256 "882972441fcbcc94b52387e8ede8d3dd4e9dee47c83619b9d0b55357819682a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "23bc6dd2bbf12e812bb2fbf7d7b4f94b4849b60dcb0facd2b8649c7ee0871f5a" => :catalina
    sha256 "23bc6dd2bbf12e812bb2fbf7d7b4f94b4849b60dcb0facd2b8649c7ee0871f5a" => :mojave
    sha256 "23bc6dd2bbf12e812bb2fbf7d7b4f94b4849b60dcb0facd2b8649c7ee0871f5a" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    rewrite_shebang detected_python_shebang, "ddgr"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/ddgr --noprompt Homebrew")
  end
end
