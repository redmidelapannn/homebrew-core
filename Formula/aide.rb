class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.16.2/aide-0.16.2.tar.gz"
  sha256 "17f998ae6ae5afb9c83578e4953115ab8a2705efc50dee5c6461cef3f521b797"

  bottle do
    cellar :any
    rebuild 1
    sha256 "967ce0e2594eacb11ef92cb0574b71731ac37f88aea769879e7b323b67463cae" => :mojave
    sha256 "37dfc7c751cc64d278d199d11e17cb46f685207222f7b17b02ed63cf9192d48c" => :high_sierra
    sha256 "42ab164c9e6041fc3d41e758c04c8909e532b769ebdb84c5711c386fc68beba6" => :sierra
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"
  uses_from_macos "curl"

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
    (testpath/"aide.conf").write <<~EOS
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
