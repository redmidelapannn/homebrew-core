class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.14.2.tar.gz"
  sha256 "1e16b8ff440882a2dd8e73bdb55c2b88724b3f0f9844c602ae9fe74f509d0dfb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e61f1fd9cea0ce8ef85062114c7917e1ca7048f4e91d1366f246be596d705ea2" => :catalina
    sha256 "e61f1fd9cea0ce8ef85062114c7917e1ca7048f4e91d1366f246be596d705ea2" => :mojave
    sha256 "e61f1fd9cea0ce8ef85062114c7917e1ca7048f4e91d1366f246be596d705ea2" => :high_sierra
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
