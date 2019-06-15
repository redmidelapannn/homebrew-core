class Liblemon < Formula
  desc "Library for Efficient Modeling and Optimization in Networks"
  homepage "https://lemon.cs.elte.hu"
  url "https://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz"
  sha256 "71b7c725f4c0b4a8ccb92eb87b208701586cf7a96156ebd821ca3ed855bad3c8"
  bottle do
    cellar :any_skip_relocation
    sha256 "705bae4e313695ab0941a87526fe32d2298c8e3cd17deb569b73069a8c0aa960" => :mojave
    sha256 "ca35ca236801ac3a7bae658895365f93b8e1e95ffcdb10a074acfafad63876b5" => :high_sierra
    sha256 "231f0d46905623b7afaf70f118fa5a2efe22631211930403a54dadcfe367703d" => :sierra
  end

  depends_on "cmake" => :build
  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <lemon/list_graph.h>
      using namespace std;
      using namespace lemon;
      int main()
      {
        ListDigraph g;
        ListDigraph::Node u = g.addNode();
        ListDigraph::Node v = g.addNode();
        ListDigraph::Arc  a = g.addArc(u, v);
        cout << countNodes(g) << ','
             << countArcs(g) << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test"
    assert_equal %w[2,1], shell_output("./test").split
  end
end
