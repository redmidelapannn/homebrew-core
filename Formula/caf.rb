class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.5.tar.gz"
  sha256 "2dd710366ee03f9b23f3aaea2ed4bdc0c39c5e503819b870785186f54751cf86"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eaca4d43708d21e881869da9d9d5c637f4b345e0aaa9b41f19a58e7492913c22" => :high_sierra
    sha256 "91156d7fa09275999fb64c3b8fd00108b1a7f2f7a868b311e17fcd4ea12f06dd" => :sierra
    sha256 "9652923626e0508ad939234e6a69381dc8d921eeb1b3f0d54d99d44b70442d43" => :el_capitan
  end

  needs :cxx11

  option "with-opencl", "build with support for OpenCL actors"
  option "without-test", "skip unit tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build

  def install
    args = %W[--prefix=#{prefix} --no-examples --build-static]
    args << "--no-opencl" if build.without? "opencl"

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
        self->await_all_other_actors_done();
      }
      CAF_MAIN()
    EOS
    ENV.cxx11
    system *(ENV.cxx.split + %W[test.cpp -L#{lib} -lcaf_core -o test])
    system "./test"
  end
end
