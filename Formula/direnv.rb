class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.15.2.tar.gz"
  sha256 "35076978e2ccbd367043e8aa33ba4268c03270a68bac3789262dacb3b26115c2"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7ad03687df3853dccdda92ec6c6c357fa2c79d66fad906c8bccd674aafc6798d" => :high_sierra
    sha256 "22d616ad7ef20f0e39bcc304576b314e003998066293f9d47d1b964ed52e808e" => :sierra
    sha256 "f708acd24d9b7f380a1e957d0fdc2eb07841ed9d9fabf4faa46d589797323817" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    You must now configure your shell to enable direnv.

    If you use Bash, add the following line to ~/.bashrc:
      eval "$(direnv hook bash)"

    If you use Zsh, add the following line to ~/.zshrc:
      eval "$(direnv hook zsh)"

    For other shells, consult the direnv setup instructions:
      https://github.com/direnv/direnv/blob/master/README.md#setup
    EOS
  end

  test do
    system bin/"direnv", "status"
  end
end
