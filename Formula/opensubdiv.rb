class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_3_3.tar.gz"
  sha256 "2dc81b3a085e692cca3166ac88751e4674a9ddf5b5d7935adf677bb2bd3f2d2f"

  depends_on "cmake" => :build
  depends_on "glfw"

  def install
    # ptex = Formula["ptex"]
    glfw = Formula["glfw"]
    # tbb = Formula["tbb"]
    args = std_cmake_args + %W[
      -DNO_OMP=1
      -DNO_DOC=1
      -DNO_OPENCL=1
      -DNO_CUDA=1
      -DNO_CLEW=1
      -DNO_PTEX=1
      -DNO_TBB=1
      -DNO_EXAMPLES=1
      -DGLFW_LOCATION=#{glfw.opt_prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_CXX_COMPILER=clang++
      -DCMAKE_C_COMPILER=clang
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "Created a pyramid with 5 faces and 5 vertices.", shell_output("#{bin}/tutorials/hbr_tutorial_0")
  end
end
