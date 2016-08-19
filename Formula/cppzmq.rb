class Cppzmq < Formula
  desc "C++ bindings for ZeroMQ"
  homepage "https://github.com/zeromq/cppzmq"
  url "https://github.com/zeromq/cppzmq/archive/92d2af6def80a01b76d5e73f073c439ad00ab757.tar.gz"
  sha256 "fa1c8d33367919edff6ea8d3de5a29e3227532092c77976806bfe3d89c3f83ec"
  bottle do
    cellar :any_skip_relocation
    sha256 "614f0b7d1a470c4ec0485c4ac3948b45889ab8a45de46e0ff2cb471f51ed8e46" => :el_capitan
    sha256 "b9bceed00911f4b83bc57d0bb6bdfe7e4f53763bd6496dbd07e7c7f8020650b2" => :yosemite
    sha256 "b9bceed00911f4b83bc57d0bb6bdfe7e4f53763bd6496dbd07e7c7f8020650b2" => :mavericks
  end

  depends_on "zeromq"

  def install
    include.install "zmq.hpp"
    include.install "zmq_addon.hpp"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <zmq.hpp>
      #include <iostream>
      int main()
      {
        int major=0, minor=0, patch=0;
        zmq::version(&major, &minor, &patch);
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lzmq", "-o", "test"
  end
end
