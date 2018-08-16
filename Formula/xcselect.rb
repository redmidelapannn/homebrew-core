class Xcselect < Formula
  desc "Manage multiple versions of Xcode"
  homepage "https://github.com/pandawebsoft/xcselect"
  url "https://github.com/pandawebsoft/xcselect/archive/v1.1.0.14.tar.gz"
  sha256 "75639d12e5d91af4d4e0806518727d779bbf72b76197f44f7c08bf0cd71c4015"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd91bc5b36428a91105179f091575932f2dd1c3d7978826d19e26cbf0458da43" => :high_sierra
    sha256 "cd91bc5b36428a91105179f091575932f2dd1c3d7978826d19e26cbf0458da43" => :sierra
    sha256 "cd91bc5b36428a91105179f091575932f2dd1c3d7978826d19e26cbf0458da43" => :el_capitan
  end

  def install
    bin.install "bin/xcselect"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/xcselect --version|sed 's/[()]/./g'|rev|cut -c2-|rev").chomp
  end
end
