class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.0.0.tar.gz"
  sha256 "de63659887e0fd074543917b492b8f7fdb465c8001efae40f736468dd5def6c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :catalina
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :mojave
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    # copy resources
    libexec.install Dir["cheats/*"]
    libexec.install Dir["shell/*"]

    # build binary
    system "cargo", "install", "--root", prefix, "--path", "."

    # make sure the binary is in the same folder as the resources
    mv "#{bin}/navi", "#{libexec}/navi"
    ln_s "#{libexec}/navi", "#{bin}/navi"
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")

    (testpath/"cheats/test.cheat").write <<~EOS
      % test

      # foo
      echo "bar"

      # lorem
      echo "ipsum"
    EOS

    assert_match "bar", shell_output("#{bin}/navi --path #{testpath}/cheats best foo")
  end
end
