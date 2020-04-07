class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"

  bottle do
    cellar :any
    sha256 "5a694bb501b0ed43499f4dcb0c4a93ee7171273d1fe486360db698d2eae61f5e" => :catalina
    sha256 "a36375435a33b6828b898b7bab6c78cb32b65dd11391ae7b1db5f93290b2069a" => :mojave
    sha256 "39aa3b98fb315f7928d52cadb5c8d5b72eb898bbf31b17758bd3d0266dc3990a" => :high_sierra
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end
