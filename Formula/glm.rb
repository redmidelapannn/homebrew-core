class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.7.4/glm-0.9.7.4.zip"
  sha256 "d48a0d732776b0fbfd17f01c830a08b50f07a3226f0cab95fcca5591982a43f2"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0209406f4391c207615d2ba6f18867c72e18a0e3bd8ee81c2b1b9ca9506916e2" => :el_capitan
    sha256 "ffcb19457fbba6ebd45cfd9579712d12402777a460f9e7ea0e659de1b3cc6063" => :yosemite
    sha256 "1b16329c3412ff6fef463e3036d9d04df899e18b3e886c87cedaae95733e1dfb" => :mavericks
  end

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    if build.with? "doxygen"
      cd "doc" do
        system "doxygen", "man.doxy"
        man.install "html"
      end
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
