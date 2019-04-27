class Packcc < Formula
  desc "A packrat parser generator for C"
  homepage "https://sourceforge.net/projects/packcc/"
  url "https://master.dl.sourceforge.net/project/packcc/packcc-1.2.0/packcc.c"
  sha256 "06e2dc028e7021c46c750c1ee74fe03b308c79785bce4f30bbe1e5a2ed1853e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a81c1964d091d839ca62b67339eca2f1b15d0e501df2205d7ecc05c5effbe003" => :mojave
    sha256 "3b1b31225d7a5b24bcc99d64f91aa41d5c426edf9d50ffce610e9715d649c792" => :high_sierra
    sha256 "18f88d6a674fa7178aef59a5e616c41c45651f9f351f40b979b56b7bb3049f90" => :sierra
  end

  def install
    system "cc", "-o", "packcc", "packcc.c"
    bin.install "packcc"
  end

  test do
    system "#{bin}/packcc", "-v"
  end
end
