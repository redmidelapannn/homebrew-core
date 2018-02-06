class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz"
  version "2.4.1"
  sha256 "594c7f8a83f3502381469d643f7b185882da1dd4bc2280c16502ef980af2a776"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    rebuild 1
    sha256 "fa7e16e2447efa4facb8ca7a3bc82a6d6ef67feb3db38f008963b2f3eb7267e9" => :high_sierra
    sha256 "0b3e8fd8e5ef1837792ac5de2372b88c0c4ee974856ff5d177e949f7f1f57e53" => :sierra
    sha256 "96db14223da38b2f67fcb2331a13e91a12decff85a961b08c585d6017968b2aa" => :el_capitan
  end

  option "with-cairo", "Support PNG depiction"
  option "with-java", "Compile Java language bindings"
  option "with-python", "Compile Python language bindings"
  option "with-wxmac", "Build with GUI"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "python" => :optional
  depends_on "wxmac" => :optional
  depends_on "cairo" => :optional
  depends_on "eigen"
  depends_on "swig" if build.with?("python") || build.with?("java")

  def install
    args = std_cmake_args
    args << "-DRUN_SWIG=ON" if build.with?("python") || build.with?("java")
    args << "-DJAVA_BINDINGS=ON" if build.with? "java"
    args << "-DBUILD_GUI=ON" if build.with? "wxmac"

    # Point cmake towards correct python
    if build.with? "python"
      pypref = `python -c 'import sys;print(sys.prefix)'`.strip
      pyinc = `python -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.strip
      args << "-DPYTHON_BINDINGS=ON"
      args << "-DPYTHON_INCLUDE_DIR='#{pyinc}'"
      args << "-DPYTHON_LIBRARY='#{pypref}/lib/libpython2.7.dylib'"
    end

    args << "-DCAIRO_LIBRARY:FILEPATH=" if build.without? "cairo"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
    (pkgshare/"java").install lib/"openbabel.jar" if build.with? "java"
  end

  def caveats
    <<~EOS
      Java libraries are installed to #{opt_pkgshare}/java so this path should
      be included in the CLASSPATH environment variable.
    EOS
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
