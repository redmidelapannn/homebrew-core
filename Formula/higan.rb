class Higan < Formula
  desc "Multi-system emulator for games"
  homepage "https://byuu.org/higan"
  url "https://github.com/byuu/higan/archive/v107.tar.gz"
  sha256 "ac7aaabd88f3cde2915a435d11ba70f5570e1a2c17bbb572cf56fb9644dbc30f"
  head "https://github.com/byuu/higan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a3d16fabac3ab477f9bf9f48e916a4df40503032b1e2f39260073bf1a7b5ae5" => :catalina
    sha256 "818d414ab3b9d89a62363fd63fde9f6bbcc84bd7a026c34a26923fb18b6641dd" => :mojave
    sha256 "b481ca50d65cc48dc692806af769bbe39a13289f9377153bf6e7b7250707bc9b" => :high_sierra
  end

  def install
    system "make", "-C", "higan", "local=false"
    system "make", "-C", "icarus"
    # Move to libexec to expose to `brew linkapps`
    libexec.mkpath
    mv "higan/out/higan.app", libexec
    mv "icarus/out/icarus.app", libexec
  end

  test do
    assert_predicate libexec/"higan.app", :exist?
    assert_predicate libexec/"icarus.app", :exist?
  end
end
