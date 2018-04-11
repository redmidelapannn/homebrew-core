class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://download.savannah.nongnu.org/releases/openexr/openexr-2.2.1.tar.gz"
  sha256 "8f9a5af6131583404261931d9a5c83de0a425cb4b8b25ddab2b169fbf113aecd"

  bottle do
    cellar :any
    sha256 "1d4ff5f87d9bf1722b17b7ad7748c74d863dcd4747b2f13372e0b9865f6d5cb3" => :high_sierra
    sha256 "007444b2148348d41277da2bdff8de38f6e0a10065b16693fa4893192f54b178" => :sierra
    sha256 "af3beb5ec83a109dc93557837ad5ece3d2322e301fabc29b86efc9fb959f9ba1" => :el_capitan
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
