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
    sha256 "2479fecf209528e4a8ea9af3a692c28b32fe775f3ee4b9bf391887ae942cb9e1" => :sierra
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "test", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
    (buildpath/"lmdb.pc").write(lmdb_pc)
    (lib/"pkgconfig").install "lmdb.pc"
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
