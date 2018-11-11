class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz"
  version "2.4.1"
  sha256 "594c7f8a83f3502381469d643f7b185882da1dd4bc2280c16502ef980af2a776"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    rebuild 1
    sha256 "6be1de17635f2fcb37251d8bb525e7633893a26ff8cc3feee7f22a51c1be887e" => :mojave
    sha256 "920cd1e049c1e8d83f6a8b58f5b3d048e23939692d69fc6bfb615f4bb805faf6" => :high_sierra
    sha256 "2063bea0d51c97d374fd636b91298670c226e31241806ea78f4b28b0b0b52c49" => :sierra
  end

  option "with-cairo", "Support PNG depiction"
  option "with-java", "Compile Java language bindings"
  option "with-python@2", "Compile Python 2 language bindings"
  option "with-wxmac", "Build with GUI"

  deprecated_option "with-python" => "with-python@2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "cairo" => :optional
  depends_on "python@2" => :optional
  depends_on "swig" if build.with?("python@2") || build.with?("java")
  depends_on "wxmac" => :optional

  def install
    args = std_cmake_args
    args << "-DRUN_SWIG=ON" if build.with?("python@2") || build.with?("java")
    args << "-DJAVA_BINDINGS=ON" if build.with? "java"
    args << "-DBUILD_GUI=ON" if build.with? "wxmac"

    # Point cmake towards correct python
    if build.with? "python@2"
      ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
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
