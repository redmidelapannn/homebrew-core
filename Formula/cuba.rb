class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "da4197a194f7a79465dfb2c06c250caa8e76d731e9d6bdfd2dd6e81c8fc005e0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "67b93420ccb6a29a7ec6b92481fba01a7be66c084d714d4bcb991228ca1b7f4d" => :catalina
    sha256 "a55f06a8b15a8b219f89d74ced5e847b9f4afee313267291ad275a601a0dfc1b" => :mojave
    sha256 "5bb68c2b8c0e4b7d5fdf5c5a7e43c903a42cf93fd17b99c7fa7fd95cab094b32" => :high_sierra
  end

  def install
    ENV.deparallelize # Makefile does not support parallel build
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, "-o", "demo", "-L#{lib}", "-lcuba",
                   "#{pkgshare}/demo/demo-c.c"
    system "./demo"
  end
end
