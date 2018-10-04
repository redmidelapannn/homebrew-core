class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.16.0.tar.gz"
  sha256 "36e37971c399892302b738de18cbf3dd9049956228ede91cb09131eb5a18aa7f"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3c870430539bf8a35a02e71082cd392b5e36fa24fe73b71d4e57182214e22c51" => :mojave
    sha256 "9aaf1ded7634f7a32f8fe2edcdb49cf1c95cbe934f50486d2f34f96bea43c260" => :high_sierra
    sha256 "7f36bd18d8613a2e6cf5bff82e1725715709eb971eab71138c86de93383929ac" => :sierra
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    system "./configure", "--prefix=#{prefix}", "--no-examples",
                          "--build-static", "--no-opencl"
    system "make"
    system "make", "test"
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
