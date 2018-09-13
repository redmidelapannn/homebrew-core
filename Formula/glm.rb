class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.1/glm-0.9.9.1.zip"
  sha256 "10f1471d69ec09992f400705bedc9f5121e17a2c8fd6f9591244bb5ee1104a10"
  revision 1
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2779aa1be5b31d6c337f55ba0997cded4df0bc45fddc048818b8fb0ca4cead5" => :mojave
    sha256 "d5d0aa50ea74908b895e31c26dbee5a3b6812198d92757af01021371b6670558" => :high_sierra
    sha256 "af5b2dbb9223d279a735851dbac213100366eebdec57fac09db63a2fc0b86a1e" => :sierra
    sha256 "fc63a7a75d86be016dd5006c791ca21c8048c36fbba4ed98a81caa23eaf74278" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    cd "doc" do
      system "doxygen", "man.doxy"
      man.install "html"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
