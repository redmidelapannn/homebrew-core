class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.15.0.tar.gz"
  sha256 "07977be690b512ea11fc40d5b8bfa0a7a8507ce9053a615c2bc4725d355ef9a8"

  bottle do
    cellar :any
    sha256 "6650dda3deb2d0e71c09fe30ed2a0f05e76272d6bca9f20a60b9890f5fd02c03" => :catalina
    sha256 "b3b3491811bf7fe88b91d76380eaaa237a8b9ab56d810a66e6429c3ba716086c" => :mojave
    sha256 "4bc96700812d10524da305ee864c2d215f437630e83a811476d53da619eadb25" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  def install
    ENV.cxx11
    system "cmake", ".", "-DPAGMO_WITH_EIGEN3=ON", "-DPAGMO_WITH_NLOPT=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      #include <pagmo/algorithm.hpp>
      #include <pagmo/algorithms/sade.hpp>
      #include <pagmo/archipelago.hpp>
      #include <pagmo/problem.hpp>
      #include <pagmo/problems/schwefel.hpp>

      using namespace pagmo;

      int main()
      {
          // 1 - Instantiate a pagmo problem constructing it from a UDP
          // (user defined problem).
          problem prob{schwefel(30)};

          // 2 - Instantiate a pagmo algorithm
          algorithm algo{sade(100)};

          // 3 - Instantiate an archipelago with 16 islands having each 20 individuals
          archipelago archi{16, algo, prob, 20};

          // 4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

          // 5 - Wait for the evolutions to be finished
          archi.wait_check();

          // 6 - Print the fitness of the best solution in each island
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++11", "-o", "test"
    system "./test"
  end
end
