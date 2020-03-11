class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.3.tar.gz"
  sha256 "b248c91d65c7a101b9d6226025f2b4bf3dabe94c0c49ab6d51ce84a22a39622b"
  revision 5
  head "https://github.com/ledger/ledger.git"

  bottle do
    rebuild 1
    sha256 "b5e66f0e6be2d35349cd45cf4462434779a9d7b51355f5a2dac1cbe98c5fb4fc" => :catalina
    sha256 "abc5c9e247bb3d21ee03475014fe1e20168ee9b6340aecc35af62b7e161c0ea5" => :mojave
    sha256 "56e885cbc8d6bfbc635174906412546a417d4f6bce22dba56e2e891421b8f524" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.8"

  uses_from_macos "groff"

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
    ] + std_cmake_args
    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
