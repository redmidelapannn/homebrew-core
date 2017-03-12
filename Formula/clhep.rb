class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.3.1.tgz"
  sha256 "cd74bfae4773620dd0c7cc9c1696a08386931d7e47a3906aa632cc5cb44ed6bd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e6fa7344834bb3eaae482c07fa9a92efb08b3ad18d0fb1f8badf29196dd8b04a" => :sierra
    sha256 "181b8f3def5ba5beb65be846095c3022d558ac0ecbe32e66884b54ef8a6b7963" => :el_capitan
    sha256 "b89c11c1a75fda226dfb14aedb4c814b5122a8c5179966daca66d04865b9dfc3" => :yosemite
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "cmake" => :build

  def install
    # CLHEP is super fussy and doesn't allow source tree builds
    dir = Dir.mktmpdir
    cd dir do
      args = std_cmake_args
      if build.stable?
        args << buildpath/"CLHEP"
      else
        args << buildpath
      end
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end
