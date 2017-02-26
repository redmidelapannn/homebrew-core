class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "http://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/openexr-2.2.0.tar.gz"
  sha256 "36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231"

  bottle do
    cellar :any
    rebuild 2
    sha256 "1adb3357313483b53d485323ea6ca4b346145552cf6b5a6fcf794ef6ba6d4cff" => :sierra
    sha256 "97484047937400fa082383c0834ec2f70e2f03d017af788b9783d38b4b1cc716" => :el_capitan
    sha256 "c5a55c6fcfd201b6965d2eef20a5e8bd4f7473de0c3b14eda0ac15a928df7fc4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  # Fixes builds on 32-bit targets due to incorrect long literals
  # Patches are already applied in the upstream git repo.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f1a3ea4f69b7a54d8123e2f16488864d52202de8/openexr/64bit_types.patch"
    sha256 "c95374d8fdcc41ddc2f7c5b3c6f295a56dd5a6249bc26d0829548e70f5bd2dc9"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
