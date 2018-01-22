class Chgems < Formula
  desc "Chroot for Ruby gems"
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha256 "515d1bfebb5d5183a41a502884e329fd4c8ddccb14ba8a6548a1f8912013f3dd"
  head "https://github.com/postmodern/chgems.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9b167c2b56b45a6636d59fd51c921384789a401a932b8fe3863db67d64da318" => :high_sierra
    sha256 "c9b167c2b56b45a6636d59fd51c921384789a401a932b8fe3863db67d64da318" => :sierra
    sha256 "c9b167c2b56b45a6636d59fd51c921384789a401a932b8fe3863db67d64da318" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chgems . gem env")
    assert_match "rubygems.org", output
  end
end
