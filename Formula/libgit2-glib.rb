class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.25/libgit2-glib-0.25.0.tar.xz"
  sha256 "4a256b9acfb93ea70d37213a4083e2310e59b05f2c7595242fe3c239327bc565"

  bottle do
    sha256 "83913637ba30d03c55456497d542c6d20dc1cd4d3333b947374b543ce5646299" => :sierra
    sha256 "f7d48ff80f4f2c726712fa24fd015821a60bd20fddbf66dd5df9fe30ee57c062" => :el_capitan
    sha256 "1d566b7a4edf3cbef315b9d7c7a17fb90e4aa82cd2bb16a1ae0eb49ca06418bd" => :yosemite
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
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "libgit2"
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
