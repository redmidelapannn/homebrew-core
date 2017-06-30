class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.5.0.tar.gz"
  sha256 "aeae1d239c5e06ac183be7dd853775b84698db1265cb2258e5918a28372d4a0c"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4b612382cbd2a60a014bfb055f3521a429ffd5d4effbdcfb0c04085b49624759" => :sierra
    sha256 "87ffd0bfb5225dd1e0ad190d7dddd2a2d39eb01cd7bf00615c894851956412b0" => :el_capitan
    sha256 "0870c374f92f6fea516229187e8e9bc5ba6c3af15e120c8bfdbb2cbb3166e64f" => :yosemite
  end

  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    if build.without?("python3") && build.without?("python")
      odie "z3: --with-python3 must be specified when using --without-python"
    end

    Language::Python.each_python(build) do |python, version|
      system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--python", "--pypkgdir=#{lib}/python#{version}/site-packages", "--staticlib"
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
