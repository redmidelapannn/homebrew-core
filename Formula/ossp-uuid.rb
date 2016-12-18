class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "http://www.ossp.org/pkg/lib/uuid/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/o/ossp-uuid/ossp-uuid_1.6.2.orig.tar.gz"
  mirror "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz"
  sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "339eb3d36bad11d57615b69867da4caa6fa0f54bf03414f3475f7b984bad1dc9" => :sierra
    sha256 "465434ae5285d0d4271c673994ae4fd9a9298767cb33fddc64af9b6279b83cd0" => :el_capitan
    sha256 "4cb064dee95724ac243f456aeb7ebe104fa562c6d2b78f16f4313aed7e23d148" => :yosemite
  end

  option :universal

  def install
    if build.universal?
      ENV.universal_binary
    end

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
end
