class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.0.0.tar.gz"
  sha256 "2eb69547237a91fd31327d9fabd8dcfd63dd10c6ae8a086286dbd4299b92b7e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :catalina
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :mojave
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    rm "navi"
    system "cargo", "install", "--root", prefix, "--path", "."
    mv "bin/navi", "navi"
    libexec.install "navi"
    libexec.install Dir["cheats/*"]
    libexec.install Dir["shell/*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
  end  
end
