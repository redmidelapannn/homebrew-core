class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.24/libgit2-glib-0.24.0.tar.xz"
  sha256 "d616c268821c28ff8dc1a6419dbf8555fa48e31dc6509c10f5151be7690f4845"

  bottle do
    sha256 "8a7e945cb4df11e302a540ba1210fd25644eaa812bf6389bd63016a4f51608a0" => :el_capitan
    sha256 "d2b9e10ea55778e78efb65d685e5de9edf93b858bd70e5314dcc0f7d9b0f7d53" => :yosemite
    sha256 "8697c9f5ef67697bc76a1901be7796330bdee106f1cda90758795134241c8481" => :mavericks
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2" => "with-libssh2"
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on :python => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python"
    args << "--enable-vala=no" if build.without? "vala"

    system "./autogen.sh", *args if build.head?
    system "./configure", *args if build.stable?
    system "make", "install"

    libexec.install "examples/.libs", "examples/clone", "examples/general", "examples/walk"
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
