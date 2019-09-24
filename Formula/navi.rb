class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.8.1.tar.gz"
  sha256 "fb453cddb7c15ffdabe62a88f80948b9335fc6dbe79547ed68dbc55236d241ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "62f173b7854fe4ab1dbf19ce4174bf52b19c2c411e8e3abf9009c9de6516a7f3" => :mojave
    sha256 "62f173b7854fe4ab1dbf19ce4174bf52b19c2c411e8e3abf9009c9de6516a7f3" => :high_sierra
    sha256 "aa932d7060479b5f5ccff5f0a55aa56aad5acfa317661f421df8209ac0e52149" => :sierra
  end

  depends_on "fzf" => :build

  def install
    libexec.install Dir["*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_equal version, shell_output("#{bin}/navi --version")
  end
end
