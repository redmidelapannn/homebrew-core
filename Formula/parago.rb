class Parago < Formula
  desc "Command-line tool to help you rapidly create machine learning models"
  homepage "https://github.com/skafos/parago-cli"
  url "https://github.com/skafos/parago-cli/releases/download/1.0.0/pgo-v1.0.0.tar.gz"
  sha256 "168ef6b7c655c746feb686344abbc3fd5f1657efdcebba9db82cc70499a2b33c"
  bottle do
    cellar :any_skip_relocation
    sha256 "a12729de30369d64b729d701ae79b16f161842170f2b76792992015b9f2211f5" => :mojave
    sha256 "a12729de30369d64b729d701ae79b16f161842170f2b76792992015b9f2211f5" => :high_sierra
    sha256 "7444419e2e82d974c412e99a1cbe0778d586b406b8cf7804731c3c129a3e73c0" => :sierra
  end

  depends_on "node"

  def install
    inreplace "bin/pgo", /^CLIENT_HOME=/, "export pgo_OCLIF_CLIENT_HOME=#{lib/"client"}\nCLIENT_HOME="
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pgo"
  end

  def caveat; <<~EOS
    To begin using Parago, please run `pgo setup`.
  EOS
  end

  test do
    system bin/"pgo", "version"
  end
end
