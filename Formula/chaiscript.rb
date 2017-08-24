class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "http://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.0.0.tar.gz"
  sha256 "ec4b51e30afbc5133675662882c59417a36aa607556ede7ca4736fab2b28c026"
  head "https://github.com/ChaiScript/ChaiScript.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a28e2cc9a48bf2f31d91d8337302dde1f9bbe7b62279b2370626db1f3f7803e6" => :sierra
    sha256 "13c55c4039900f31dbce53e725ba1f194034eed00dc264625896f0f990fd09cd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <chaiscript/chaiscript.hpp>
      #include <chaiscript/chaiscript_stdlib.hpp>
      #include <cassert>
      int main() {
        chaiscript::ChaiScript chai;
        assert(chai.eval<int>("123") == 123);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-std=c++14", "-o", "test"
    system "./test"
  end
end
