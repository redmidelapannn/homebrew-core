class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "https://tools.suckless.org/sic/"
  url "https://dl.suckless.org/tools/sic-1.2.tar.gz"
  sha256 "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185"

  head "https://git.suckless.org/sic", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5354973656e4836ee08eb5c4259a8e4ca8d0cd916df5d0667387594a12776743" => :sierra
    sha256 "f936e6198407b8931716e9ebc976378858816ca7104c71ae1c5013a289207918" => :el_capitan
    sha256 "f5e400c2b644ff8c78e90b7fdc5445762a469d93c99740164897e8c7c08d7c1d" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
