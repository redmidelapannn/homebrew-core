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
    sha256 "8542bdd6cd7c4fe1adf144925c352b5e7b6e805b42057332709c6754778d509a" => :sierra
    sha256 "f79159e29abddc8b528e32bcb1ac11f14311304eaf37f66c4bb67e9601a4b89c" => :el_capitan
    sha256 "d14cf13af685920eab87d7c9eb587ef67ba9d4e372c4cdaa1efc65559a148273" => :yosemite
  end

  option :universal
  option "32-bit"

  def install
    if build.universal?
      ENV.universal_binary
    elsif build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
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
