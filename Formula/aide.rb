class Aide < Formula
  desc "File and directory integrity checker"
  homepage "http://aide.sourceforge.net"
  url "https://downloads.sourceforge.net/project/aide/aide/0.15.1/aide-0.15.1.tar.gz"
  sha256 "303e5c186257df8c86e418193199f4ea2183fc37d3d4a9098a614f61346059ef"

  bottle do
    cellar :any
    revision 1
    sha256 "ab766d10320672df87b6245b99607fe289befbac1e516cdd7bbbed68f9c33a0e" => :el_capitan
    sha256 "ddf06b898feac8587ddefa94d0a459bfb974f0ef504cff27b9f10ec4150f0024" => :yosemite
    sha256 "206323255d59deedfe1c8320d40a73ab4b3b87bb122bc1c005b354e072dcf5fe" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/aide/devel/0.16b1/aide-0.16b1.tar.gz"
    sha256 "35d99899d8b7cd723ac744b8cbd8d5f911ec22a4b568134dd0b6f7116d21b566"

    depends_on "pcre"
  end

  head do
    url "http://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "pcre"
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"

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
