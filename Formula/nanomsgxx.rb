class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "abcbed3702c49370288cf9200acb1eee644365c8788b7116fa038583211567c6" => :high_sierra
    sha256 "87f60bb0fa3367a3994aa33a9ade34a0e9797c8654a865d3a03b92ef0dcff5d4" => :sierra
    sha256 "5c31844bb296bfbe1e7456b66cd6570612f8fdeff30ab9789fc7c7b370cebf1d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  depends_on "nanomsg"

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
