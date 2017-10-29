class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/5.0.1.tar.gz"
  sha256 "21ba7167aeeb76142c0e865127514b4834cefde45eaab2d5eb79099188e21a06"

  bottle do
    cellar :any
    sha256 "efe0f721535aa8fd9b12c00d0fc1f4287dbb3deab3876ddd3e0bbab48240dc0f" => :high_sierra
    sha256 "e30cd060740fa789788e26e4f119cfb3be1d12bef828a59d229cd432bbe92f7c" => :sierra
    sha256 "0610ab24156231981a0c81efa4526f654959928f08e3c89e226dd7b6a66e4374" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lpqxx", "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
