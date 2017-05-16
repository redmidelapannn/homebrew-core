class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz"
  sha256 "108532fb94c6f227558d45be3f3347b52539f0f58290a7bb31ec06c462d05326"
  version_scheme 1
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8f6e8d32ef30e7822049bed1078817668c29857890bd7e6f5d09c90b137fbb2a" => :sierra
    sha256 "50a28584c99b960dda37328a404a2d8fc5caf637e5b8e25a3230b4a615dea28b" => :el_capitan
    sha256 "4dc083eea2884da596acb301cbe1758759cb3b78ab7a7f592b126555d9f97560" => :yosemite
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "test", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
    (lib/"pkgconfig/lmdb.pc").write(lmdb_pc)
  end

  def lmdb_pc; <<-EOS.undent
    prefix=#{prefix}
    exec_prefix=#{prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include

    Name: liblmdb
    Description: Lightning Memory-Mapped Database
    URL: https://symas.com/products/lightning-memory-mapped-database/
    Version: #{version}
    Libs: -L${libdir} -llmdb
    Cflags: -I${includedir}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
