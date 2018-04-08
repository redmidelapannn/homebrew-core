class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.6.0.tar.gz"
  sha256 "511da31d1f985cf0c79b2de05bda4e057371ba519769d1546ff71e1304fe53c9"
  revision 1
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e57532ddd6e5440ea8b9da9cad0dcd01a0f8d6834764a35f549eb214cb725fdc" => :high_sierra
    sha256 "03f74dca3cf6d463acc4d482fb34953b75282a3909005108ae27f628a8c6641c" => :sierra
    sha256 "59533a4e39d191ff08816daf27cd77903dc3454930826bc8b91f15e3e8011126" => :el_capitan
  end

  option "without-python@2", "Build without python 2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended
  depends_on "python" => :optional

  def install
    if build.without?("python") && build.without?("python@2")
      odie "z3: --with-python must be specified when using --without-python@2"
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
