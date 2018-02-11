class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2017.09.06.tar.gz"
  sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"
  head "https://github.com/stevedekorte/io.git"

  bottle do
    rebuild 1
    sha256 "d7fe003b6f14045a76695c777172681e37575a9ba09750715899ad4f29f6a679" => :high_sierra
    sha256 "8f8af5355fb393f945ab8203624bb3a3085da9a141dbfc3cbdfe48e8bc48fd38" => :sierra
    sha256 "88ecbd8f780934304d99f2ec60322f76f1014268231474c68a24c21ad30b551a" => :el_capitan
  end

  option "without-addons", "Build without addons"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  if build.with? "addons"
    depends_on "glib"
    depends_on "cairo"
    depends_on "gmp"
    depends_on "jpeg"
    depends_on "libevent"
    depends_on "libffi"
    depends_on "libogg"
    depends_on "libpng"
    depends_on "libsndfile"
    depends_on "libtiff"
    depends_on "libvorbis"
    depends_on "ossp-uuid"
    depends_on "pcre"
    depends_on "yajl"
    depends_on "xz"
    depends_on "python" => :optional
  end

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    if build.without? "addons"
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  "#add_subdirectory(addons)"
    else
      inreplace "addons/CMakeLists.txt" do |s|
        if build.without? "python"
          s.gsub! "add_subdirectory(Python)", "#add_subdirectory(Python)"
        end

        # Turn off specific add-ons that are not currently working

        # Looks for deprecated Freetype header
        s.gsub!(/(add_subdirectory\(Font\))/, '#\1')
        # Builds against older version of memcached library
        s.gsub!(/(add_subdirectory\(Memcached\))/, '#\1')
      end
    end

    mkdir "buildroot" do
      system "cmake", "..", "-DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON",
                            *std_cmake_args
      system "make"
      output = `./_build/binaries/io ../libs/iovm/tests/correctness/run.io`
      if $CHILD_STATUS.exitstatus.nonzero?
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
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
