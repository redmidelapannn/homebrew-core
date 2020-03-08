class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.0.4.tar.gz"
  sha256 "b56b441eb49755b39f0ba194b81047f7596540ee23c1caa8aa1b963f1bded9f5"

  bottle do
    cellar :any
    sha256 "7a281556a93976c882ae934e557a5822bf45f8c3bb4baf79ae2afff42b501a0c" => :catalina
    sha256 "52d95192c6a996186c15ad334b38f0b1ecc5d1f6c4dc0d77ef7f40316aead94b" => :mojave
    sha256 "a3b84c297e5ed6aeda9946841c3f267f2db3131b36ba16d32ef24678053149e6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"
    ENV.append "CXXFLAGS", "-std=c++17"

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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
