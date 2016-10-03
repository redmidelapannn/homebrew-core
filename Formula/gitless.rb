class Gitless < Formula
  desc "Gitless: a version control system"
  homepage "http://gitless.com/"
  url "https://github.com/sdg-mit/gitless/releases/download/v0.8.3/gl-v0.8.3-darwin-x86_64.tar.gz"
  version "0.8.3"
  sha256 "4b5cdc00da5fe93a12904c9992a332484201b979687ce9cce5160576c7cb2048"

  bottle do
    cellar :any_skip_relocation
    sha256 "432867161de1375aef2d72c14aace02267c374b145fad487943bdfcdf78744d5" => :sierra
    sha256 "432867161de1375aef2d72c14aace02267c374b145fad487943bdfcdf78744d5" => :el_capitan
    sha256 "432867161de1375aef2d72c14aace02267c374b145fad487943bdfcdf78744d5" => :yosemite
  end

  def install
    # The tarball is already compiled.
    # No need to do anything but move it.
    bin.install "gl"
  end

  test do
    # The output of `gl init` has non-ascii characters and will
    # cause the test to fail, so we revert to `gl version`.
    system "#{bin}/gl" " --version"
  end
end
