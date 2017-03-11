class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/aide/aide/0.16/aide-0.16.tar.gz"
  sha256 "a81c53a131c4fd130b169b3a26ac35386a2f6e1e014f12807524cc273ed97345"

  bottle do
    rebuild 1
    sha256 "27de0687fcd730ca0b3a656577f6d2ccd27aa9178d85fb36cd934d2845f2e3ba" => :sierra
    sha256 "86a1ade208f32231f8588ff8780392bfadf8f3f6ead26a8d4472f3d39fe632f7" => :el_capitan
    sha256 "ffd99d6f428b0786b15efe4a618fcaad25187144511852ec3f2c9f4370249a1e" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/aide/code.git"
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
