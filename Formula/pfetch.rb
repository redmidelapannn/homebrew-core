class Pfetch < Formula
  desc "Pretty system information tool written in POSIX sh"
  homepage "https://github.com/dylanaraps/pfetch"
  url "https://github.com/dylanaraps/pfetch/archive/0.3.tar.gz"
  sha256 "e65694db6e49c9850d15bf9948a4d19ce9a1807966bd2e4cea7b0df202c2d14d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d39a9b93ac765a276a22c59bddd6918ec4f1c5c5644f72bea1071c180610de7c" => :catalina
    sha256 "d39a9b93ac765a276a22c59bddd6918ec4f1c5c5644f72bea1071c180610de7c" => :mojave
    sha256 "d39a9b93ac765a276a22c59bddd6918ec4f1c5c5644f72bea1071c180610de7c" => :high_sierra
  end

  def install
    bin.install "pfetch"
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
