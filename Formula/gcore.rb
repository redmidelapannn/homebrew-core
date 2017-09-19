class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8533fa1b02ab0ae18891e2f6affd16c99353fb79462ea3da9d862a682f25c98" => :sierra
    sha256 "7e5b96be788624db7ed63fd5782f2f85e94d5485b92bbbc4403f1df5c8d53808" => :el_capitan
  end

  keg_only :provided_by_osx if MacOS.version >= :sierra

  def install
    system "make"
    bin.install "gcore"
  end

  test do
    assert_match "<pid>", shell_output("#{bin}/gcore 2>&1", 22)
  end
end
