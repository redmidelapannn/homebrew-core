class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.27.tar.gz"
  sha256 "40d3192f8f130f227b511fc80be86310c7f60ccb6d043b563f201fa505de0876"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    rebuild 3
    sha256 "6c0a0f4c466249890b73f96f205e4a20cd33fe44f801b3fc7d285cd72e47e20a" => :mojave
    sha256 "58a79bb4fcbee8dacefd20d2e79065671e417b3d13aec048bb5898f16a700054" => :high_sierra
    sha256 "5ee35db6ab7cc2965ab029340774e725f6f5157a053bbad89b6aaf631a3c8536" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@2"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --without-emacs
      --without-ruby
    ]

    # Emacs and parallel builds aren't friends
    ENV.deparallelize

    system "./configure", *args
    system "make", "V=1", "install"

    cd "bindings/python" do
      system "python2.7", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end
