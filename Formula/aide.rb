class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.sourceforge.io"
  url "https://downloads.sourceforge.net/project/aide/aide/0.16/aide-0.16.tar.gz"
  sha256 "a81c53a131c4fd130b169b3a26ac35386a2f6e1e014f12807524cc273ed97345"

  bottle do
    rebuild 1
    sha256 "f677959c7233966293189adf233f6541e60e8299dc289d04ea3d290f17194c5d" => :sierra
    sha256 "681d689b2ff4bb05979ff587bee151b2f82e239780a9fe6c5e585592af6e348d" => :el_capitan
    sha256 "125167e73424a43c6ddb35cb3e8a6dea702f12c1c3720244d0530323ef9f8bf0" => :yosemite
  end

  head do
    url "http://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  def install
    system "sh", "./autogen.sh" if build.head?

    system "./configure", "--disable-lfs",
                          "--disable-static",
                          "--with-curl",
                          "--with-zlib",
                          "--sysconfdir=#{etc}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<-EOS.undent
      database = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      summarize_changes = yes
      grouped = yes
      verbose = 7
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
