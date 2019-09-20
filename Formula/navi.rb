class Navi < Formula
  desc "An interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.5.0.tar.gz"
  sha256 "8ca49b7032277f74244e737edd1a4fe2f296918cdd3d00c0734c67b4f1649ff2"
  bottle do
    cellar :any_skip_relocation
    sha256 "b4a9bd5e0e109966375c186d0e84a9cbdbeb478ff52228c29a4c85c7f6dd6295" => :mojave
    sha256 "b4a9bd5e0e109966375c186d0e84a9cbdbeb478ff52228c29a4c85c7f6dd6295" => :high_sierra
    sha256 "798c79847d6c4cfa75b761fa2728e3764fb92fea20eed8a600b1ff52b2fb88e6" => :sierra
  end

  
  depends_on "fzf" => :build

  def install
    libexec.install Dir["*"]
    bin.write_exec_script (libexec/"navi")
  end

end