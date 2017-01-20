class Maclaunch < Formula
  desc "Command-line utility for managing your launch agents and daemons."
  homepage "https://github.com/HazCod/maclaunch"
  url "https://github.com/HazCod/maclaunch/archive/0.2.tar.gz"
  sha256 "f265e819751ed242abaa2d0ef8b1ed3ffed6df043992151e5f905cc19555a079"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ea67d436612d9463cd8a342b757b91108ab2735aa6265aec4ed1683f41cb937" => :sierra
    sha256 "c186a112fa57771d227658e32c973d1b55183982abca1f4f157976dbc9aceee2" => :el_capitan
    sha256 "c186a112fa57771d227658e32c973d1b55183982abca1f4f157976dbc9aceee2" => :yosemite
  end

  def install
    bin.install "maclaunch.sh" => "maclaunch"
  end

  test do
    system "#{bin}/maclaunch"
  end
end
