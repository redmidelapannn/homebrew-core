class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.27.tar.gz"
  sha256 "40d3192f8f130f227b511fc80be86310c7f60ccb6d043b563f201fa505de0876"
  head "https://git.notmuchmail.org/git/notmuch", :using => :git

  bottle do
    cellar :any
    rebuild 3
    sha256 "9d53087c4c3ca5ee8e74ba5a504af5c44d6659f6d7f3b1f6bfdaeb04f9b4ff38" => :mojave
  end

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "emacs"
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
      --with-emacs
      --emacslispdir=#{elisp}
      --emacsetcdir=#{elisp}
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
