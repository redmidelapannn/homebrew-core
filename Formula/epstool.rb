class Epstool < Formula
  desc "Edit preview images and fix bounding boxes in EPS files"
  homepage "http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm"
  url "https://src.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/epstool-3.08.tar.gz"
  sha256 "f3f14b95146868ff3f93c8720d5539deef3b6531630a552165664c7ee3c2cfdd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30ff766b51400410c72dbbceeaeb3b77de99107da4a14bb54dad8b56f0efb21d" => :high_sierra
    sha256 "36fdda950988dad3b9e90d417515ac6b0f39066cdc21299fa115a3820321ba91" => :sierra
    sha256 "e4f0fb478fb1c3fe5bac0371aa363c5a83c465a479cdf0330161ba76cef362c2" => :el_capitan
  end

  depends_on "ghostscript"

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end

  test do
    system bin/"epstool", "--add-tiff-preview", "--device", "tiffg3", test_fixtures("test.eps"), "test2.eps"
    assert_predicate testpath/"test2.eps", :exist?
  end
end
