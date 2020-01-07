class Dtool < Formula
  desc "Command-line tool collection to assist development"
  homepage "https://github.com/guoxbin/dtool"
  url "https://github.com/guoxbin/dtool/archive/v0.4.0.tar.gz"
  sha256 "05ee5d3e4669d778d8e0c33a51d491607e382731cdc541a7cc8b38e75e57826b"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cb48478d80e3324fddcd9cd4ab434ca687f52ea2960719457bfd014a8b69ed4" => :catalina
    sha256 "34b72e50428bbda5d8c0b6d276d3d40e1abdb5229e647114eaa341ff53e4cd1f" => :mojave
    sha256 "e5d2bef3481a5894d55fdd7b626db1a160e3f07e4e3878b8376291dea30da14f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "0x61626364", shell_output("#{bin}/dtool s2h abcd")
  end
end
