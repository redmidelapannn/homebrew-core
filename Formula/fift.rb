class Fift < Formula
  desc "Interpreter for the stack-based programming language Fift"
  homepage "https://github.com/ton-blockchain/ton"
  url "https://github.com/ton-blockchain/ton.git",
    :revision => "47814dca3d4d7d253f0dcbb2ef176f45aafc6871"
  version "0.0.1"
  head "https://github.com/ton-blockchain/ton.git"

  bottle do
    cellar :any
    sha256 "bd3c9fa5b147110b47cf5528e7e08b72457150b98ed912e4d2308c9c757e31cf" => :mojave
    sha256 "b01ffdb028fcb5ddb60edcf23b18c42a570b6a77c54c65122d2b1aeabfcca8eb" => :high_sierra
    sha256 "cd78db078792c39b582429f7d95cefe05aaa6dbcd05eb9a1a4137fa0a2333feb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "cmake", "--build", ".", "--target", "fift"

      bin.install "crypto/fift"
      pkgshare.install Dir[buildpath/"crypto/smartcont/*"]
      (include/"Fift").install Dir[buildpath/"crypto/fift/lib/*"]
    end
  end

  def caveats; <<~EOS
    If you don't want to specify -I"/urs/local/include/Fift" every time:
      echo 'export FIFTPATH="/usr/local/include/Fift"' >> ~/.bash_profile
  EOS
  end

  test do
    system "#{bin}/fift", "-I/usr/local/include/Fift", "/usr/local/share/fift/new-wallet.fif"
    assert_predicate testpath/"new-wallet-query.boc", :exist?
    assert_predicate testpath/"new-wallet.addr", :exist?
    assert_predicate testpath/"new-wallet.pk", :exist?
  end
end
