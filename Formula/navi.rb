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
    libexec.install Dir["cheats/*"]
    libexec.install Dir["shell/*"]
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    assert_match "foo", shell_output("NAVI_PATH=#{prefix}/tests/cheats #{bin}/navi best simple")
  end
end
