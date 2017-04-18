class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database."
  homepage "https://github.com/jcsalterego/historian"
  url "https://github.com/jcsalterego/historian/archive/0.0.2.tar.gz"
  sha256 "691b131290ddf06142a747755412115fec996cb9cc2ad8e8f728118788b3fe05"

  bottle do
    cellar :any_skip_relocation
    sha256 "060049add451dd35c8d0a20d3b5a18598820f5847266a5190cbebf659d77af53" => :sierra
    sha256 "872ae61e55d51d31dca83a353f3c842c1d025987887a9afad269cdf37721bcc4" => :el_capitan
    sha256 "872ae61e55d51d31dca83a353f3c842c1d025987887a9afad269cdf37721bcc4" => :yosemite
  end

  def install
    bin.install "hist"
  end

  test do
    ENV["HISTORIAN_SRC"] = "test_history"
    (testpath/"test_history").write <<-EOS.undent
      brew update
      brew upgrade
    EOS
    system bin/"hist", "import"
  end
end
