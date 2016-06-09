class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://github.com/pklausler/aoeui"
  url "https://github.com/pklausler/aoeui/raw/03ff419acb2d6669ea48b5640398c44528f662eb/aoeui-1.7.tgz"
  sha256 "f4c067ad2c3b95ad130411195dd53ea49300e8e3496ecf0deceff20350c7670d"
  head "https://github.com/pklausler/aoeui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef462c737fb92cb3fabfb7727c28739940533d1ff9097ceb1144c4bfaaf1740" => :el_capitan
    sha256 "ae3dd8757275de9d351d80b8487a6553e44d907daa19cb508bcd4f6974b2edac" => :yosemite
    sha256 "aa5e0a4f8ceb9fde5a816af4288127b98807442927498344d8eb9252e7c23245" => :mavericks
  end

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
