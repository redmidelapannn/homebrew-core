class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/3.0.tar.gz"
  sha256 "91653d09a90440a0bc35aa490d0c44973501257577451d4c445b2df5e78d118c"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02f7bbe8f90f26f7e09c3eaed72420a31af728c937f200cfd1eba5cc4291313b" => :sierra
    sha256 "2ed57943aef9ae454d0568b15b6761795b8d204a632ec107f9aa69ce098be435" => :el_capitan
    sha256 "9ae97ed844426a7004e0489dd3394c3c8ea01d5e4d288092751fbe90695c7113" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"

      # Version 3.0 of glslang does not respect the overridden CMAKE_INSTALL_PREFIX. This has
      # been fixed in master [1] so when that is released, the manual install commands should
      # be removed.
      #
      # 1. https://github.com/KhronosGroup/glslang/commit/4cbf748b133aef3e2532b9970d7365304347117a
      bin.install Dir["install/bin/*"]
      lib.install Dir["install/lib/*"]
    end
  end

  test do
    (testpath/"test.frag").write <<-EOS.undent
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS
    (testpath/"test.vert").write <<-EOS.undent
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
