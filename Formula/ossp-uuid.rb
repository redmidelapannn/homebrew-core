class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "https://web.archive.org/web/www.ossp.org/pkg/lib/uuid/"
  url "https://deb.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "67eb4b4287889d652dedbc626d6530e0bd3c1d4cc24cdb03f56253bab6fd9e73" => :mojave
    sha256 "5e1623f33cf3b48b041f44dee6f310a7ae07ca271b94e2db1711d15849c2561f" => :high_sierra
    sha256 "d6ce4bb9c425e2d6107e33b75f1c0f81834817cd7702d4bbcf79a52da5c928d0" => :sierra
  end

  def install
    # upstream ticket: http://cvs.ossp.org/tktview?tn=200
    # pkg-config --cflags uuid returns the wrong directory since we override the
    # default, but uuid.pc.in does not use it
    inreplace "uuid.pc.in" do |s|
      s.gsub! /^(exec_prefix)=\$\{prefix\}$/, '\1=@\1@'
      s.gsub! %r{^(includedir)=\$\{prefix\}/include$}, '\1=@\1@'
      s.gsub! %r{^(libdir)=\$\{exec_prefix\}/lib$}, '\1=@\1@'
    end

    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{include}/ossp",
                          "--without-perl",
                          "--without-php",
                          "--without-pgsql"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uuid-config", "--version"
  end
end
