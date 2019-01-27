class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.10.tar.xz"
  sha256 "c625a83b4838befc8cafcd54e3619946515d9e44d63d61c4adf7f5513ddfbebf"
  revision 1

  bottle do
    cellar :any
    sha256 "3b97366f3a19b2a29b5c480c7a315547a43fbb5a19618d7c2713127136e5b106" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/shared-mime-info.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "intltool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    # Disable the post-install update-mimedb due to crash
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-update-mimedb
    ]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
    pkgshare.install share/"mime/packages"
    rmdir share/"mime"
  end

  def post_install
    #(HOMEBREW_PREFIX/"share/mime/packages").mkpath
    system "mkdir", "-p", HOMEBREW_PREFIX/"share/mime/packages"
    #ln_sf HOMEBREW_PREFIX/"share/mime", share/"mime"
    system "ln", "-sf", HOMEBREW_PREFIX/"share/mime", share/"mime"
    #cp (pkgshare/"packages").children, HOMEBREW_PREFIX/"share/mime/packages"
    system "cp", pkgshare/"packages/freedesktop.org.xml", HOMEBREW_PREFIX/"share/mime/packages/"
    system bin/"update-mime-database", HOMEBREW_PREFIX/"share/mime"
  end

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
