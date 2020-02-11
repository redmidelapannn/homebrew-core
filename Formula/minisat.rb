class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"

  head "https://github.com/stp/minisat.git", :branch => "master"

  stable do
    url "https://github.com/stp/minisat/archive/releases/2.2.1.tar.gz"
    sha256 "432985833596653fcd698ab439588471cc0f2437617d0df2bb191a0252ba423d"
  end
  bottle do
    cellar :any
    sha256 "625baa3aa506d56fd3f071c491434000e7a1a02c48b97b31d4b7784218a26df6" => :catalina
    sha256 "d3f04e4cd97af8ff4a166434cbba56d7c28c90fe88180048a3bdfb185ec0f49b" => :mojave
    sha256 "87ba4850c49a187f27b74e27c3ebb5d9a6381b59e6e18b9739045ad3151061a8" => :high_sierra
  end


  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-DSTATIC_BINARIES=ON",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                      ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    dimacs = <<~EOS
      p cnf 3 2
      1 -3 0
      2 3 -1 0
    EOS

    assert_match(/^SATISFIABLE$/, pipe_output("#{bin}/minisat", dimacs, 10))
  end
end
