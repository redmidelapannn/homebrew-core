class Epstool < Formula
  desc "Edit preview images and fix bounding boxes in EPS files"
  homepage "http://www.ghostgum.com.au/software/epstool.htm"
  url "https://src.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/epstool-3.08.tar.gz"
  sha256 "f3f14b95146868ff3f93c8720d5539deef3b6531630a552165664c7ee3c2cfdd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d1c60f6a58de10ffc56c97ea8e43aa8770a10e72951c27889303e4ae399063bd" => :mojave
    sha256 "5e844d50cc7e054fd91d7d1ac12479e24d5efea3c2ead558fa3adf0dbad3ffc9" => :high_sierra
    sha256 "f278c23d8f397e08999244c375786073dc800606c4119a4ef3e31f1c5580620a" => :sierra
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
