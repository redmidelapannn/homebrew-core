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
    sha256 "41b63d1ce67f3e471facd32c5d99fd41db6e7543ad8d887d9f05f368fe5d69e5" => :sierra
    sha256 "057759f1feec32c088b6f712e8809b026c43503ed8716de5064e7c39b0ef42db" => :el_capitan
    sha256 "51dfca90e862be5135afef974c85e5a1efef49676a5a322b687ccc7056557356" => :yosemite
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
end
