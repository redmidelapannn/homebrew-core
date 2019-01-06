# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Imemo < Formula
  desc "save memo easily on terminal."
  url "https://github.com/kcwebapply/imemo/archive/1.2.0.tar.gz"
  homepage "https://github.com/kcwebapply/imemo"
  sha256 "fe443ab343e7f335dfa05b772512bc75c303812f43ba7795d7ed1b6a8ca15e70"
  bottle do
    cellar :any_skip_relocation
    sha256 "6ce3cef77e48344ee9123c300500e8b29af8f65ecc3a37e475e32dc5cbd7cc0d" => :mojave
    sha256 "9cf82f11d8f0492cc26d9ff3c565154203d8b38ef9157ef14ccef6009523b4fc" => :high_sierra
    sha256 "3138bc9f54d01c9cc15a0915c9259cb3941a7cf0ef83030278ae681909d1cfaf" => :sierra
  end

  # depends_on "cmake" => :build
  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    print buildpath
    ENV["GOPATH"] = buildpath
    imemo_path = buildpath/"src/github.com/kcwebapply/imemo/"
    imemo_path.install buildpath.children

    cd imemo_path do
      system "go", "get", "github.com/BurntSushi/toml"
      system "go", "get", "github.com/codegangsta/cli"
      system "dep", "ensure"
      system "go", "build"
      bin.install "imemo"
    end
  end

  test do
    assert_match "memo saved!", shell_output("#{bin}/imemo save \"learning math\" ")
    assert_match "1 learning math", shell_output("#{bin}/imemo all ")
    assert_match "", shell_output("#{bin}/imemo delete 1")
    assert_match "", shell_output("#{bin}/imemo all ")
  end
end
