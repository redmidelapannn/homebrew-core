class Sloccount < Formula
  desc "Count lines of code in many languages"
  homepage "https://www.dwheeler.com/sloccount/"
  url "https://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz"
  sha256 "fa7fa2bbf2f627dd2d0fdb958bd8ec4527231254c120a8b4322405d8a4e3d12b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d725f0dd879edb01054d89a8bb2cbe6e36c0abe906cfad6cfc0e81507b11e714" => :sierra
    sha256 "542eb590a087184dc2763ea758501a52ac4d5a9b163db11b6a3c24c969b4e4e8" => :el_capitan
    sha256 "ce91cfa08feb6b0e729edc3520961a4db49b7a4d739e50a5b5f62a6a3f27ef2f" => :yosemite
  end

  depends_on "md5sha1sum"

  patch :DATA

  def install
    rm "makefile.orig" # Delete makefile.orig or patch falls over
    bin.mkpath # Create the install dir or install falls over
    system "make", "install", "PREFIX=#{prefix}"
    (bin+"erlang_count").write "#!/bin/sh\ngeneric_count '%' $@"
  end
end

__END__
diff --git a/break_filelist b/break_filelist
index ad2de47..ff854e0 100755
--- a/break_filelist
+++ b/break_filelist
@@ -205,6 +205,7 @@ $noisy = 0;            # Set to 1 if you want noisy reports.
   "hs" => "haskell", "lhs" => "haskell",
    # ???: .pco is Oracle Cobol
   "jsp" => "jsp",  # Java server pages
+  "erl" => "erlang",
 );
