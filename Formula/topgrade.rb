class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.3.1.tar.gz"
  sha256 "549b2fe1b807256ec42a16fe5507b115fcd9c75a59a17de46dc3151ae28a1337"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc44e46e5568cc8c9fac4a260edee9e58e0d89e7f525198fa414da1c9a43f86a" => :mojave
    sha256 "21913be2cb3c1327dd9e294cc9def014925d70aaf44f38ad9bba6bc20fcb064a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
