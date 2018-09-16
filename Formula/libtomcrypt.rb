class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8ba69ac3bd791f3e8a5c51b09dd4676fa469d94b28844940c1c8b41ea70d700f" => :mojave
    sha256 "e689593882eb027b2a5ede0bbd5a1326bda59d583560da8562109bf74439e642" => :high_sierra
    sha256 "c0323baaa9129210094aa9d1888b648e6be497284687738cf05763e4f625735b" => :sierra
    sha256 "fad7f4f3e571a18e8277034196ddced22ec627c976ce388c6476b579a2b2e8f5" => :el_capitan
  end

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
