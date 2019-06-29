class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2017.09.06.tar.gz"
  sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"
  head "https://github.com/stevedekorte/io.git"

  bottle do
    rebuild 1
    sha256 "ae69b72617fd73562cad37b96892cd4e4665b5db9244e41d61a9fcbda834c8a7" => :mojave
    sha256 "92051e6636658406516630bc364ecd151ca6addba70ace7d47ce0e25f69a875d" => :high_sierra
    sha256 "50c97f9fea8fbea14ad781116b05d90edbc803aec7de9eebb94ae7beac52e1ba" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    # Turn off all add-ons in main cmake file
    inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                "#add_subdirectory(addons)"

    mkdir "buildroot" do
      system "cmake", "..", "-DCMAKE_DISABLE_FIND_PACKAGE_ODE=ON",
                            "-DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.io").write <<~EOS
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
