class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.5.0.tar.gz"
  sha256 "aeae1d239c5e06ac183be7dd853775b84698db1265cb2258e5918a28372d4a0c"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "06b8210ae92c5a52f2c1732632a573af23ef59c954462428c0b26c28e12bb3cb" => :sierra
    sha256 "59456c6d62d87047bf582ebdc62b52d3f7a4323a31e27c705afc74b19b10b472" => :el_capitan
    sha256 "8aab04f50ce19a661259a498cda576b702782d9231d2a71a03cc4c8e8fcd4a36" => :yosemite
  end

  option "without-python", "Build without python 2 support"
  option "with-debug", "Build in debug mode"
  option "with-trace", "Build with support for tracing"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    if build.without?("python3") && build.without?("python")
      odie "z3: --with-python3 must be specified when using --without-python"
    end

    Language::Python.each_python(build) do |python, version|
      args = ["--prefix=#{prefix}",
              "--python",
              "--pypkgdir=#{lib}/python#{version}/site-packages",
              "--staticlib"]
      args << "--trace" if build.with? "trace"
      args << "--debug" if build.with? "debug"

      system python, "scripts/mk_make.py", *args
      cd "build" do
        system "make"
        system "make", "install"
      end
    end

    # qprofdiff is not yet part of the source release (it will be as soon as a
    # version is released after 4.5.0), so we only include it in HEAD builds
    if build.head?
      system "make", "-C", "contrib/qprofdiff"
      bin.install "contrib/qprofdiff/qprofdiff"
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
