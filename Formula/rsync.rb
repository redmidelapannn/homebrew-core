class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.1.2.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.1.2.tar.gz"
  sha256 "ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2"
  revision 1

  bottle do
    sha256 "c09960e7748c16d6f3f3d3c3450139f46f2976f17d772f4e1d426ff8d5057350" => :high_sierra
    sha256 "a76ca31b6aa66924e642cae098303848a18409ebfe42074a81f483926113cfdb" => :sierra
    sha256 "7e3c30ccd7b95aab3e5f70e2691e2909c65a40cdae641ea637a3ea1e2422a68a" => :el_capitan
  end

  depends_on "autoconf" => :build

  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.1.2.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.1.2.tar.gz"
    mirror "https://launchpad.net/rsync/main/3.1.2/+download/rsync-patches-3.1.2.tar.gz"
    sha256 "edeebe9f2532ae291ce43fb86c9d7aaf80ba4edfdad25dce6d42dc33286b2326"
    apply "patches/fileflags.diff",
          "patches/crtimes.diff",
          "patches/hfs-compression.diff"
  end

  # Fix CVE-2017-16548, CVE-2017-17433, CVE-2017-17434, CVE-2017-17434.
  # All these patches are upstream & should be in the next release.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rsync/rsync_3.1.2-2.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/r/rsync/rsync_3.1.2-2.1.debian.tar.xz"
    sha256 "589213bd77aecb51ee39501d65a9f2b3efb6c349aa73ec912259d52702ae2b97"
    apply "patches/0001-Enforce-trailing-0-when-receiving-xattr-name-values.patch",
          "patches/0002-Check-fname-in-recv_files-sooner.patch",
          "patches/0003-Sanitize-xname-in-read_ndx_and_attrs.patch",
          "patches/0004-Check-daemon-filter-against-fnamecmp-in-recv_files.patch"
  end

  def install
    system "./prepare-source"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-rsyncd-conf=#{etc}/rsyncd.conf",
                          "--enable-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"rsync", "--version"
  end
end
