class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.4.tar.gz"
  sha256 "2ee41a3a5ae3891601ae975d5ec2642b997d276ef647cf5c5b363b6127f7add8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "31e6580f0f3dae6065eadd98298d226c7b25ed2928a1a78ae94ffcb6d326a4e5" => :mojave
    sha256 "d8c2d45a5f97707beff5a6398eb052454b70dc0c266770292880da313acc10e1" => :high_sierra
    sha256 "6cd32a1d88b068b93162ddae7a82d660322caacad3d1f7f64a2bf226b4095128" => :sierra
    sha256 "5cb2994407fe33695f137ec4a04dac6650e3964a8d1383e7e114f0813a91923f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lebur128", "-o", "test"
    system "./test"
  end
end
