class Fff < Formula
  desc "Simple file manager written in bash"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/2.1.tar.gz"
  sha256 "776870d11c022fa40468d5d582831c0ab5beced573489097deaaf5dd690e7eab"

  bottle do
    cellar :any_skip_relocation
    sha256 "6afba2d7dce32e646fd5f34c832ed50f4c2f127bd5ebbe9a029454fd5cd72547" => :mojave
    sha256 "6afba2d7dce32e646fd5f34c832ed50f4c2f127bd5ebbe9a029454fd5cd72547" => :high_sierra
    sha256 "d86919fbbf539a19030072af25de809815d5e2209fb24b3c829f92e8a9c71b0a" => :sierra
  end

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
