class Drip < Formula
  desc "JVM launching without the hassle of persistent JVMs"
  homepage "https://github.com/flatland/drip"
  url "https://github.com/flatland/drip/archive/0.2.4.tar.gz"
  sha256 "9ed25e29759a077d02ddac61785f33d1f2e015b74f1fd934890aba4a35b3551d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fdcc01576dbfec4eb37f7b6b00d95418f13e3454ca0bc4dd271983536861ae18" => :high_sierra
    sha256 "ce69e38021a8bf1b8de0365b7792af1e8235ad9b3094ae213085181296ddcbd4" => :sierra
    sha256 "a4597e34661d9e931da426d5fa09b1e2a7cea5f1cb6289d9ed763ac6085da46e" => :el_capitan
  end

  depends_on :java => "1.8"

  def install
    system "make"
    libexec.install %w[bin src Makefile]
    bin.install_symlink libexec/"bin/drip"
  end
end
